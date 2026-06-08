import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/lockers.dart';
import '../../widgets/cf_card.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import '../../theme/app_text.dart';
import '../../theme/app_colors.dart';

class LockersScreen extends StatelessWidget {
  const LockersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Our locker locations',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                for (final country in countryLockers)
                  _CountryButton(
                    label: country.displayName,
                    onTap: () => context.push('/lockers/${country.code}'),
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CountryButton extends StatelessWidget {
  const _CountryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CfCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Text(
          label,
          style: AppText.bodyMedium.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
