import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../data/warehouses.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class WarehouseDetailScreen extends StatelessWidget {
  const WarehouseDetailScreen({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final w = warehouseByCode(code);

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CountryFlag.fromCountryCode(
                w.code.toUpperCase(),
                width: 160,
                height: 110,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                w.displayName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Best for: ${w.bestFor}',
              style: AppText.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (w.whyBuyHere.isNotEmpty) ...[
              Text('Why buy here', style: AppText.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              for (final reason in w.whyBuyHere)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: AppColors.primary)),
                      Expanded(child: Text(reason, style: AppText.bodyMedium)),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
            ],
            if (w.categories.isNotEmpty) ...[
              Text(w.categoriesHeading,
                  style: AppText.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              for (final cat in w.categories)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: AppColors.primary)),
                      Expanded(child: Text(cat, style: AppText.bodyMedium)),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
            ],
            if (w.sites.isNotEmpty) ...[
              Text('Best websites',
                  style: AppText.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              for (final site in w.sites)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.language,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          site.note != null
                              ? '${site.label} (${site.note})'
                              : site.label,
                          style: AppText.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
