import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/routes.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_list_row.dart';
import '../../widgets/cf_scaffold.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CfButton(
              label: 'Lockers',
              onPressed: () => context.push(Routes.lockers),
            ),
            const SizedBox(height: 12),
            CfButton(
              label: 'Home Delivery',
              onPressed: () => context.push(Routes.warehouses),
            ),
            const SizedBox(height: 24),
            CfListRow(
              label: 'How it works',
              onTap: () => context.push(Routes.howItWorks),
            ),
          ],
        ),
      ),
    );
  }
}
