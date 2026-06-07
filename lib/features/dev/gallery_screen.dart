import 'package:flutter/material.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_card.dart';
import '../../widgets/cf_list_row.dart';
import '../../widgets/cf_flag_card.dart';
import '../../widgets/cf_status_timeline.dart';
import '../../widgets/cf_states.dart';

/// Temporary gallery — removed in Stage 9.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      topBar: const CfTopBar(showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // ── Buttons ─────────────────────────────────────────────────────
          const Text('Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CfButton(label: 'Primary Button', onPressed: () {}),
          const SizedBox(height: 8),
          CfOutlineButton(label: 'Outline Button', onPressed: () {}),
          const SizedBox(height: 24),

          // ── Input ────────────────────────────────────────────────────────
          const Text('Input', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CfInput(label: 'Email:', controller: _emailCtrl),
          const SizedBox(height: 24),

          // ── Card ─────────────────────────────────────────────────────────
          const Text('Card', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CfCard(
            child: const Text('This is a CfCard with some content inside.'),
          ),
          const SizedBox(height: 24),

          // ── List Row ─────────────────────────────────────────────────────
          const Text('List Row', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CfCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                CfListRow(label: 'My Orders', onTap: () {}),
                CfListRow(label: 'Settings', onTap: () {}),
                CfListRow(label: 'Help & Support', onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Flag Cards ───────────────────────────────────────────────────
          const Text('Flag Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CfFlagCard(code: 'SA', name: 'Saudi Arabia', onTap: () {}),
              CfFlagCard(code: 'CN', name: 'China', onTap: () {}),
              CfFlagCard(code: 'AE', name: 'UAE', onTap: () {}),
            ],
          ),
          const SizedBox(height: 24),

          // ── Status Timeline ──────────────────────────────────────────────
          const Text('Status Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CfCard(
            child: CfStatusTimeline(
              steps: const [
                'Waiting',
                'At warehouse',
                'Shipped',
                'In transit',
                'Out for delivery',
                'Delivered',
              ],
              activeIndex: 2,
            ),
          ),
          const SizedBox(height: 24),

          // ── Empty State ──────────────────────────────────────────────────
          const Text('Empty State', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: CfEmptyState(message: 'No items found.'),
          ),
          const SizedBox(height: 24),

          // ── Error State ──────────────────────────────────────────────────
          const Text('Error State', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: CfErrorState(message: 'Something went wrong.', onRetry: () {}),
          ),
          const SizedBox(height: 24),
        ],
        ),
      ),
    );
  }
}
