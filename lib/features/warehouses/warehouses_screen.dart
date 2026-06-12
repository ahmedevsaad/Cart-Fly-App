import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:country_flags/country_flags.dart';

import '../../data/warehouses.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_journey_nav.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import '../../widgets/icons/cf_icons.dart';

class WarehousesScreen extends StatelessWidget {
  const WarehousesScreen({super.key});

  // Design order: SA, EG, AE, US in 2×2 grid; CN alone at half-width below.
  static const _gridCodes = ['sa', 'eg', 'ae', 'us'];
  static const _extraCode = 'cn';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      bottomNav: cfJourneyNav(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
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

            // ── 2×2 grid (SA, EG, AE, US) ──────────────────────────
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.0,
              children: [
                for (final code in _gridCodes)
                  _WarehouseCard(
                    code: code,
                    name: warehouseByCode(code).displayName,
                    onTap: () => context.push('/lockers/$code'),
                  ),
              ],
            ),
            const SizedBox(height: 13),

            // ── China — single card at half width ────────────────────
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SizedBox(
                width: (MediaQuery.of(context).size.width - 44 - 13) / 2,
                child: _WarehouseCard(
                  code: _extraCode,
                  name: warehouseByCode(_extraCode).displayName,
                  onTap: () => context.push('/lockers/$_extraCode'),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── My forwarding address entry ───────────────────────────
            Semantics(
              button: true,
              label: 'My forwarding address',
              child: InkWell(
                onTap: () => context.push(Routes.myAddress),
                borderRadius: BorderRadius.circular(AppColors.radius),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    color: AppColors.tealBg,
                    border: Border.all(
                        color: AppColors.teal.withValues(alpha: 0.35), width: 1),
                    borderRadius: BorderRadius.circular(AppColors.radius),
                  ),
                  child: Row(
                    children: [
                      CfIcons.pin(size: 20, color: AppColors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'My forwarding address',
                          style: AppText.label.copyWith(
                            color: AppColors.tealDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                      CfIcons.chevronRight(
                          size: 16, color: AppColors.teal),
                    ],
                  ),
                ),
              ),
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

  static const _codeToFilename = <String, String>{
    'sa': 'saudi',
    'eg': 'egypt',
    'ae': 'uae',
    'us': 'usa',
    'cn': 'china',
  };

  String get _imagePath =>
      'assets/images/wh-${_codeToFilename[code] ?? code}.png';
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
                        child: CfIcons.homeBuilding(
                            size: 32, color: AppColors.mutedDisabled),
                      ),
                    ),
                  ),
                  // Flag + label row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
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
