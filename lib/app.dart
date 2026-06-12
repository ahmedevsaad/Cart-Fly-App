import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'features/auth/auth_provider.dart';
import 'l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'state/orders_provider.dart';
import 'state/plan_provider.dart';
import 'state/settings_provider.dart';
import 'theme/app_theme.dart';

const _bypassAuth = bool.fromEnvironment('DEBUG_BYPASS_AUTH');

class CartFlyApp extends StatefulWidget {
  const CartFlyApp({super.key});
  @override
  State<CartFlyApp> createState() => _CartFlyAppState();
}

class _CartFlyAppState extends State<CartFlyApp> {
  final _auth = AuthProvider();
  final _settings = SettingsProvider()..load();

  @override
  void dispose() {
    _auth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _auth),
        ChangeNotifierProvider.value(value: _settings),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, s, _) => MaterialApp.router(
          title: 'CartFly',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          locale: s.locale,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: buildRouter(_auth),
          builder: (context, child) {
            final uid = context.watch<AuthProvider>().state.user?.uid;
            if (uid == null) return child!;
            return MultiProvider(
              key: ValueKey(uid),
              providers: [
                ChangeNotifierProvider(
                    create: (_) =>
                        OrdersProvider(uid: uid, demo: _bypassAuth)),
                ChangeNotifierProvider(
                    create: (_) => PlanProvider(uid: uid)),
              ],
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
