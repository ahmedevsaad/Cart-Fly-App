import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../l10n/auth_error.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_email.text.trim(), _password.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) _error = authErrorText(auth.errorKey);
    });
    // success → router redirect navigates to /home automatically
  }

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      solidBackground: AppColors.bgSplash,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            Center(child: Text('CartFly', style: AppText.display)),
            Center(child: Text('from cart to doorstep', style: AppText.caption)),
            const SizedBox(height: 30),
            Center(child: Text('Login', style: AppText.title)),
            const SizedBox(height: 24),
            CfInput(
              label: 'Email:',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),
            CfInput(
              label: 'Password:',
              controller: _password,
              obscure: true,
            ),
            TextButton(
              onPressed: () => context.push(Routes.forgot),
              child: const Text('Forget password?'),
            ),
            if (_error != null)
              Text(
                _error!,
                style: AppText.caption.copyWith(color: AppColors.danger),
              ),
            const SizedBox(height: 8),
            CfButton(
              label: _busy ? '...' : 'Login',
              onPressed: _busy ? null : _submit,
            ),
            const SizedBox(height: 24),
            CfOutlineButton(
              label: "Don't have an account",
              onPressed: () => context.push(Routes.register),
            ),
          ],
        ),
      ),
    );
  }
}
