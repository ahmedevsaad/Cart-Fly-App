import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/auth_error.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import 'auth_provider.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _codeCtrl = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeCtrl.text.trim();
    if (code.length != 6) return;
    setState(() => _busy = true);
    final ok = await context.read<AuthProvider>().verifyCode(code);
    if (!mounted) return;
    setState(() => _busy = false);
    // ok → router redirect sends to /home automatically
    if (!ok) {
      // error is surfaced via auth.errorKey below — no extra action needed
    }
  }

  Future<void> _resend() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email resent.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to resend verification email.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final email = auth.state.pendingEmail ?? '';
    final errorText = authErrorText(auth.errorKey);

    return CfScaffold(
      solidBackground: AppColors.bgSplash,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text('Verify your account', style: AppText.title)),
            const SizedBox(height: 24),
            Text(
              'Enter the 6-digit code sent to $email.',
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Demo code: 000000',
              style: AppText.caption.copyWith(color: AppColors.mutedLabel),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CfInput(
              label: 'Verification code',
              controller: _codeCtrl,
              hint: '000000',
              keyboardType: TextInputType.number,
            ),
            if (errorText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  errorText,
                  style: AppText.caption.copyWith(color: AppColors.danger),
                  textAlign: TextAlign.center,
                ),
              ),
            CfButton(
              label: _busy ? '...' : 'Verify',
              onPressed: _busy ? null : _verify,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _resend,
              child: const Text('Resend email'),
            ),
          ],
        ),
      ),
    );
  }
}
