import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/user_repository.dart';
import '../../features/auth/auth_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

const _currencies = ['USD', 'SAR', 'AED', 'EGP', 'CNY'];

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final current = settings.currency;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Currency',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          for (final code in _currencies)
            _CurrencyTile(
              code: code,
              isSelected: current == code,
              onTap: () async {
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
              },
            ),
        ],
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(code, style: const TextStyle(fontSize: 16)),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Color(0xFF2563EB)),
          ],
        ),
      ),
    );
  }
}
