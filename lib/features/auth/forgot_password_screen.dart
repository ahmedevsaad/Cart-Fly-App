import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../widgets/app_background.dart';
import '../../widgets/labeled_text_field.dart';
import 'auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _busy = false;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _busy = true);
    final ok =
        await context.read<AuthProvider>().resetPassword(_email.text.trim());
    if (mounted) {
      setState(() {
        _busy = false;
        _sent = ok;
      });
    }
    if (ok && mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.go(Routes.login),
                  icon: const Icon(Icons.chevron_left, size: 32),
                ),
                Text(t.forgotPassword,
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 32),
                LabeledTextField(label: t.email, controller: _email),
                ElevatedButton(
                  onPressed: _busy ? null : _send,
                  child: Text(t.sendResetEmail),
                ),
                if (_sent)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Email sent. Check your inbox.'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
