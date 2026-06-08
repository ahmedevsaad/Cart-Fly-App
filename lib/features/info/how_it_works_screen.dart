import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/how_it_works.dart';
import '../../state/settings_provider.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;
    final pages = locale.languageCode == 'ar' ? howItWorksAr : howItWorksEn;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final page in pages) ...[
              Text(
                page.heading,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                page.body,
                style: const TextStyle(fontSize: 15, height: 1.7),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
