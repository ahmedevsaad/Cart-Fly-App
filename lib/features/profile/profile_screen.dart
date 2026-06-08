import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_provider.dart';
import '../../router/routes.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_list_row.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_states.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().state.user;

    if (user == null) {
      return const CfScaffold(body: CfLoading());
    }

    return CfScaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          // Avatar / name header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFFECEEF0),
                  child: Text(
                    user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (user.email.isNotEmpty)
                  Text(
                    user.email,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF64748B)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Info rows
          _InfoRow(label: 'Phone', value: user.phone.isNotEmpty ? user.phone : '-'),
          _InfoRow(label: 'Country', value: user.country.isNotEmpty ? user.country : '-'),
          _InfoRow(label: 'Currency', value: user.currency.isNotEmpty ? user.currency : 'USD'),
          const SizedBox(height: 16),
          // Actions
          CfListRow(
            label: 'Edit profile',
            onTap: () => context.push(Routes.editProfile),
          ),
          CfListRow(
            label: 'Change password',
            onTap: () => context.push(Routes.changePassword),
          ),
          const SizedBox(height: 24),
          CfButton(
            label: 'Sign out',
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
