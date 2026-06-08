import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/orders_provider.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_states.dart';
import '../../widgets/cf_top_bar.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.id});
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
            Text(order.title,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _Row('Source country', order.sourceCountry.toUpperCase()),
            _Row('Delivery method', order.deliveryMethod.name),
            _Row('Status', order.status.name),
            if (order.lockerId != null) _Row('Locker', order.lockerId!),
            const SizedBox(height: 32),
            CfButton(
              label: 'Track',
              onPressed: () => context.push('/orders/$id/track'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label: ',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
