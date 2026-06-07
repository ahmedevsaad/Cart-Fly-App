# Stage 3 — Navigation Shell & Dynamic Bottom Bar

**Goal:** Build the persistent 4-tab shell with a **dynamic bottom bar** (active-tab highlight, state preserved per tab) using `go_router`'s `StatefulShellRoute.indexedStack`, wire the auth redirect, and rewrite `app.dart` with all providers.

**Prereq:** Stage 2 complete.

**Files:**
- Create: `lib/widgets/cf_bottom_nav.dart`, `lib/state/settings_provider.dart`
- Create: `lib/router/app_router.dart` (new shell router)
- Modify: `lib/router/routes.dart` (full route set), `lib/app.dart` (providers + MaterialApp.router)
- Create placeholder tab screens: `lib/features/home/home_screen.dart`, `lib/features/profile/profile_screen.dart`, `lib/features/menu/menu_screen.dart`, `lib/features/settings/settings_screen.dart`

**Contract (fixed):** tab index `0=Home, 1=Profile, 2=Menu, 3=Settings`.

---

### Task 3.1: Route name constants

**Files:** Modify `lib/router/routes.dart`

- [ ] **Step 1: Replace with the full route set**

```dart
class Routes {
  Routes._();
  // auth (outside shell)
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const verify = '/verify';
  static const forgot = '/forgot';
  static const welcome = '/welcome';
  // shell tabs
  static const home = '/home';
  static const profile = '/profile';
  static const menu = '/menu';
  static const settings = '/settings';
  // pushed flows
  static const warehouses = '/warehouses';
  static const warehouseDetail = '/warehouses/:code';
  static const lockers = '/lockers';
  static const lockersCountry = '/lockers/:code';
  static const createShipment = '/shipments/new';
  static const orders = '/orders';
  static const orderDetail = '/orders/:id';
  static const trackOrder = '/orders/:id/track';
  static const plans = '/plans';
  static const planDetail = '/plans/:code';     // basic|smart|prime
  static const payment = '/payment';            // query: ?for=plan_<code>
  static const paymentSuccess = '/payment/success';
  static const paymentError = '/payment/error';
  static const howItWorks = '/how-it-works';
  static const support = '/support';
  static const about = '/about';
  static const policy = '/policy';
  static const editProfile = '/profile/edit';
  static const changePassword = '/profile/password';
  static const settingsLanguage = '/settings/language';
  static const settingsCurrency = '/settings/currency';
}
```

- [ ] **Step 2: Analyze + commit.**

### Task 3.2: SettingsProvider (locale + currency)

**Files:** Create `lib/state/settings_provider.dart`

> Wraps the existing `LocaleProvider` behavior (shared_preferences) and adds currency (default until a profile loads; Stage 8 syncs to Firestore).

- [ ] **Step 1: Implement**

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  String _currency = 'USD';
  Locale get locale => _locale;
  String get currency => _currency;

  static const _localeKey = 'locale';
  static const _currencyKey = 'currency';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final code = p.getString(_localeKey);
    if (code != null) _locale = Locale(code);
    _currency = p.getString(_currencyKey) ?? 'USD';
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString(_localeKey, locale.languageCode);
  }

  void toggleLocale() => setLocale(
      _locale.languageCode == 'en' ? const Locale('ar') : const Locale('en'));

  Future<void> setCurrency(String c) async {
    _currency = c;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString(_currencyKey, c);
  }
}
```

- [ ] **Step 2: Analyze + commit.** (Old `lib/app/locale_provider.dart` may be deleted now or in Stage 9 — it is superseded by `SettingsProvider`.)

### Task 3.3: Placeholder tab screens

**Files:** Create the 4 tab screens as minimal `CfScaffold` bodies (filled in later stages).

- [ ] **Step 1:** Each file (`home/home_screen.dart`, `profile/profile_screen.dart`, `menu/menu_screen.dart`, `settings/settings_screen.dart`) looks like:

```dart
import 'package:flutter/material.dart';
import '../../widgets/cf_scaffold.dart';

