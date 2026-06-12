import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/warehouses.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import 'package:country_flags/country_flags.dart';

class WarehousesScreen extends StatelessWidget {
  const WarehousesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.ourWarehouses,
              style: AppText.heading.copyWith(
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // 2-column grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.0,
              children: [
                for (final w in warehouses)
                  _WarehouseCard(
                    code: w.code,
                    name: w.displayName,
                    onTap: () => context.push('/warehouses/${w.code}'),
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

class _WarehouseCard extends StatelessWidget {
  const _WarehouseCard({
    required this.code,
    required this.name,
    required this.onTap,
  });

  final String code;
  final String name;
  final VoidCallback onTap;

  String get _imagePath => 'assets/images/wh-$code.png';
  String get _isoCode => code.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: name,
      child: Material(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppColors.shadowSoft,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail
            Expanded(
              child: Image.asset(
                _imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.cardBorder,
                  alignment: Alignment.center,
                  child: const Icon(Icons.warehouse_outlined,
                      size: 32, color: AppColors.mutedDisabled),
                ),
              ),
            ),
            // Flag + label row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: CountryFlag.fromCountryCode(
                      _isoCode,
                      width: 22,
                      height: 15,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      name,
                      style: AppText.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontSize: 13.5,
                        color: AppColors.text,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}
