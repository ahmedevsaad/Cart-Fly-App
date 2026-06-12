import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_status_timeline.dart';
import '../../widgets/cf_top_bar.dart';
import '../auth/auth_provider.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userName =
        context.watch<AuthProvider>().state.user?.name ?? 'User';

    return CfScaffold(
      topBar: const CfTopBar(showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Greeting row ────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: AppColors.cardBorder,
                  backgroundImage:
                      const AssetImage('assets/images/avatar.png'),
                ),
                const SizedBox(width: 11),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.welcomeUser,
                        style: AppText.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    Text(userName,
                        style: AppText.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
                const Spacer(),
                Icon(Icons.notifications_none_rounded,
                    color: AppColors.primary, size: 26),
              ],
            ),
            const SizedBox(height: 18),

            // ── My order heading ─────────────────────────────────────
            Text(l10n.myOrder,
                style: AppText.heading.copyWith(
                    fontWeight: FontWeight.w800, fontSize: 21)),
            const SizedBox(height: 11),

            // ── Order tracker card ────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius:
                    BorderRadius.circular(AppColors.radiusCard),
                boxShadow: AppColors.shadowSoft,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              child: CfStatusTimeline(
                steps: [
                  l10n.statusOrderPlaced,
                  l10n.statusShipped,
                  l10n.statusInTransit,
                  l10n.statusDelivered,
                ],
                activeIndex: 1, // up to "Shipped"
              ),
            ),
            const SizedBox(height: 20),

            // ── Our services heading ──────────────────────────────────
            Text(l10n.ourServices,
                style: AppText.heading.copyWith(
                    fontWeight: FontWeight.w800, fontSize: 21)),
            const SizedBox(height: 12),

            // ── 2×2 service grid ──────────────────────────────────────
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.05,
              children: [
                _ServiceCard(
                  label: l10n.serviceWarehouses,
                  icon: const _WarehouseIcon(),
                  onTap: () => context.push(Routes.warehouses),
                ),
                _ServiceCard(
                  label: l10n.serviceLockers,
                  icon: const _LockerIcon(),
                  onTap: () => context.push(Routes.lockers),
                ),
                _ServiceCard(
                  label: l10n.servicePlans,
                  icon: const _PlansIcon(),
                  onTap: () => context.push(Routes.plans),
                ),
                _ServiceCard(
                  label: l10n.serviceCalculator,
                  icon: const _CalculatorIcon(),
                  onTap: () => context.push(Routes.calculator),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── My address row ────────────────────────────────────────
            GestureDetector(
              onTap: () => context.push(Routes.myAddress),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.fieldBg,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AppColors.shadowSoft,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 24, color: AppColors.text),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'My address',
                        style: AppText.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.text, width: 2),
                      ),
                      child: const Icon(Icons.arrow_forward,
                          size: 14, color: AppColors.text),
                    ),
                  ],
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

// ──────────────────────────────────────────────────────────────────────────────
// Service card widget
// ──────────────────────────────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.fieldBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.shadowSoft,
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon,
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.text, width: 2),
                  ),
                  child: const Icon(Icons.arrow_forward,
                      size: 14, color: AppColors.text),
                ),
              ],
            ),
            const Spacer(),
            Text(
              label,
              style: AppText.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700, fontSize: 15, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Icon widgets (path-drawn, matching design SVGs)
// ──────────────────────────────────────────────────────────────────────────────

class _WarehouseIcon extends StatelessWidget {
  const _WarehouseIcon();
  @override
  Widget build(BuildContext context) => const Icon(
        Icons.warehouse_outlined,
        size: 27,
        color: AppColors.text,
      );
}

class _LockerIcon extends StatelessWidget {
  const _LockerIcon();
  @override
  Widget build(BuildContext context) => const Icon(
        Icons.lock_outline_rounded,
        size: 27,
        color: AppColors.text,
      );
}

class _PlansIcon extends StatelessWidget {
  const _PlansIcon();
  @override
  Widget build(BuildContext context) => const Icon(
        Icons.calendar_today_outlined,
        size: 27,
        color: AppColors.text,
      );
}

class _CalculatorIcon extends StatelessWidget {
  const _CalculatorIcon();
  @override
  Widget build(BuildContext context) => const Icon(
        Icons.shopping_cart_outlined,
        size: 27,
        color: AppColors.text,
      );
}
