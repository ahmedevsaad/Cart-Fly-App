import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../router/routes.dart';
import '../../state/orders_provider.dart';
import '../../widgets/cf_card.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_states.dart';
import '../../widgets/cf_top_bar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();
    final orders = provider.orders;

    return CfScaffold(
      topBar: const CfTopBar(),
      body: orders.isEmpty
          ? const CfEmptyState(message: 'No shipments yet')
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final order = orders[i];
                return GestureDetector(
                  onTap: () => context.push(
                    Routes.orderDetail.replaceFirst(':id', order.id),
                  ),
                  child: CfCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order.status.name,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
