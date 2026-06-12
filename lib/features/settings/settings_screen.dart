import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../widgets/icons/cf_icons.dart';

import '../../features/auth/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cf_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return CfScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
        children: [
          // Title
          Text(
            l.settingsTitle,
            style: GoogleFonts.inter(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // ── Account settings ──────────────────────────────────────────────
          _SectionLabel(label: l.settingsAccountSection),
          const SizedBox(height: 8),
          _SettingsGroup(
            rows: [
              _SettingsRow(label: l.settingsSavedAddresses),
              _SettingsRow(
                label: l.settingsEditProfile,
                onTap: () => context.push(Routes.editProfile),
              ),
              _SettingsRow(
                label: l.settingsChangePassword,
                onTap: () => context.push(Routes.changePassword),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── App Preferences ───────────────────────────────────────────────
          _SectionLabel(label: l.settingsAppPrefsSection),
          const SizedBox(height: 8),
          _SettingsGroup(
            rows: [
              _SettingsRow(
                label: l.settingsLanguages,
                onTap: () => context.push(Routes.settingsLanguage),
              ),
              _SettingsRow(
                label: l.settingsCurrency,
                onTap: () => context.push(Routes.settingsCurrency),
              ),
              _SettingsRow(label: l.settingsNotifications),
            ],
          ),
          const SizedBox(height: 16),

          // ── Support & Help ────────────────────────────────────────────────
          _SectionLabel(label: l.settingsSupportSection),
          const SizedBox(height: 8),
          _SettingsGroup(
            rows: [
              _SettingsRow(label: l.settingsHelpCenter),
              _SettingsRow(
                label: l.settingsHaveAnIssue,
                onTap: () => context.push(Routes.support),
              ),
              _SettingsRow(
                label: l.settingsReportProblem,
                onTap: () => context.push(Routes.support),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── About us + Policy side-by-side ────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  label: l.settingsAboutUs,
                  highlighted: true,
                  onTap: () => context.push(Routes.about),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  label: l.settingsPolicy,
                  highlighted: false,
                  onTap: () => context.push(Routes.policy),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Contact card ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.fieldBg,
              borderRadius: BorderRadius.circular(AppColors.radiusCard),
              boxShadow: AppColors.shadowSoft,
            ),
            child: Column(
              children: [
                Text(
                  l.settingsContactUs,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  l.settingsContactEmail,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Sign out ──────────────────────────────────────────────────────
          Center(
            child: ElevatedButton.icon(
              onPressed: () => context.read<AuthProvider>().logout(),
              icon: CfIcons.signOut(size: 18, color: Colors.white),
              label: Text(
                l.settingsSignOut,
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

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.text,
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.rows});
  final List<_SettingsRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.shadowSoft,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1)
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                color: AppColors.cardBorder,
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
            _ChevronCircle(),
          ],
        ),
      ),
    );
  }
}

class _ChevronCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
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
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.label,
    required this.highlighted,
    this.onTap,
  });
  final String label;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    // highlighted = navy-blue tinted bg (About us), plain = fieldBg (Policy)
    final bg = highlighted ? AppColors.navyTile : AppColors.fieldBg;
    final labelColor = highlighted ? AppColors.navyLabel : AppColors.text;
    final iconColor = highlighted ? AppColors.navyLabel : AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppColors.radiusCard),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppColors.radiusCard),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: labelColor,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: iconColor, width: 1.7),
              ),
              child: Center(
                child: isRtl
                    ? CfIcons.chevronLeft(size: 13, color: iconColor)
                    : CfIcons.chevronRight(size: 13, color: iconColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
