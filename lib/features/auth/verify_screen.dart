import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_scaffold.dart';
import 'auth_provider.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool _busy = false;
  bool _notVerified = false;

  Future<void> _checkVerified() async {
    setState(() {
      _busy = true;
      _notVerified = false;
    });
    final ok = await context.read<AuthProvider>().reloadVerified();
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) _notVerified = true;
    });
    // ok → router redirect sends to /home automatically
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

    return CfScaffold(
      solidBackground: AppColors.bgSplash,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text('Verify your email', style: AppText.title)),
            const SizedBox(height: 24),
            Text(
              'We sent a verification link to $email.\nTap continue after verifying.',
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_notVerified)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Not verified yet. Please check your email.',
                  style: AppText.caption.copyWith(color: AppColors.danger),
                  textAlign: TextAlign.center,
                ),
              ),
            CfButton(
              label: _busy ? '...' : 'I have verified',
              onPressed: _busy ? null : _checkVerified,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _resend,
              child: const Text('Resend'),
            ),
          ],
        ),
      ),
    );
  }
}
