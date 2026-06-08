import 'dart:convert';
// dart:html is available on Flutter Web (Chrome target).
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:cartfly/firebase_options.dart';

const _projectId = 'cartfly-4382a';

/// Call in setUpAll of every integration test before pumping any widget.
Future<void> initTestFirebase() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
}

/// Wipes all emulator accounts and Firestore documents. Call in tearDownAll.
Future<void> clearEmulatorData() async {
  try {
    await html.HttpRequest.request(
      'http://localhost:9099/emulator/v1/projects/$_projectId/accounts',
      method: 'DELETE',
    );
  } catch (e) {
    // ignore: avoid_print
    print('[clearEmulatorData] auth clear failed: $e');
  }
  try {
    await html.HttpRequest.request(
      'http://localhost:8080/emulator/v1/projects/$_projectId/databases/(default)/documents',
      method: 'DELETE',
    );
  } catch (e) {
    // ignore: avoid_print
    print('[clearEmulatorData] firestore clear failed: $e');
  }
}

/// Creates a user in the emulator, marks their email as verified, signs out,
/// and returns their uid.
Future<String> createVerifiedUser({
  required String email,
  required String password,
}) async {
  final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  final uid = cred.user!.uid;
  // Use the emulator admin REST API to set emailVerified without an email link.
  await html.HttpRequest.request(
    'http://localhost:9099/identitytoolkit.googleapis.com/v1/projects/$_projectId/accounts:update',
    method: 'POST',
    requestHeaders: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer owner',
    },
    sendData: jsonEncode({'localId': uid, 'emailVerified': true}),
  );
  await FirebaseAuth.instance.signOut();
  return uid;
}

/// Signs in an existing emulator user.
Future<void> signInUser(String email, String password) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

/// Marks the currently signed-in user's email as verified in the emulator.
Future<void> verifyCurrentUser() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;
  await html.HttpRequest.request(
    'http://localhost:9099/identitytoolkit.googleapis.com/v1/projects/$_projectId/accounts:update',
    method: 'POST',
    requestHeaders: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer owner',
    },
    sendData: jsonEncode({'localId': uid, 'emailVerified': true}),
  );
}
