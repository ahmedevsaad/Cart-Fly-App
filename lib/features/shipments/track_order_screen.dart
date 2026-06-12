import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/order.dart';
import '../../l10n/app_localizations.dart';
import '../../state/orders_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_journey_nav.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_states.dart';
import '../../widgets/cf_top_bar.dart';
import '../../widgets/icons/cf_icons.dart';

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

    // Order already in the live stream — render directly.
    if (order != null) {
      return _TrackBody(id: id, order: order);
    }

    // Not in stream yet — fetch once from Firestore, then let stream take over.
    return FutureBuilder<Order>(
      future: context.read<OrdersProvider>().getOnce(id),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return CfScaffold(
            topBar: const CfTopBar(),
            bottomNav: cfJourneyNav(context),
            body: const CfLoading(),
          );
        }
        if (snap.hasError || !snap.hasData) {
          return CfScaffold(
            topBar: const CfTopBar(),
            bottomNav: cfJourneyNav(context),
            body: const CfEmptyState(message: 'Order not found'),
          );
        }
        return _TrackBody(id: id, order: snap.data!);
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// _TrackBody — actual content once order is resolved.
// StatefulWidget so we can track async advance in-progress state.
// ──────────────────────────────────────────────────────────────────────────────

class _TrackBody extends StatefulWidget {
  const _TrackBody({required this.id, required this.order});
  final String id;
  final Order order;

  @override
  State<_TrackBody> createState() => _TrackBodyState();
}

class _TrackBodyState extends State<_TrackBody> {
  bool _advancing = false;

