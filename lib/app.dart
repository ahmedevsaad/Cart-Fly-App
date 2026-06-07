import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app/locale_provider.dart';
import 'features/auth/auth_provider.dart';
import 'l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class CartFlyApp extends StatefulWidget {
  const CartFlyApp({super.key});

  @override
  State<CartFlyApp> createState() => _CartFlyAppState();
}

class _CartFlyAppState extends State<CartFlyApp> {
  late final AuthProvider _auth = AuthProvider();
  late final LocaleProvider _locale = LocaleProvider()..load();

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
        ChangeNotifierProvider.value(value: _locale),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, lp, _) {
          return MaterialApp.router(
            title: 'CartFly',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(lp.locale),
            locale: lp.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: buildRouter(_auth),
          );
        },
      ),
    );
  }
}
