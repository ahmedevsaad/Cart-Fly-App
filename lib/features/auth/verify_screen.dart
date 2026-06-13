import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
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
  String? _inlineError;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final l10n = AppLocalizations.of(context)!;
    final code = _codeCtrl.text.trim();
    if (code.length != 6) {
      setState(() => _inlineError = l10n.verifyEnterCode);
      return;
    }
    setState(() {
      _busy = true;
      _inlineError = null;
    });
    final ok = await context.read<AuthProvider>().verifyCode(code);
    if (!mounted) return;
    setState(() => _busy = false);
    // ok → router redirect sends to /home automatically
    if (!ok) {
      setState(() => _inlineError = AppLocalizations.of(context)!.verifyEnterCode);
    }
  }

  Future<void> _resend() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.verifyResendSuccess)),
      );
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.verifyResendFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            Center(child: Text(l10n.verifyCodeTitle, style: AppText.title)),
            const SizedBox(height: 24),
            Text(
              l10n.verifyCodeBody(email),
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.verifyDemoHint,
              style: AppText.caption.copyWith(color: AppColors.mutedLabel),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CfInput(
              label: l10n.verifyCodeLabel,
              controller: _codeCtrl,
              hint: l10n.verifyCodeHint,
              keyboardType: TextInputType.number,
            ),
            if (_inlineError != null || errorText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _inlineError ?? errorText,
                  style: AppText.caption.copyWith(color: AppColors.danger),
                  textAlign: TextAlign.center,
                ),
              ),
            CfButton(
              label: _busy ? '...' : l10n.verifyButton,
              onPressed: _busy ? null : _verify,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _resend,
              child: Text(l10n.verifyResend),
            ),
          ],
        ),
      ),
    );
  }
}
