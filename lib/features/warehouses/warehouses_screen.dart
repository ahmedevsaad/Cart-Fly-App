import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/warehouses.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/flag_icon.dart';
import '../../widgets/section_drawer.dart';

class WarehousesScreen extends StatelessWidget {
  const WarehousesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      endDrawer: const SectionDrawer(),
      body: AppBackground(
        child: SafeArea(
          child: Builder(
            builder: (context) => Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 28),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    const AppLogo(size: 24),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ],
                ),
                Text(
                  t.ourWarehouses,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 8),
                    childAspectRatio: 1.0,
                    children: [
                      for (final w in warehouses)
                        InkWell(
                          onTap: () => context
                              .push('${Routes.warehouses}/${w.code}'),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlagIcon(code: w.code, size: 120),
                              const SizedBox(height: 8),
                              Text(
                                w.displayName,
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
