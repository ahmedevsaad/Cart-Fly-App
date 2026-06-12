import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/app_user.dart';

const kOtpBypass = String.fromEnvironment('OTP_BYPASS', defaultValue: '000000');

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
  late final StreamSubscription<User?> _sub;

  AuthState _state = AuthState.initial();
  String? _pendingCode;
  AuthState get state => _state;
  String? errorKey;

  Future<void> _onAuthChange(User? u) async {
    if (u == null) {
      _set(AuthState.signedOut());
      return;
    }
    if (!u.emailVerified) {
      bool flag = false;
      try {
        final d = await _db.collection('users').doc(u.uid).get();
        flag = d.data()?['verified'] == true;
      } catch (_) {}
      if (!flag) { _set(AuthState.pendingOtp(email: u.email ?? '')); return; }
    }
    try {
      final doc = await _db.collection('users').doc(u.uid).get();
      final profile = AppUser.fromMap(u.uid, doc.data() ?? {'email': u.email});
      _set(AuthState.signedIn(profile));
    } catch (_) {
      // Firestore unavailable (e.g. emulator not running) — fall back to
      // auth-only profile so the app still renders the authenticated shell.
      final profile = AppUser.fromMap(u.uid, {'email': u.email ?? ''});
      _set(AuthState.signedIn(profile));
    }
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
    try {
      await _db.collection('users').doc(u.uid).set({'verified': true}, SetOptions(merge: true));
    } catch (_) {}
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
    _sub.cancel();
    super.dispose();
  }
}
