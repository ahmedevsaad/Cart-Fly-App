import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app/locale_provider.dart';
import '../features/auth/auth_provider.dart';
import '../l10n/app_localizations.dart';
import '../router/routes.dart';

class SectionDrawer extends StatelessWidget {
  const SectionDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final lp = context.watch<LocaleProvider>();
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text(t.language),
              trailing: Text(lp.locale.languageCode == 'en' ? 'EN' : 'AR'),
              onTap: () => context.read<LocaleProvider>().toggle(),
            ),
            ListTile(
              title: Text(t.support),
              onTap: () {
                Navigator.pop(context);
                context.go(Routes.support);
              },
            ),
            ListTile(
              title: Text(t.logout),
              onTap: () => context.read<AuthProvider>().logout(),
            ),
          ],
        ),
      ),
    );
  }
}
