import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../widgets/app_background.dart';
import '../../widgets/labeled_text_field.dart';
import 'auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _country = TextEditingController();
  final _currency = TextEditingController(text: 'USD');
  final _pwd = TextEditingController();
  final _pwd2 = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _country, _currency, _pwd, _pwd2]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final t = AppLocalizations.of(context)!;
    if (_pwd.text != _pwd2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.errorPasswordsDontMatch)),
      );
      return;
    }
    setState(() => _busy = true);
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      country: _country.text.trim(),
      currency: _currency.text.trim(),
      password: _pwd.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_friendly(auth.errorKey))),
      );
    }
    // On success router redirect routes us to /otp via pendingOtp state.
  }

  String _friendly(String? key) {
    switch (key) {
      case 'errorAuth_email-already-in-use':
        return 'Email already in use.';
      case 'errorAuth_weak-password':
        return 'Password is too weak.';
      case 'errorAuth_invalid-email':
        return 'Invalid email.';
      case 'errorAuth_network-request-failed':
        return 'Network error. Check connection.';
      default:
        return 'Could not create account${key == null ? '' : ' ($key)'}.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    String? req(String? v) => (v == null || v.isEmpty) ? t.errorRequired : null;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => context.go(Routes.splash),
                    icon: const Icon(Icons.chevron_left, size: 32),
                  ),
                  Text(t.register,
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 8),
                  LabeledTextField(
                      label: t.fullName, controller: _name, validator: req),
                  LabeledTextField(
                      label: t.phoneNumber,
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      validator: req),
                  LabeledTextField(
                      label: t.email,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v ?? '').contains('@')
                          ? null
                          : t.errorInvalidEmail),
                  LabeledTextField(
                      label: t.country, controller: _country, validator: req),
                  LabeledTextField(
                      label: t.currency,
                      controller: _currency,
                      validator: req),
                  LabeledTextField(
                      label: t.password,
                      controller: _pwd,
                      obscure: true,
                      validator: (v) => (v ?? '').length >= 6
                          ? null
                          : t.errorPasswordShort),
                  LabeledTextField(
                      label: t.confirmPassword,
                      controller: _pwd2,
                      obscure: true,
                      validator: (v) => (v ?? '').length >= 6
                          ? null
                          : t.errorPasswordShort),
                  Center(
                    child: SizedBox(
                      width: 220,
                      child: ElevatedButton(
                        onPressed: _busy ? null : _submit,
                        child: _busy
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(t.createAccount),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
