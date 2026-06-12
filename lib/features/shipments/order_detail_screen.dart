import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/models/order.dart';
import '../../router/routes.dart';
import '../../state/orders_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_states.dart';
import '../../widgets/cf_top_bar.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Frame 22 — "Order hub"
// Stepper: Order Placed → Shipped → In Transit → Delivered
// Below: hub rows for warehouses / lockers / plans
// ──────────────────────────────────────────────────────────────────────────────

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.id});
  final String id;

  // Maps OrderStatus to 0-based stepper index (4-step visual).
  static int _stepIndex(OrderStatus s) {
    switch (s) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.atWarehouse:
        return 1;
      case OrderStatus.packaging:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.ready:
        return 2;
      case OrderStatus.delivered:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;
    final order = orders.where((o) => o.id == id).firstOrNull;

    if (order == null) {
      return const CfScaffold(
        topBar: CfTopBar(),
        body: CfEmptyState(message: 'Order not found'),
      );
    }

    final activeStep = _stepIndex(order.status);

    return CfScaffold(
      topBar: const CfTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Title ─────────────────────────────────────────────────
            Text(
              'My order:',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 11),

            // ── Status stepper card ───────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius: BorderRadius.circular(AppColors.radiusCard),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D0F172A),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: _OrderStepper(activeStep: activeStep),
            ),

            const SizedBox(height: 20),

            // ── Hub rows ─────────────────────────────────────────────
            _HubRow(
              icon: Icons.home_work_outlined,
              label: 'Our warehouses',
              onTap: () => context.push(Routes.warehouses),
            ),
            const SizedBox(height: 12),
            _HubRow(
              icon: Icons.grid_view_rounded,
              label: 'Locker locations',
              onTap: () => context.push(Routes.lockers),
            ),
            const SizedBox(height: 12),
            _HubRow(
              icon: Icons.calendar_month_outlined,
              label: 'Subscription plans',
              onTap: () => context.push(Routes.plans),
            ),
            const SizedBox(height: 22),

            // ── Track button ──────────────────────────────────────────
            GestureDetector(
              onTap: () => context.push(
                  Routes.trackOrder.replaceFirst(':id', order.id)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius:
                      BorderRadius.circular(AppColors.radius),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x472563EB),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Track order',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 4-step horizontal stepper
// Steps: Order Placed | Shipped | In Transit | Delivered
// ──────────────────────────────────────────────────────────────────────────────

class _OrderStepper extends StatelessWidget {
  const _OrderStepper({required this.activeStep});
  final int activeStep; // 0-3

  static const _steps = [
    _StepDef(label: 'Order\nPlaced', icon: Icons.shopping_bag_outlined),
    _StepDef(label: 'Shipped', icon: Icons.inventory_2_outlined),
    _StepDef(label: 'In Transit', icon: Icons.local_shipping_outlined),
    _StepDef(label: 'Delivered', icon: Icons.check_rounded),
  ];

  // Navy-ish active bg matching design (#CFE0FB / #16447B)
  static const Color _activeBg = AppColors.chipBlue;
  static const Color _activeIcon = AppColors.navyLabel;
  static const Color _pendingBg = Color(0xFFFFFFFF); // pure white — intentional
  static const Color _pendingBorder = AppColors.radioIdle;
  static const Color _connectorActive = AppColors.navyTile;
  static const Color _connectorPending = AppColors.radioIdle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                // Circle + connector row — fully responsive, no fixed px
                SizedBox(
                  height: 38,
                  child: Row(
                    children: [
                      // Left half-connector (hidden for first step)
                      Expanded(
                        child: i > 0
                            ? Container(
                                height: 3,
                                color: i <= activeStep
                                    ? _connectorActive
                                    : _connectorPending,
                              )
                            : const SizedBox.shrink(),
                      ),
                      // Circle
                      _StepCircle(
                        stepDef: _steps[i],
                        isDone: i <= activeStep,
                        activeBg: _activeBg,
                        activeIcon: _activeIcon,
                        pendingBg: _pendingBg,
                        pendingBorder: _pendingBorder,
                      ),
                      // Right half-connector (hidden for last step)
                      Expanded(
                        child: i < _steps.length - 1
                            ? Container(
                                height: 3,
                                color: i < activeStep
                                    ? _connectorActive
                                    : _connectorPending,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _steps[i].label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: i <= activeStep
                        ? _activeIcon
                        : AppColors.mutedDisabled,
                    height: 1.25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StepDef {
  const _StepDef({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.stepDef,
    required this.isDone,
    required this.activeBg,
    required this.activeIcon,
    required this.pendingBg,
    required this.pendingBorder,
  });
  final _StepDef stepDef;
  final bool isDone;
  final Color activeBg;
  final Color activeIcon;
  final Color pendingBg;
  final Color pendingBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: isDone ? activeBg : pendingBg,
        shape: BoxShape.circle,
        border: isDone
            ? null
            : Border.all(color: pendingBorder, width: 2),
      ),
      alignment: Alignment.center,
      child: Icon(
        stepDef.icon,
        size: 18,
        color: isDone ? activeIcon : AppColors.mutedDisabled,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Hub row card
// ──────────────────────────────────────────────────────────────────────────────

class _HubRow extends StatelessWidget {
  const _HubRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: AppColors.fieldBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F0F172A),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: AppColors.text),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.text,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.mutedDisabled,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
