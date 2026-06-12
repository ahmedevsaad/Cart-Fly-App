import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/models/order.dart';
import '../../state/orders_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_states.dart';
import '../../widgets/cf_top_bar.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Frame 25 — "Track your order"
// 3-step stepper: order confirmed / order shipped / out for delivery
// Current-status card + tracking history list
// ──────────────────────────────────────────────────────────────────────────────

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key, required this.id});
  final String id;

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

    return CfScaffold(
      topBar: const CfTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Title ─────────────────────────────────────────────────
            Text(
              'Track your order',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 14),

            // ── 3-step stepper ────────────────────────────────────────
            _TrackStepper(status: order.status),
            const SizedBox(height: 18),

            // ── Current status card ───────────────────────────────────
            _CurrentStatusCard(status: order.status),
            const SizedBox(height: 16),

            // ── Tracking history ──────────────────────────────────────
            Text(
              'Tracking History',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 11),

            _TrackingHistory(status: order.status),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 3-step stepper: confirmed / shipped / out for delivery
// ──────────────────────────────────────────────────────────────────────────────

class _TrackStepper extends StatelessWidget {
  const _TrackStepper({required this.status});
  final OrderStatus status;

  // Design: step 1 = confirmed (#ACFF9C), step 2 = shipped, step 3 = out for delivery (#E2E8F0 pending)
  static int _activeStep(OrderStatus s) {
    switch (s) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.atWarehouse:
      case OrderStatus.packaging:
        return 1;
      case OrderStatus.shipped:
      case OrderStatus.ready:
        return 1;
      case OrderStatus.delivered:
        return 2;
    }
  }

  static const Color _greenBg = AppColors.stepGreen;
  static const Color _greyBg = AppColors.cardBorder;  // 0xFFE2E8F0
  static const Color _greyText = AppColors.mutedDisabled;

  @override
  Widget build(BuildContext context) {
    final step = _activeStep(status);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepNode(
          number: 1,
          label: 'order\nconfirmed',
          done: step >= 0,
          greenBg: _greenBg,
          greyBg: _greyBg,
          greyText: _greyText,
        ),
        _StepConnector(done: step >= 1),
        _StepNode(
          number: 2,
          label: 'order\nshipped',
          done: step >= 1,
          greenBg: _greenBg,
          greyBg: _greyBg,
          greyText: _greyText,
        ),
        _StepConnector(done: step >= 2),
        _StepNode(
          number: 3,
          label: 'out for\ndelivery',
          done: step >= 2,
          greenBg: _greenBg,
          greyBg: _greyBg,
          greyText: _greyText,
        ),
      ],
    );
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({
    required this.number,
    required this.label,
    required this.done,
    required this.greenBg,
    required this.greyBg,
    required this.greyText,
  });
  final int number;
  final String label;
  final bool done;
  final Color greenBg;
  final Color greyBg;
  final Color greyText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: done ? greenBg : greyBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: done ? AppColors.text : greyText,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 10.5,
              color: done ? AppColors.text : greyText,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.done});
  final bool done;

  static const Color _greenBg = AppColors.stepGreen;
  static const Color _greyBg = AppColors.radioIdle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(top: 19),
        color: done ? _greenBg : _greyBg,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Current status card
// ──────────────────────────────────────────────────────────────────────────────

class _CurrentStatusCard extends StatelessWidget {
  const _CurrentStatusCard({required this.status});
  final OrderStatus status;

  static const Color _navy = AppColors.navyLabel;

  String _statusLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.placed:
        return 'Order Confirmed';
      case OrderStatus.atWarehouse:
      case OrderStatus.packaging:
        return 'At Warehouse';
      case OrderStatus.shipped:
      case OrderStatus.ready:
        return 'In Transit';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  String _statusMessage(OrderStatus s) {
    switch (s) {
      case OrderStatus.placed:
        return 'Your order has been confirmed and is awaiting pickup.';
      case OrderStatus.atWarehouse:
      case OrderStatus.packaging:
        return 'Your package is at our warehouse and being prepared.';
      case OrderStatus.shipped:
      case OrderStatus.ready:
        return 'Your package is on the way to the destination country.';
      case OrderStatus.delivered:
        return 'Your package has been delivered successfully.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'current status',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Status icon bubble
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: _navy,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Text(
                _statusLabel(status),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: _navy,
                ),
              ),
              const Spacer(),
              // Globe icon
              const Icon(Icons.public_rounded, color: _navy, size: 36),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _statusMessage(status),
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedLabel,
            ),
          ),
          const SizedBox(height: 13),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.navyLabel,
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Text(
                'Expected Delivery',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _navy,
                ),
              ),
              const Spacer(),
              Text(
                '15 June 2026',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Tracking history list
// ──────────────────────────────────────────────────────────────────────────────

/// Represents one history entry.
class _HistoryEntry {
  const _HistoryEntry({
    required this.label,
    required this.state,
  });
  final String label;

  /// 'done' = green check, 'active' = navy/blue current, 'pending' = grey
  final String state;
}

class _TrackingHistory extends StatelessWidget {
  const _TrackingHistory({required this.status});
  final OrderStatus status;

  List<_HistoryEntry> _entries(OrderStatus s) {
    final idx = s.index; // 0=placed,1=atWarehouse,2=packaging,3=shipped,4=ready,5=delivered
    return [
      _HistoryEntry(
          label: 'Order confirmed',
          state: idx >= 0 ? 'done' : 'pending'),
      _HistoryEntry(
          label: 'Package Received',
          state: idx >= 1 ? 'done' : 'pending'),
      _HistoryEntry(
          label: 'In transit',
          state: idx >= 3
              ? 'done'
              : idx >= 2
                  ? 'active'
                  : 'pending'),
      _HistoryEntry(
          label: 'Custom clearance',
          state: idx >= 4 ? 'done' : 'pending'),
      _HistoryEntry(
          label: 'Out for Delivery',
          state: idx >= 4 ? 'done' : 'pending'),
      _HistoryEntry(
          label: 'Delivered',
          state: idx >= 5 ? 'done' : 'pending'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries(status);
    return Column(
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          _HistoryRow(entry: entries[i]),
          if (i < entries.length - 1) const SizedBox(height: 7),
        ],
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});
  final _HistoryEntry entry;

  static const Color _greenCheck = AppColors.success;   // 0xFF15803D ≈ 0xFF22C55E
  static const Color _navyBg = AppColors.chipBlue;
  static const Color _navy = AppColors.navyLabel;
  static const Color _greyBg = AppColors.cardBorder;    // 0xFFE2E8F0

  @override
  Widget build(BuildContext context) {
    final isDone = entry.state == 'done';
    final isActive = entry.state == 'active';

    Widget dot;
    if (isDone) {
      dot = Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: _greenCheck,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 13),
      );
    } else if (isActive) {
      dot = Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: _navyBg,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.local_shipping_outlined,
            color: _navy, size: 13),
      );
    } else {
      dot = Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: _greyBg,
          shape: BoxShape.circle,
        ),
      );
    }

    return Row(
      children: [
        dot,
        const SizedBox(width: 11),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? _navyBg : AppColors.fieldBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              entry.label,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                color: isActive
                    ? _navy
                    : isDone
                        ? AppColors.text
                        : AppColors.mutedDisabled,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
