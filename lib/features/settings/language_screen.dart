import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/settings_provider.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final currentCode = settings.locale.languageCode;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
            child: Text(
              'Languages',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _LanguageTile(
            label: 'English',
            code: 'en',
            isSelected: currentCode == 'en',
            onTap: () => context.read<SettingsProvider>().setLocale(const Locale('en')),
          ),
          _LanguageTile(
            label: 'العربية',
            code: 'ar',
            isSelected: currentCode == 'ar',
            onTap: () => context.read<SettingsProvider>().setLocale(const Locale('ar')),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.code,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
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
              child: Text(label, style: const TextStyle(fontSize: 16)),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Color(0xFF2563EB)),
          ],
        ),
      ),
    );
  }
}
