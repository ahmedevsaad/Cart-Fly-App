import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/auth_error.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _current = TextEditingController();
  final _newPass = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _current.dispose();
    _newPass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final currentPw = _current.text;
    final newPw = _newPass.text;
    final confirmPw = _confirm.text;

    if (currentPw.isEmpty || newPw.isEmpty || confirmPw.isEmpty) {
      setState(() => _error = l10n.allFieldsRequired);
      return;
    }
    if (newPw != confirmPw) {
      setState(() => _error = l10n.newPasswordsDontMatch);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final authProv = context.read<AuthProvider>();
    final ok = await authProv.changePassword(currentPw, newPw);

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.passwordUpdated)),
      );
      context.pop();
    } else {
      setState(() => _error = authErrorText(authProv.errorKey).isNotEmpty
          ? authErrorText(authProv.errorKey)
          : AppLocalizations.of(context)!.failedUpdatePassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.changePasswordTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CfInput(
              label: l10n.currentPassword,
              controller: _current,
              obscure: true,
            ),
            CfInput(
              label: l10n.newPassword,
              controller: _newPass,
              obscure: true,
            ),
            CfInput(
              label: l10n.confirmNewPassword,
              controller: _confirm,
              obscure: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: 4),
              Text(
                _error!,
                style: const TextStyle(color: AppColors.danger, fontSize: 13),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 8),
            CfButton(
              label: l10n.updateButton,
              onPressed: _loading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
