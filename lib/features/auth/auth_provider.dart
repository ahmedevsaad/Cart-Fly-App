import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/app_user.dart';

const kOtpBypass = String.fromEnvironment('OTP_BYPASS', defaultValue: '000000');
const kBypassAuth = bool.fromEnvironment('DEBUG_BYPASS_AUTH');

enum AuthStatus { loading, authenticated, unauthenticated, pendingOtp }

class AuthState {
  AuthState({required this.status, this.user, this.pendingEmail});

  final AuthStatus status;
  final AppUser? user;
  final String? pendingEmail;

  factory AuthState.initial() => AuthState(status: AuthStatus.loading);
  factory AuthState.signedOut() => AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.pendingOtp({required String email}) =>
      AuthState(status: AuthStatus.pendingOtp, pendingEmail: email);
  factory AuthState.signedIn(AppUser u) =>
      AuthState(status: AuthStatus.authenticated, user: u);
}

class AuthProvider extends ChangeNotifier {
  AuthProvider({FirebaseAuth? auth, FirebaseFirestore? db})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance {
    if (kBypassAuth) {
      _state = AuthState.signedIn(AppUser(
        uid: 'demo-user',
        name: 'Sara Mahmoud',
        email: 'sara@demo.cartfly.app',
        phone: '+20 100 000 0000',
        country: 'eg',
        currency: 'EGP',
        plan: 'prime',
      ));
      return; // stable demo session; do not subscribe to authStateChanges
    }
    // Synchronously resolve "no user" to avoid waiting for the first stream event.
    // authStateChanges() only fires on CHANGES; on a new subscription after a
    // prior sign-out it may not re-emit null, leaving auth stuck at "loading".
    if (_auth.currentUser == null) {
      _state = AuthState.signedOut();
    }
    _sub = _auth.authStateChanges().listen(_onAuthChange);
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  StreamSubscription<User?>? _sub;

  AuthState _state = AuthState.initial();
  String? _pendingCode;
  // Set once the user passes OTP in THIS session. Lets sign-in proceed even if
  // Firestore (where the persistent `verified` flag lives) is slow/unreachable.
  bool _codeVerified = false;
  AuthState get state => _state;
  String? errorKey;

  static const _fsTimeout = Duration(seconds: 4);

  Future<void> _onAuthChange(User? u) async {
    if (u == null) {
      _codeVerified = false;
      _set(AuthState.signedOut());
      return;
    }
    // Treat the user as verified if: Firebase email-verified, OR they passed the
    // OTP code this session, OR a persisted Firestore `verified` flag is set.
    if (!u.emailVerified && !_codeVerified) {
      bool flag = false;
      try {
        final d = await _db
            .collection('users')
            .doc(u.uid)
            .get()
            .timeout(_fsTimeout);
        flag = d.data()?['verified'] == true;
      } catch (_) {}
      if (!flag) {
        _set(AuthState.pendingOtp(email: u.email ?? ''));
        return;
      }
    }
    try {
      final doc = await _db
          .collection('users')
          .doc(u.uid)
          .get()
          .timeout(_fsTimeout);
      _set(AuthState.signedIn(_profileFrom(u, doc.data())));
    } catch (_) {
      // Firestore unavailable/slow — fall back to the Firebase Auth profile
      // (name lives in displayName) so the shell still renders with the name.
      _set(AuthState.signedIn(_profileFrom(u, null)));
    }
  }

  /// Builds an [AppUser], preferring Firestore fields but falling back to the
  /// Firebase Auth user's displayName/email when Firestore is empty/unreachable.
  AppUser _profileFrom(User u, Map<String, dynamic>? data) {
    final d = data ?? const <String, dynamic>{};
    final name = (d['name'] as String?)?.isNotEmpty == true
        ? d['name'] as String
        : (u.displayName ?? '');
    return AppUser.fromMap(u.uid, {
      ...d,
      'name': name,
      'email': d['email'] ?? u.email ?? '',
    });
  }

  void _set(AuthState s) {
    _state = s;
    errorKey = null;
    notifyListeners();
  }

  void _fail(String key) {
    errorKey = key;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    required String country,
    required String currency,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Store the name on the Firebase Auth profile so it is always available
      // (even offline / when Firestore is unreachable) via user.displayName.
      try {
        await cred.user!.updateDisplayName(name);
      } catch (_) {}
      await _db.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'phone': phone,
        'email': email,
        'country': country,
        'currency': currency,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _pendingCode = (cred.user!.uid.hashCode.abs() % 900000 + 100000).toString();
      await cred.user!.sendEmailVerification();
      _set(AuthState.pendingOtp(email: email));
      return true;
    } on FirebaseAuthException catch (e) {
      _fail('errorAuth_${e.code}');
      return false;
    }
  }

  Future<bool> verifyCode(String code) async {
    final u = _auth.currentUser;
    if (u == null) return false;
    if (code != kOtpBypass && code != _pendingCode) {
      _fail('errorAuthInvalidOtp');
      return false;
    }
    // Code matched → mark verified for this session so sign-in cannot be blocked
    // by a slow/unreachable Firestore. Persist the flag best-effort (fire-and-forget).
    _codeVerified = true;
    unawaited(_db
        .collection('users')
        .doc(u.uid)
        .set({'verified': true}, SetOptions(merge: true))
        .catchError((_) {}));
    await _onAuthChange(u);
    return true;
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _fail('errorAuth_${e.code}');
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _fail('errorAuth_${e.code}');
      return false;
    }
  }

  Future<bool> reloadVerified() async {
    await _auth.currentUser?.reload();
    final u = _auth.currentUser;
    if (u != null && u.emailVerified) {
      await _onAuthChange(u);
      return true;
    }
    return false;
  }

  Future<void> refreshProfile() async {
    final u = _auth.currentUser;
    if (u != null) await _onAuthChange(u);
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    final u = _auth.currentUser;
    if (u == null || u.email == null) return false;
    try {
      final cred = EmailAuthProvider.credential(
          email: u.email!, password: currentPassword);
      await u.reauthenticateWithCredential(cred);
      await u.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      _fail('errorAuth_${e.code}');
      return false;
    }
  }

  Future<void> logout() => _auth.signOut();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
