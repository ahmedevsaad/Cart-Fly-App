import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_provider.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_list_row.dart';
import '../../widgets/cf_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // ── Account ──────────────────────────────────────────────────────
          _SectionHeader(label: 'Account'),
          CfListRow(label: 'Saved addresses'),
          CfListRow(
            label: 'Edit profile',
            onTap: () => context.push(Routes.editProfile),
          ),
          CfListRow(
            label: 'Change password',
            onTap: () => context.push(Routes.changePassword),
          ),
          const SizedBox(height: 16),

          // ── App Preferences ──────────────────────────────────────────────
          _SectionHeader(label: 'App Preferences'),
          CfListRow(
            label: 'Languages',
            onTap: () => context.push(Routes.settingsLanguage),
          ),
          CfListRow(
            label: 'Currency',
            onTap: () => context.push(Routes.settingsCurrency),
          ),
          CfListRow(label: 'Notification settings'),
          const SizedBox(height: 16),

          // ── Support & Help ───────────────────────────────────────────────
          _SectionHeader(label: 'Support & Help'),
          CfListRow(label: 'Help center'),
          CfListRow(
            label: 'Have an issue',
            onTap: () => context.push(Routes.support),
          ),
          CfListRow(
            label: 'Report a problem',
            onTap: () => context.push(Routes.support),
          ),
          const SizedBox(height: 16),

          // ── Info ─────────────────────────────────────────────────────────
          _SectionHeader(label: 'Info'),
          CfListRow(
            label: 'About us',
            onTap: () => context.push(Routes.about),
          ),
          CfListRow(
            label: 'Policy',
            onTap: () => context.push(Routes.policy),
          ),
          const SizedBox(height: 24),

          // ── Sign out ─────────────────────────────────────────────────────
          CfButton(
            label: 'Sign out',
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.muted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
