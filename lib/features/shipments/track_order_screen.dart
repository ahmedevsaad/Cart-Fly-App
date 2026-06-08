import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/orders_provider.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_states.dart';
import '../../widgets/cf_status_timeline.dart';
import '../../widgets/cf_top_bar.dart';

const _statusLabels = [
  'Order placed',
  'At warehouse',
  'Packaging',
  'Shipped',
  'Ready for pickup',
  'Delivered',
];

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Track your order',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              order.title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            CfStatusTimeline(
              steps: _statusLabels,
              activeIndex: order.status.index,
            ),
            const SizedBox(height: 32),
            CfButton(
              label: 'Advance status',
              onPressed: () =>
                  context.read<OrdersProvider>().advance(id),
            ),
          ],
        ),
      ),
    );
  }
}
