import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_states.dart';
import '../../widgets/icons/cf_icons.dart';

/// Maps ISO currency code → display label shown in the profile field.
const _kCurrencyLabels = <String, String>{
  'EGP': 'EGP — Egyptian Pound',
  'USD': 'USD — US Dollar',
  'SAR': 'SAR — Saudi Riyal',
  'EUR': 'EUR — Euro',
  'GBP': 'GBP — British Pound',
  'AED': 'AED — UAE Dirham',
};

/// Maps ISO country name (as stored) → ISO 2-letter code for the flag widget.
const _kCountryCodes = <String, String>{
  'Egypt': 'EG',
  'United States': 'US',
  'Saudi Arabia': 'SA',
  'UAE': 'AE',
  'United Kingdom': 'GB',
  'Germany': 'DE',
  'France': 'FR',
};

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final user = context.watch<AuthProvider>().state.user;

    if (user == null) {
      return const CfScaffold(body: CfLoading());
    }

    return CfScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
        children: [
          // Title
          Text(
            l.profileTitle,
            style: GoogleFonts.inter(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),

          // Avatar
          Center(
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.fieldBg,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: AppColors.shadowSoft,
              ),
              child: Center(
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Detail rows
          _ProfileField(label: l.profileName, value: user.name),
          const SizedBox(height: 11),
          _ProfileField(label: l.profileEmail, value: user.email),
          const SizedBox(height: 11),
          _ProfileField(
            label: l.profilePhone,
            value: user.phone.isNotEmpty ? user.phone : '-',
          ),
          const SizedBox(height: 11),

          // Country + Plan row
          Row(
            children: [
              Expanded(
                child: _ProfileField(
                  label: l.profileCountry,
                  value: user.country.isNotEmpty ? user.country : '-',
                  prefixFlag: user.country.isNotEmpty
                      ? _kCountryCodes[user.country]
                      : null,
                  valueFontSize: 14,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: _ProfileField(
                  label: l.profilePlan,
                  value: 'Smart cart',
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),

          // Currency — show expanded label e.g. "EGP — Egyptian Pound"
          _ProfileField(
            label: l.profileCurrency,
            value: _kCurrencyLabels[
                    user.currency.isNotEmpty ? user.currency : 'USD'] ??
                (user.currency.isNotEmpty ? user.currency : 'USD'),
          ),
          const SizedBox(height: 18),

          // Sign out button — danger red per design
          Center(
            child: ElevatedButton.icon(
              onPressed: () => context.read<AuthProvider>().logout(),
              icon: CfIcons.signOut(size: 18, color: Colors.white),
              label: Text(
                l.profileSignOut,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.signOutBg,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppColors.radius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 11,
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.value,
    this.valueColor,
    this.prefixFlag,
    this.valueFontSize = 15,
  });

  final String label;
  final String value;
  final Color? valueColor;
  /// ISO 2-letter country code for a flag prefix (e.g. 'EG'). Null = no flag.
  final String? prefixFlag;
  final double valueFontSize;

  @override
  Widget build(BuildContext context) {
    final valueStyle = GoogleFonts.inter(
      fontSize: valueFontSize,
      fontWeight: FontWeight.w700,
      color: valueColor ?? AppColors.text,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppColors.radius),
        boxShadow: AppColors.shadowSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 2),
          if (prefixFlag != null)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: CountryFlag.fromCountryCode(
                    prefixFlag!,
                    width: 22,
                    height: 15,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(child: Text(value, style: valueStyle)),
              ],
            )
          else
            Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
