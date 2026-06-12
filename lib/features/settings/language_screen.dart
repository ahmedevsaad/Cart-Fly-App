import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cf_scaffold.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();
    final currentCode = settings.locale.languageCode;

    return CfScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
        children: [
          // Title
          Text(
            l.langScreenTitle,
            style: GoogleFonts.inter(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Section label
          Text(
            l.settingsAppPrefsSection,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),

          // Language group card
          Container(
            decoration: BoxDecoration(
              color: AppColors.fieldBg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppColors.shadowSoft,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // Languages — expanded / active
                _ActiveHeader(label: l.settingsLanguages),

                // Radio options
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
                  child: Column(
                    children: [
                      _RadioRow(
                        label: l.langEnglish,
                        isSelected: currentCode == 'en',
                        onTap: () => context
                            .read<SettingsProvider>()
                            .setLocale(const Locale('en')),
                      ),
                      _divider(),
                      _RadioRow(
                        label: l.langArabic,
                        isSelected: currentCode == 'ar',
                        onTap: () => context
                            .read<SettingsProvider>()
                            .setLocale(const Locale('ar')),
                      ),
                    ],
                  ),
                ),

                _divider(),

                // Currency row
                _PrefsRow(
                  label: l.settingsCurrency,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                _divider(),

                // Notification settings row
                _PrefsRow(label: l.settingsNotifications),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Contact card
          _ContactCard(
            contactLabel: l.settingsContactUs,
            contactEmail: l.settingsContactEmail,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        color: AppColors.cardBorder,
      );
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _ActiveHeader extends StatelessWidget {
  const _ActiveHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.activeTint,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.7),
            ),
            child: const Icon(
              Icons.keyboard_arrow_up,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrefsRow extends StatelessWidget {
  const _PrefsRow({required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.7),
              ),
              child: Icon(
                isRtl ? Icons.chevron_left : Icons.chevron_right,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  const _RadioRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.primary : AppColors.text,
                ),
              ),
            ),
            isSelected
                ? Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  )
                : Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.radioIdle,
                        width: 2,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.contactLabel,
    required this.contactEmail,
  });
  final String contactLabel;
  final String contactEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        boxShadow: AppColors.shadowSoft,
      ),
      child: Column(
        children: [
          Text(
            contactLabel,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: AppColors.text,
            ),
          ),
          Text(
            contactEmail,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