  Future<void> _advance() async {
    if (_advancing) return;
    setState(() => _advancing = true);
    try {
      await context.read<OrdersProvider>().advance(widget.id);
    } finally {
      if (mounted) setState(() => _advancing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final order = widget.order;
    final isDelivered = order.status == OrderStatus.delivered;

    return CfScaffold(
      topBar: const CfTopBar(),
      bottomNav: cfJourneyNav(context),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 22, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Title ─────────────────────────────────────────────────
            Text(
              l.trackOrderTitle,
              style: AppText.title.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 14),

            // ── 3-step stepper ────────────────────────────────────────
            _TrackStepper(status: order.status),
            const SizedBox(height: 18),

            // ── Current status card ───────────────────────────────────
            _CurrentStatusCard(status: order.status),
            const SizedBox(height: 16),

            // ── Advance status button (hidden when delivered) ─────────
            if (!isDelivered) ...[
              CfButton(
                label: _advancing ? '…' : l.advanceStatus,
                onPressed: _advancing ? null : _advance,
              ),
              const SizedBox(height: 16),
            ],

            // ── Tracking history ──────────────────────────────────────
            Text(
              l.trackHistory,
              style: AppText.body.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 17,
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
// Nodes are Expanded; connectors are also Expanded — no fixed SizedBox widths.
// ──────────────────────────────────────────────────────────────────────────────

class _TrackStepper extends StatelessWidget {
  const _TrackStepper({required this.status});
  final OrderStatus status;

  // Design: step 1 = confirmed (#ACFF9C), step 2 = shipped, step 3 = out for delivery
  // OrderStatus: placed=0, atWarehouse=1, packaging=2, shipped=3, ready=4, delivered=5
  // shipped(3) + ready(4) → step index 2 (connector 2 done)
  static int _activeStep(OrderStatus s) {
    switch (s) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.atWarehouse:
      case OrderStatus.packaging:
        return 1;
      case OrderStatus.shipped:
      case OrderStatus.ready:
        return 2;
      case OrderStatus.delivered:
        return 2;
    }
  }

  static const Color _greenBg = AppColors.stepGreen;
  static const Color _greyBg = AppColors.cardBorder;    // 0xFFE2E8F0
  static const Color _greyText = AppColors.mutedDisabled;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final step = _activeStep(status);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepNode(
          number: 1,
          label: l.trackStepConfirmed,
          done: step >= 0,
          greenBg: _greenBg,
          greyBg: _greyBg,
          greyText: _greyText,
        ),
        _StepConnector(done: step >= 1),
        _StepNode(
          number: 2,
          label: l.trackStepShipped,
          done: step >= 1,
          greenBg: _greenBg,
          greyBg: _greyBg,
          greyText: _greyText,
        ),
        _StepConnector(done: step >= 2),
        _StepNode(
          number: 3,
          label: l.trackStepOutForDelivery,
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
    return Expanded(
      child: Semantics(
        label: 'Step $number: $label',
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
                style: AppText.body.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: done ? AppColors.text : greyText,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppText.caption.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 10.5,
                color: done ? AppColors.text : greyText,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.done});
  final bool done;

  static const Color _greenBg = AppColors.stepGreen;
  static const Color _greyBg = AppColors.radioIdle;    // 0xFFCBD5E1

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsetsDirectional.only(top: 19),
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

  String _statusLabel(OrderStatus s, AppLocalizations l) {
    switch (s) {
      case OrderStatus.placed:
        return l.statusOrderConfirmed;
      case OrderStatus.atWarehouse:
      case OrderStatus.packaging:
        return l.statusAtWarehouse;
      case OrderStatus.shipped:
      case OrderStatus.ready:
        return l.statusInTransit;
      case OrderStatus.delivered:
        return l.statusDelivered;
    }
  }

  String _statusMessage(OrderStatus s, AppLocalizations l) {
    switch (s) {
      case OrderStatus.placed:
        return l.statusPlacedMsg;
      case OrderStatus.atWarehouse:
      case OrderStatus.packaging:
        return l.statusPackagingMsg;
      case OrderStatus.shipped:
      case OrderStatus.ready:
        return l.statusShippedMsg;
      case OrderStatus.delivered:
        return l.statusDeliveredMsg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsetsDirectional.all(16),
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
            l.trackCurrentStatus,
            style: AppText.caption.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Status icon bubble — uses CfIcons.stepTruck per design
              Semantics(
                label: _statusLabel(status, l),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: _navy,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: CfIcons.stepTruck(size: 20, color: Colors.white),
                ),
              ),
              const SizedBox(width: 11),
              Text(
                _statusLabel(status, l),
                style: AppText.body.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: _navy,
                ),
              ),
              const Spacer(),
              // Globe icon — uses CfIcons.globe per design
              CfIcons.globe(size: 40, color: _navy),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _statusMessage(status, l),
            style: AppText.caption.copyWith(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedLabel,
            ),
          ),
          const SizedBox(height: 13),
          // Divider at 25% opacity as per design spec
          Container(
            height: 1,
            color: AppColors.navyLabel.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Text(
                l.trackExpectedDelivery,
                style: AppText.caption.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _navy,
                ),
              ),
              const Spacer(),
              Text(
                l.trackExpectedDate,
                style: AppText.body.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
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

  List<_HistoryEntry> _entries(OrderStatus s, AppLocalizations l) {
    final idx = s.index; // 0=placed,1=atWarehouse,2=packaging,3=shipped,4=ready,5=delivered
    return [
      _HistoryEntry(
          label: l.trackHistoryOrderConfirmed,
          state: idx >= 0 ? 'done' : 'pending'),
      _HistoryEntry(
          label: l.trackHistoryPackageReceived,
          state: idx >= 1 ? 'done' : 'pending'),
      _HistoryEntry(
          label: l.trackHistoryInTransit,
          state: idx >= 3
              ? 'done'
              : idx >= 2
                  ? 'active'
                  : 'pending'),
      _HistoryEntry(
          label: l.trackHistoryCustomClearance,
          state: idx >= 4 ? 'done' : 'pending'),
      _HistoryEntry(
          label: l.trackHistoryOutForDelivery,
          state: idx >= 4 ? 'done' : 'pending'),
      _HistoryEntry(
          label: l.trackHistoryDelivered,
          state: idx >= 5 ? 'done' : 'pending'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final entries = _entries(status, l);
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
      // done = green circle with CfIcons.stepCheck
      dot = Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: _greenCheck,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: CfIcons.stepCheck(size: 13, color: Colors.white),
      );
    } else if (isActive) {
      // active = navy-bg circle with CfIcons.stepTruck
      dot = Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: _navyBg,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: CfIcons.stepTruck(size: 13, color: _navy),
      );
    } else {
      // pending = plain grey circle
      dot = Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: _greyBg,
          shape: BoxShape.circle,
        ),
      );
    }

    return Semantics(
      label: '${entry.label}: ${entry.state}',
      child: Row(
        children: [
          dot,
          const SizedBox(width: 11),
          Expanded(
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
              decoration: BoxDecoration(
                color: isActive ? _navyBg : AppColors.fieldBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                entry.label,
                style: AppText.body.copyWith(
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
      ),
    );
  }
}
