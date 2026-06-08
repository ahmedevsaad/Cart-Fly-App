import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../l10n/auth_error.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import 'auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  String _country = 'Saudi Arabia';
  String _currency = 'SAR';
  bool _busy = false;
  String? _error;

  static const _countries = [
    'Saudi Arabia',
    'Egypt',
    'UAE',
    'USA',
    'China',
  ];

  static const _currencies = [
    'USD',
    'SAR',
    'AED',
    'EGP',
    'CNY',
  ];

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_password.text != _confirmPassword.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    if (_name.text.trim().isEmpty ||
        _phone.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _password.text.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      country: _country,
      currency: _currency,
      password: _password.text,
    );

    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) _error = authErrorText(auth.errorKey);
    });
    // ok → AuthProvider sets status=pendingOtp → router redirects to /verify
  }

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      solidBackground: AppColors.bgSplash,
      topBar: CfTopBar(onBack: () => context.pop()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Center(child: Text('Register', style: AppText.title)),
            const SizedBox(height: 24),

            // TextField[0]: Full name
            CfInput(
              label: 'Full name:',
              controller: _name,
            ),

            // TextField[1]: Phone number
            CfInput(
              label: 'Phone number:',
              controller: _phone,
              keyboardType: TextInputType.phone,
            ),

            // TextField[2]: Email
            CfInput(
              label: 'Email:',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),

            // DropdownButton: Country
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Country:', style: AppText.body),
                const SizedBox(height: 6),
                DropdownButton<String>(
                  value: _country,
                  isExpanded: true,
                  items: _countries
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _country = v ?? _country),
                ),
                const SizedBox(height: 16),
              ],
            ),

            // DropdownButton: Currency
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Currency:', style: AppText.body),
                const SizedBox(height: 6),
                DropdownButton<String>(
                  value: _currency,
                  isExpanded: true,
                  items: _currencies
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _currency = v ?? _currency),
                ),
                const SizedBox(height: 16),
              ],
            ),

            // TextField[3]: Password
            CfInput(
              label: 'Password:',
              controller: _password,
              obscure: true,
            ),

            // TextField[4]: Confirm password
            CfInput(
              label: 'Confirm password:',
              controller: _confirmPassword,
              obscure: true,
            ),

            if (_error != null)
              Text(
                _error!,
                style: AppText.caption.copyWith(color: AppColors.danger),
              ),
            const SizedBox(height: 8),
            CfButton(
              label: _busy ? '...' : 'Register',
              onPressed: _busy ? null : _submit,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
