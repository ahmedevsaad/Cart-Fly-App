import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/models/order.dart';
import '../../router/routes.dart';
import '../../state/orders_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_dashed.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_states.dart';
import '../../widgets/cf_top_bar.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Tab definitions
// ──────────────────────────────────────────────────────────────────────────────
enum _Tab { all, atWarehouse, inTransit }

extension _TabLabel on _Tab {
  String get label {
    switch (this) {
      case _Tab.all:
        return 'All';
      case _Tab.atWarehouse:
        return 'At warehouse';
      case _Tab.inTransit:
        return 'In transit';
    }
  }
}

// Map OrderStatus → display bucket
_Tab _bucketOf(OrderStatus s) {
  switch (s) {
    case OrderStatus.placed:
      return _Tab.all; // "Declared" — shows in All
    case OrderStatus.atWarehouse:
      return _Tab.atWarehouse;
    case OrderStatus.packaging:
    case OrderStatus.shipped:
    case OrderStatus.ready:
      return _Tab.inTransit;
    case OrderStatus.delivered:
      return _Tab.all;
  }
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  _Tab _activeTab = _Tab.all;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();
    final all = provider.orders;

    final displayed = _activeTab == _Tab.all
        ? all
        : all.where((o) => _bucketOf(o.status) == _activeTab).toList();

    final atWarehouseCount =
        all.where((o) => o.status == OrderStatus.atWarehouse).length;

    return CfScaffold(
      topBar: CfTopBar(
        showBack: false,
        // FAB-style "+" action on the top bar
        // We embed the action via a custom action widget via key
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header + add button ───────────────────────────────────
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'My packages',
                    style: AppText.heading.copyWith(
                        fontWeight: FontWeight.w800, fontSize: 22),
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Add new package',
                  child: InkWell(
                    onTap: () => context.push(Routes.createShipment),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      // 44px hit area, 34px visual
                      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                      alignment: Alignment.center,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Segmented tab bar ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: _SegmentedTabs(
              active: _activeTab,
              onChanged: (t) => setState(() => _activeTab = t),
            ),
          ),
          const SizedBox(height: 14),

          // ── List ──────────────────────────────────────────────────
          Expanded(
            child: displayed.isEmpty
                ? const CfEmptyState(message: 'No packages here yet')
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 0),
                    itemCount: displayed.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 11),
                    itemBuilder: (context, i) =>
                        _PackageCard(order: displayed[i]),
                  ),
          ),

          // ── Consolidation hint (shown when ≥2 at warehouse) ───────
          if (atWarehouseCount >= 2)
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(22, 13, 22, 0),
              child: _ConsolidationHint(count: atWarehouseCount),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Segmented tab control
// ──────────────────────────────────────────────────────────────────────────────

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.active, required this.onChanged});
  final _Tab active;
  final ValueChanged<_Tab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppColors.radius),
      ),
      child: Row(
        children: _Tab.values.map((tab) {
          final isActive = tab == active;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isActive ? AppColors.shadowSoft : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  tab.label,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive
                        ? AppColors.text
                        : AppColors.mutedDisabled,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Package card
// ──────────────────────────────────────────────────────────────────────────────

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .push(Routes.orderDetail.replaceFirst(':id', order.id)),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.fieldBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0D0F172A),
                blurRadius: 6,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppColors.shadowSoft,
              ),
              child: const Icon(Icons.inventory_2_outlined,
                  size: 22, color: Color(0xFF0D9488)),
            ),
            const SizedBox(width: 13),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '#CF-${order.id.length > 4 ? order.id.substring(0, 4).toUpperCase() : order.id}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 7),
                      _StatusPill(status: order.status),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    order.title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    order.sourceCountry.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mutedDisabled,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.mutedDisabled, size: 18),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Status pill
// ──────────────────────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, fg, bg) = _pillStyle(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppColors.radiusPill),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  (String, Color, Color) _pillStyle(OrderStatus s) {
    switch (s) {
      case OrderStatus.placed:
        return ('Declared', const Color(0xFF92740C), const Color(0xFFFEF3C7));
      case OrderStatus.atWarehouse:
        return ('At warehouse', AppColors.success, AppColors.successBg);
      case OrderStatus.packaging:
      case OrderStatus.shipped:
      case OrderStatus.ready:
        return ('In transit', const Color(0xFF1D4ED8), const Color(0xFFDBEAFE));
      case OrderStatus.delivered:
        return ('Delivered', AppColors.mutedLabel, AppColors.fieldBg);
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Consolidation hint banner
// ──────────────────────────────────────────────────────────────────────────────

class _ConsolidationHint extends StatelessWidget {
  const _ConsolidationHint({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CfDashedBorderPainter(
        color: const Color(0xFF0D9488), // teal brand — intentionally one-off
        radius: AppColors.radius,
        strokeWidth: 1.5,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDFA),
          borderRadius: BorderRadius.circular(AppColors.radius),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_shipping_outlined,
                color: Color(0xFF0D9488), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$count packages at the warehouse can be combined to save on shipping.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F766E),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
