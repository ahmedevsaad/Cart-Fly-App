import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {
    runApp(const _InitErrorApp());
    return;
  }
  runApp(const CartFlyApp());
}

class _InitErrorApp extends StatelessWidget {
  const _InitErrorApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            "Couldn't start CartFly. Check your connection and reopen.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
