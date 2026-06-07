import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/app_background.dart';
import 'auth_provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _busy = false;
  String? _msg;

  Future<void> _check() async {
    setState(() {
      _busy = true;
      _msg = null;
    });
    final ok = await context.read<AuthProvider>().reloadVerified();
    if (mounted) {
      setState(() {
        _busy = false;
        if (!ok) _msg = 'Not verified yet — check your inbox.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final email = context.watch<AuthProvider>().state.pendingEmail ?? '';
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t.verifyEmailTitle,
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 16),
                Text(t.verifyEmailBody(email), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _busy ? null : _check,
                  child: Text(t.iVerified),
                ),
                if (_msg != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(_msg!,
                        style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