class HomeScreen extends StatelessWidget {       // rename per file
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const CfScaffold(body: Center(child: Text('Home')));
}
```

- [ ] **Step 2: Analyze + commit.**

### Task 3.4: CfBottomNav (dynamic)

**Files:** Create `lib/widgets/cf_bottom_nav.dart`

- [ ] **Step 1: Implement** — takes the shell's `currentIndex` and a callback; highlights the active tab (active = black pill on the Menu-style item, others = light pill), matching `html/screens/our-plans.html`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class CfBottomNav extends StatelessWidget {
  const CfBottomNav({super.key, required this.currentIndex, required this.onTap});
  final int currentIndex;            // 0=Home,1=Profile,2=Menu,3=Settings
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.navBar,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(0, 'assets/icons/home.svg', 'Home'),
          _item(1, 'assets/icons/account_circle.svg', null),
          _item(2, 'assets/icons/settings.svg', null, isMenu: true),
          _item(3, 'assets/icons/settings.svg', 'Settings'),
        ],
      ),
    );
  }

  Widget _item(int index, String icon, String? label, {bool isMenu = false}) {
    final active = index == currentIndex;
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.black : AppColors.navPill,
          borderRadius: BorderRadius.circular(active ? 8 : 9999),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SvgPicture.asset(icon,
              width: 22, height: 22,
              colorFilter: active
                  ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                  : null),
          if (label != null) ...[
            const SizedBox(width: 4),
            Text(label,
                style: AppText.caption.copyWith(
                    color: active ? Colors.white : Colors.black)),
          ],
        ]),
      ),
    );
  }
}
```

> Note: use the correct per-tab icon (Home/Profile/Menu/Settings) — replace the menu icon asset if a dedicated one exists; otherwise the `≡` text glyph as in the clone is acceptable. Keep it simple.

- [ ] **Step 2: Analyze + commit.**

### Task 3.5: Shell router

**Files:** Create `lib/router/app_router.dart`

- [ ] **Step 1: Implement `StatefulShellRoute.indexedStack`** with the 4 branches + auth redirect (reusing the existing `AuthProvider` status logic).

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_provider.dart';
import '../features/home/home_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/menu/menu_screen.dart';
import '../features/settings/settings_screen.dart';
import '../widgets/cf_bottom_nav.dart';
import 'routes.dart';

const _bypassAuth = bool.fromEnvironment('DEBUG_BYPASS_AUTH');

GoRouter buildRouter(AuthProvider auth) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: auth,
    redirect: (ctx, state) {
      if (_bypassAuth) return null;
      final s = auth.state.status;
      final loc = state.matchedLocation;
      const public = {Routes.splash, Routes.login, Routes.register, Routes.forgot};
      if (s == AuthStatus.loading) return loc == Routes.splash ? null : Routes.splash;
      if (s == AuthStatus.pendingOtp) return loc == Routes.verify ? null : Routes.verify;
      if (s == AuthStatus.unauthenticated) return public.contains(loc) ? null : Routes.login;
      if (public.contains(loc) || loc == Routes.verify) return Routes.home;
      return null;
    },
    routes: [
      // --- auth & full-screen routes (Stage 4+) registered here as added ---
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) => _ShellScaffold(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.profile, builder: (_, __) => const ProfileScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.menu, builder: (_, __) => const MenuScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.settings, builder: (_, __) => const SettingsScreen()),
          ]),
        ],
      ),
    ],
  );
}

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: CfBottomNav(
        currentIndex: shell.currentIndex,
        onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}
```

> As later stages add pushed routes (warehouses, plans, payment, etc.), register them as **top-level `GoRoute`s** in this `routes:` list (siblings of the shell) so they cover the bottom bar, OR as routes inside the relevant branch if they should keep the bar. Default: pushed detail/flows are top-level (no bar) unless the spec says otherwise.

- [ ] **Step 2: Analyze + commit.**

### Task 3.6: Rewrite `app.dart`

**Files:** Modify `lib/app.dart`

- [ ] **Step 1: Wire providers + MaterialApp.router**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'features/auth/auth_provider.dart';
import 'state/settings_provider.dart';
import 'l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class CartFlyApp extends StatefulWidget {
  const CartFlyApp({super.key});
  @override
  State<CartFlyApp> createState() => _CartFlyAppState();
}

class _CartFlyAppState extends State<CartFlyApp> {
  final _auth = AuthProvider();
  final _settings = SettingsProvider()..load();

  @override
  void dispose() { _auth.dispose(); super.dispose(); }

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
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Run with auth bypass** — `flutter run -d chrome --dart-define=DEBUG_BYPASS_AUTH=true`. Manually go to `/home`. Tap the 4 bottom-nav items: each switches the body text (Home/Profile/Menu/Settings) and **the active item highlights**. Switch away and back — tab state preserved.

- [ ] **Step 3: Commit** — `git commit -m "feat(stage3): shell router + dynamic bottom bar + providers"`.

---

## Stage exit check
- `flutter analyze` → No issues found.
- With `DEBUG_BYPASS_AUTH=true`, the 4 tabs switch via the bottom bar and the **active tab highlights dynamically**; each tab keeps its own state.
- Auth redirect logic compiles (full verification in Stage 4 once auth screens exist).
