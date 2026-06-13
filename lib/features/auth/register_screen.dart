import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../l10n/auth_error.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import '../../widgets/icons/cf_icons.dart';
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

  String _country = 'Egypt';
  String _currency = 'EGP — Egyptian Pound';
  bool _busy = false;
  String? _error;

  // Country name → ISO-3166-1 alpha-2 code for flag rendering
  static const _countries = <String, String>{
    'Saudi Arabia': 'SA',
    'Egypt': 'EG',
    'UAE': 'AE',
    'USA': 'US',
    'China': 'CN',
  };

  static const _currencies = [
    'USD — US Dollar',
    'SAR — Saudi Riyal',
    'AED — UAE Dirham',
    'EGP — Egyptian Pound',
    'CNY — Chinese Yuan',
  ];

  // Map display currency string to short code for AuthProvider
  String get _currencyCode => _currency.split(' — ').first;

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
    if (_name.text.trim().isEmpty ||
        _phone.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _password.text.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      return;
    }
    final emailVal = _email.text.trim();
    if (!emailVal.contains('@') || !emailVal.contains('.')) {
      setState(() => _error = 'Enter a valid email');
      return;
    }
    if (_password.text != _confirmPassword.text) {
      setState(() => _error = 'Passwords do not match');
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
      currency: _currencyCode,
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
      topBar: CfTopBar(onBack: () => context.canPop() ? context.pop() : context.go(Routes.welcome)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 14),
            Center(
              child: Text(
                'Register',
                style: AppText.title.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Full name
            CfInput(label: 'Full name:', controller: _name),

            // Phone number
            CfInput(
              label: 'Phone number:',
              controller: _phone,
              keyboardType: TextInputType.phone,
            ),

            // Email
            CfInput(
              label: 'Email:',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),

            // Country dropdown (styled like CfInput field)
            _LabeledDropdown<String>(
              label: 'Country:',
              value: _country,
              items: _countries.keys.toList(),
              itemBuilder: (c) => Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: CountryFlag.fromCountryCode(
                      _countries[c]!,
                      width: 20,
                      height: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(c),
                ],
              ),
              selectedBuilder: (c) => Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: CountryFlag.fromCountryCode(
                      _countries[c]!,
                      width: 20,
                      height: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(c)),
                ],
              ),
              onChanged: (v) => setState(() => _country = v ?? _country),
            ),

            // Currency dropdown
            _LabeledDropdown<String>(
              label: 'Currency:',
              value: _currency,
              items: _currencies,
              itemBuilder: (c) => Text(c),
              selectedBuilder: (c) => Text(c, overflow: TextOverflow.ellipsis),
              onChanged: (v) => setState(() => _currency = v ?? _currency),
            ),

            // Password
            CfInput(
              label: 'Password:',
              controller: _password,
              obscure: true,
            ),

            // Confirm password
            CfInput(
              label: 'Confirm password:',
              controller: _confirmPassword,
              obscure: true,
            ),

            if (_error != null) ...[
              Text(
                _error!,
                style: AppText.caption.copyWith(color: AppColors.danger),
              ),
              const SizedBox(height: 8),
            ],

            CfButton(
              label: _busy ? '...' : 'Create account',
              onPressed: _busy ? null : _submit,
            ),
            const SizedBox(height: 14),
            Center(
              child: GestureDetector(
                onTap: () => context.push(Routes.login),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                    ),
                    children: [
                      const TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Sign in',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// A labeled dropdown field that matches the CfInput visual style.
class _LabeledDropdown<T> extends StatelessWidget {
  const _LabeledDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemBuilder,
    required this.selectedBuilder,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final Widget Function(T) itemBuilder;
  final Widget Function(T) selectedBuilder;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.mutedLabel,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.fieldBg,
            borderRadius: BorderRadius.circular(AppColors.radius),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: AppColors.shadowSoft,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              icon: CfIcons.chevronDown(
                size: 18,
                color: AppColors.mutedDisabled,
              ),
              dropdownColor: AppColors.fieldBg,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
              selectedItemBuilder: (_) =>
                  items.map((item) => selectedBuilder(item)).toList(),
              items: items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: itemBuilder(item),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 11),
      ],
    );
  }
}
