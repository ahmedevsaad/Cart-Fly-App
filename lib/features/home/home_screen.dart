import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/menu_button.dart';
import '../../widgets/section_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    const Spacer(),
                    const AppLogo(size: 28),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      MenuButton(
                        label: t.ourWarehouses,
                        onTap: () => context.push(Routes.warehouses),
                      ),
                      const SizedBox(height: 22),
                      MenuButton(
                        label: t.howItWorks,
                        onTap: () => context.push(Routes.howItWorks),
                      ),
                      const SizedBox(height: 22),
                      MenuButton(
                        label: t.haveAnIssue,
                        onTap: () => context.push(Routes.support),
                      ),
                      const SizedBox(height: 22),
                      MenuButton(
                        label: t.lockerLocations,
                        onTap: () => context.push(Routes.lockers),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
