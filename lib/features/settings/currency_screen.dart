import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../widgets/icons/cf_icons.dart';

import '../../data/repositories/user_repository.dart';
import '../../features/auth/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../state/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cf_scaffold.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();
    final current = settings.currency;

    // The three currencies shown in the design (Frame 28)
    final currencies = [l.currencyEGP, l.currencyUSD, l.currencySAR];

    Future<void> onSelect(String code) async {
      final settingsProv = context.read<SettingsProvider>();
      final authProv = context.read<AuthProvider>();
      await settingsProv.setCurrency(code);
      final uid = authProv.state.user?.uid;
      if (uid != null) {
        final repo = UserRepository(
          db: FirebaseFirestore.instance,
          uid: uid,
        );
        await repo.setCurrency(code);
        await authProv.refreshProfile();
      }
    }

    return CfScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
        children: [
          // Title
          Text(
            l.currencyScreenTitle,
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

          // Currency group card
          Container(
            decoration: BoxDecoration(
              color: AppColors.fieldBg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppColors.shadowSoft,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // Languages row (navigates back to language screen)
                _PrefsRow(
                  label: l.settingsLanguages,
                  expanded: false,
                  onTap: () => context.push(Routes.settingsLanguage),
                ),
                _divider(),

                // Currency — expanded / active
                _ActiveHeader(label: l.settingsCurrency),

                // Radio options
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
                  child: Column(
                    children: [
                      for (int i = 0; i < currencies.length; i++) ...[
                        _RadioRow(
                          label: currencies[i],
                          isSelected: current == currencies[i],
                          onTap: () => onSelect(currencies[i]),
                        ),
                        if (i < currencies.length - 1) _divider(),
                      ],
                    ],
                  ),
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

/// Non-expanded preferences row with chevron-circle
class _PrefsRow extends StatelessWidget {
  const _PrefsRow({required this.label, this.expanded = false, this.onTap});
  final String label;
  final bool expanded;
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
              child: Center(
                child: isRtl
                    ? CfIcons.chevronLeft(size: 14, color: AppColors.primary)
                    : CfIcons.chevronRight(size: 14, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Active/expanded header for the selected section (blue tint, chevron up)
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
            child: Center(
              child: CfIcons.chevronUp(size: 14, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Radio-style selection row
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
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
                    child: Center(
                      child: CfIcons.stepCheck(size: 12, color: Colors.white),
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

/// Shared contact-us card
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
