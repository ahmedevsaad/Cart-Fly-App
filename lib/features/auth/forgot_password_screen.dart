import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/auth_error.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import 'auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_email.text.trim().isEmpty) {
      setState(() => _error = l10n.pleaseEnterEmail);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = context.read<AuthProvider>();
    final ok = await auth.resetPassword(_email.text.trim());
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) _error = authErrorText(auth.errorKey);
    });
    if (ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.passwordResetSent)),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CfScaffold(
      solidBackground: AppColors.bgSplash,
      topBar: CfTopBar(onBack: () => context.pop()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Center(child: Text(l10n.forgotPasswordTitle, style: AppText.title)),
            const SizedBox(height: 24),
            Text(
              l10n.forgotPasswordBody,
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CfInput(
              label: l10n.email,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),
            if (_error != null)
              Text(
                _error!,
                style: AppText.caption.copyWith(color: AppColors.danger),
              ),
            const SizedBox(height: 8),
            CfButton(
              label: _busy ? '...' : l10n.sendResetLink,
              onPressed: _busy ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
