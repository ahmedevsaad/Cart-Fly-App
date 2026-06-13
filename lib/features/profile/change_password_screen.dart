import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_provider.dart';
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
    final currentPw = _current.text;
    final newPw = _newPass.text;
    final confirmPw = _confirm.text;

    if (currentPw.isEmpty || newPw.isEmpty || confirmPw.isEmpty) {
      setState(() => _error = 'All fields are required.');
      return;
    }
    if (newPw != confirmPw) {
      setState(() => _error = 'New passwords do not match.');
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
        const SnackBar(content: Text('Password updated')),
      );
      context.pop();
    } else {
      setState(() => _error = authErrorText(authProv.errorKey).isNotEmpty
          ? authErrorText(authProv.errorKey)
          : 'Failed to update password.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Change Password',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CfInput(
              label: 'Current password:',
              controller: _current,
              obscure: true,
            ),
            CfInput(
              label: 'New password:',
              controller: _newPass,
              obscure: true,
            ),
            CfInput(
              label: 'Confirm new password:',
              controller: _confirm,
              obscure: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: 4),
              Text(
                _error!,
                style: const TextStyle(color: AppColors.danger, fontSize: 13), // danger red
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 8),
            CfButton(
              label: 'Update',
              onPressed: _loading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
