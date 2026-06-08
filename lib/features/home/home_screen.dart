import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../router/routes.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_card.dart';
import '../../widgets/cf_list_row.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import '../auth/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userName =
        context.watch<AuthProvider>().state.user?.name ?? 'there';

    return CfScaffold(
      topBar: const CfTopBar(showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Hello, $userName!',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            CfCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  CfListRow(
                    label: 'Our warehouses',
                    onTap: () => context.push(Routes.warehouses),
                  ),
                  const Divider(height: 1),
                  CfListRow(
                    label: 'Locker locations',
                    onTap: () => context.push(Routes.lockers),
                  ),
                  const Divider(height: 1),
                  CfListRow(
                    label: 'Subscription plans',
                    onTap: () => context.push(Routes.plans),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CfButton(
              label: 'Create shipment',
              onPressed: () => context.push(Routes.createShipment),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
