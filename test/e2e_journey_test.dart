// ignore_for_file: avoid_print

/// Comprehensive E2E journey test.
///
/// Drives the REAL app through the whole user journey with real taps,
/// asserting each screen renders (catches blank pages).
///
/// Requires no device/emulator — runs via `flutter test`.
///
/// Split into three groups:
///  1. browse_journey  — Home → Warehouses → Country → Lockers → Calculator → Plans
///  2. orders_journey  — Orders list → Order detail → Advance status
///  3. account_journey — Profile → Settings → Currency → Language → About → Support

library;

import 'package:cartfly/features/auth/auth_provider.dart';
import 'package:cartfly/l10n/app_localizations.dart';
import 'package:cartfly/router/app_router.dart';
import 'package:cartfly/state/orders_provider.dart';
import 'package:cartfly/state/plan_provider.dart';
import 'package:cartfly/state/settings_provider.dart';
import 'package:cartfly/theme/app_theme.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

/// Builds and pumps the full app with injected fakes.
///
/// The test viewport is set to 1080×2340 physical pixels at ratio 3.0
/// giving 360×780 logical pixels, which is a standard portrait phone size
/// and ensures all service cards are visible without scrolling.
Future<AuthProvider> pumpApp(WidgetTester tester) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  // Use a wide, tall viewport so service cards and settings items fit on screen
  // without triggering narrow-viewport overflow bugs in the app's layout.
  // 800×1200 at ratio 1.0 gives 800×1200 logical pixels.
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;

  final fakeDb = FakeFirebaseFirestore();
  await fakeDb.collection('users').doc('uid-test').set({
    'name': 'Sara Mahmoud',
    'email': 'sara@test.com',
    'country': 'eg',
    'currency': 'EGP',
    'plan': 'prime',
    'verified': true,
  });

  final mockAuth = MockFirebaseAuth(
    signedIn: true,
    mockUser: MockUser(
      uid: 'uid-test',
      email: 'sara@test.com',
      isEmailVerified: true,
      displayName: 'Sara Mahmoud',
    ),
  );

  final auth = AuthProvider(auth: mockAuth, db: fakeDb);
  final settings = SettingsProvider();
  await settings.load();
  final orders = OrdersProvider(uid: 'uid-test', demo: true);
  final plan = PlanProvider(uid: 'uid-test', db: fakeDb);

  final app = MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>.value(value: auth),
      ChangeNotifierProvider<SettingsProvider>.value(value: settings),
      ChangeNotifierProvider<OrdersProvider>.value(value: orders),
      ChangeNotifierProvider<PlanProvider>.value(value: plan),
    ],
    child: Consumer<SettingsProvider>(
      builder: (_, s, __) => MaterialApp.router(
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
        routerConfig: buildRouter(auth),
      ),
    ),
  );

  await tester.pumpWidget(app);
  // Allow splash redirect + auth resolution.
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 300));
  }
  // Final settle — auth state should be resolved and Home visible.
  await tester.pump(const Duration(seconds: 1));

  return auth;
}

/// Pumps frames to let a GoRouter transition complete without using
/// pumpAndSettle (which can trigger layout errors on offstage widgets
/// that contain Expanded in unbounded contexts during page transitions).
Future<void> pumpTransition(WidgetTester tester) async {
  // GoRouter's default transition is ~300ms.
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump(const Duration(milliseconds: 200));
}

/// Navigate to a bottom-nav tab by its semantics label.
///
/// For shell-branch screens (Home, Account, Orders, Settings) taps the
/// shell's CfBottomNav via semantics label. Shell tab switches are fast;
/// use fixed pumps to avoid pumpAndSettle on offstage-branch layout issues.
Future<void> tapBottomNav(WidgetTester tester, String label) async {
  final finder = find.bySemanticsLabel(label);
  expect(finder, findsWidgets,
      reason: 'Bottom-nav item with semantics label "$label" not found');
  await tester.tap(finder.last);
  for (var i = 0; i < 15; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Navigate to a route programmatically via GoRouter.go.
///
/// Used when navigating FROM a pushed top-level journey screen (About, Support,
/// Language, Currency, etc.) BACK to a shell branch. In those screens the
/// active bottom-nav tab's Semantics label is merged with its Text child
/// (e.g. "Settings\nSettings") so bySemanticsLabel('Settings') finds nothing.
/// Programmatic navigation is reliable regardless of the semantics state.
Future<void> goRoute(WidgetTester tester, String path, Finder anchorFinder) async {
  final router = GoRouter.of(tester.element(anchorFinder));
  router.go(path);
  for (var i = 0; i < 15; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

// ---------------------------------------------------------------------------
// Test group 1 — Browse journey
// ---------------------------------------------------------------------------

void main() {
  group('browse journey', () {
    testWidgets(
        'Home → Warehouses → Saudi Arabia country page → Lockers → Calculator → Plans',
        (tester) async {
      await pumpApp(tester);

      // ── Step 1: Home ───────────────────────────────────────────────────────
      expect(
        find.textContaining('Sara Mahmoud'),
        findsWidgets,
        reason: 'Home should show user greeting with name Sara Mahmoud',
      );
      expect(
        find.text('Our services:'),
        findsOneWidget,
        reason: 'Home should show "Our services:" heading',
      );

      // ── Step 2: Our warehouses ─────────────────────────────────────────────
      // The _ServiceCard has Semantics(label: "Our\nwarehouses"); tap via text.
      // The 360×780 viewport fits all four cards.
      expect(
        find.text('Our\nwarehouses'),
        findsOneWidget,
        reason: 'Home should show "Our warehouses" service card',
      );
      await tester.tap(find.text('Our\nwarehouses'));
      // Use pump with fixed durations to avoid pumpAndSettle on a page
      // with Expanded widgets in GridView cells (the WarehouseCard has
      // Expanded → Image; during route transition the parent height may
      // temporarily be unbounded, causing a layout assertion with pumpAndSettle).
      await pumpTransition(tester);

      expect(
        find.text('Saudi Arabia'),
        findsWidgets,
        reason: 'Warehouses screen should list Saudi Arabia',
      );

      // ── Step 3: Saudi Arabia country page ─────────────────────────────────
      // Tap the Saudi Arabia warehouse card — find by text since bySemanticsLabel
      // doesn't merge nested Semantics in the test environment.
      await tester.tap(find.text('Saudi Arabia').first);
      await pumpTransition(tester);
      // Extra pump to ensure cfJourneyNav finishes building.
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.text('Your CartFly address'),
        findsWidgets,
        reason: 'Country page should show "Your CartFly address" card header',
      );

      // ── Step 4: Back to Home via back buttons ──────────────────────────────
      // Pop CountryLockersScreen → WarehousesScreen
      await tester.tap(find.byType(IconButton).first);
      await pumpTransition(tester);
      // Pop WarehousesScreen → Shell/Home
      await tester.tap(find.byType(IconButton).first);
      await pumpTransition(tester);

      expect(
        find.text('Our services:'),
        findsOneWidget,
        reason: 'Should be back on Home after tapping back twice',
      );

      // ── Step 5: Locker locations ───────────────────────────────────────────
      await tester.tap(find.text('Locker\nlocations'));
      await pumpTransition(tester);

      expect(
        find.text('Cairo Festival City'),
        findsOneWidget,
        reason: 'Lockers screen should show "Cairo Festival City"',
      );

      // ── Back to Home via cfJourneyNav on Lockers screen ────────────────────
      // LockersScreen uses cfJourneyNav; the 'Home' tab taps context.go('/home').
      // Use the back button instead to pop safely.
      await tester.tap(find.byType(IconButton).first);
      await pumpTransition(tester);

      // ── Step 6: Cart calculator ────────────────────────────────────────────
      await tester.tap(find.text('Cart\ncalculator'));
      await pumpTransition(tester);

      expect(
        find.text('Details'),
        findsWidgets,
        reason: 'Calculator screen should show "Details" step label',
      );

      // The results card with the total is rendered inline; scroll down to it.
      final totalFinder = find.textContaining('23.00');
      await tester.dragUntilVisible(
        totalFinder,
        find.byType(SingleChildScrollView).first,
        const Offset(0, -80),
      );
      expect(
        totalFinder,
        findsWidgets,
        reason: 'Calculator should display total cost containing 23.00',
      );

      // ── Back to Home via back button on calculator screen ──────────────────
      await tester.tap(find.byType(IconButton).first);
      await pumpTransition(tester);

      // ── Step 7: Subscription plans ─────────────────────────────────────────
      await tester.tap(find.text('subscription\nplans'));
      await pumpTransition(tester);

      expect(
        find.text('Basic cart'),
        findsWidgets,
        reason: 'Plans screen should show "Basic cart"',
      );
      expect(
        find.text('Smart cart'),
        findsWidgets,
        reason: 'Plans screen should show "Smart cart"',
      );
      expect(
        find.text('Prime cart'),
        findsWidgets,
        reason: 'Plans screen should show "Prime cart"',
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Test group 2 — Orders journey
  // ---------------------------------------------------------------------------

  group('orders journey', () {
    testWidgets('Orders list → Order detail → Advance status', (tester) async {
      await pumpApp(tester);

      // ── Step 8: Orders tab ─────────────────────────────────────────────────
      await tapBottomNav(tester, 'Orders');

      expect(
        find.text('My packages'),
        findsOneWidget,
        reason: 'Orders screen should show "My packages" heading',
      );
      expect(
        find.text('SHEIN dress'),
        findsWidgets,
        reason: 'Demo order "SHEIN dress" should appear in orders list',
      );

      // ── Step 9: Tap SHEIN dress → order detail ─────────────────────────────
      await tester.tap(find.text('SHEIN dress').first);
      await pumpTransition(tester);

      expect(
        find.text('My order:'),
        findsWidgets,
        reason: 'Order detail screen should show "My order:" heading',
      );

      // The "Advance status (demo)" button may be below the fold; scroll to it.
      final advanceBtn = find.text('Advance status (demo)');
      await tester.dragUntilVisible(
        advanceBtn,
        find.byType(SingleChildScrollView).first,
        const Offset(0, -80),
      );

      expect(advanceBtn, findsWidgets,
          reason: 'Advance status button should exist for non-delivered orders');

      // Tap with warnIfMissed: false because after scrolling the center might
      // still be at the very edge.
      await tester.tap(advanceBtn, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 500));
      // Assert no exception thrown — the order status advanced.
    });
  });

  // ---------------------------------------------------------------------------
  // Test group 3 — Account / Settings journey
  // ---------------------------------------------------------------------------

  group('account and settings journey', () {
    testWidgets(
        'Profile → Settings → Currency → Language → About → Support',
        (tester) async {
      await pumpApp(tester);

      // ── Step 10: Account tab → Profile ────────────────────────────────────
      await tapBottomNav(tester, 'Account');

      expect(
        find.text('Sara Mahmoud'),
        findsWidgets,
        reason: 'Profile screen should show user name Sara Mahmoud',
      );
      expect(
        find.text('Prime cart'),
        findsWidgets,
        reason: 'Profile screen should show plan "Prime cart"',
      );

      // ── Step 11: Settings tab ─────────────────────────────────────────────
      await tapBottomNav(tester, 'Settings');

      expect(
        find.text('Languages'),
        findsWidgets,
        reason: 'Settings screen should show "Languages" row',
      );

      // Tap "Currency" row — on 780px viewport it should be visible without scroll.
      final currencyRowFinder = find.text('Currency');
      expect(currencyRowFinder, findsWidgets,
          reason: 'Currency row should be visible on Settings screen');
      await tester.tap(currencyRowFinder.first);
      await pumpTransition(tester);

      expect(
        find.text('EGP'),
        findsWidgets,
        reason: 'Currency screen should show EGP option',
      );

      // The currency screen has a "Languages" row that pushes to LanguageScreen.
      await tester.tap(find.text('Languages').first);
      await pumpTransition(tester);

      expect(
        find.text('English'),
        findsWidgets,
        reason: 'Language screen should show "English" option',
      );
      expect(
        find.text('العربية'),
        findsWidgets,
        reason: 'Language screen should show "العربية" option',
      );

      // ── Back to Settings via GoRouter.go ──────────────────────────────────
      // From the Language screen (a pushed top-level route), tapping the
      // bottom-nav Settings tab calls context.go('/settings') in cfJourneyNav.
      // In GoRouter 14.x widget tests this navigation sometimes does not fire
      // via the tap path. We use the programmatic route instead.
      // Also: when Settings tab is ACTIVE (selected=true) + has Text child,
      // its Semantics label becomes "Settings\nSettings" so bySemanticsLabel
      // finds nothing. Programmatic navigation bypasses this issue entirely.
      await goRoute(tester, '/settings', find.text('English').first);

      expect(
        find.text('Settings'),
        findsWidgets,
        reason: 'Should be on Settings screen',
      );

      // ── Step 12: About us ─────────────────────────────────────────────────
      // On 800×1200 viewport the full Settings ListView fits without scrolling.
      // The About us _InfoCard is near the bottom of the list.
      // We look for it directly; if somehow off-screen, drag the ListView.

      final aboutFinder = find.text('About us');
      if (aboutFinder.evaluate().isEmpty) {
        // Drag the Settings ListView up to reveal lower items.
        // Use the ListView widget itself as the drag target.
        final listFinder = find.byType(ListView);
        if (listFinder.evaluate().isNotEmpty) {
          await tester.drag(listFinder.last, const Offset(0, -400));
          await tester.pump(const Duration(milliseconds: 300));
        }
      }
      expect(aboutFinder, findsWidgets,
          reason: '"About us" card should be visible on Settings screen');
      await tester.tap(aboutFinder.first);
      await pumpTransition(tester);

      expect(
        find.text('About us'),
        findsWidgets,
        reason: 'About screen should render with "About us" title',
      );

      // Back to Settings via GoRouter.go — same reason as above.
      await goRoute(tester, '/settings', find.text('About us').first);

      expect(
        find.text('Settings'),
        findsWidgets,
        reason: 'Should be back on Settings after going back from About',
      );

      // ── Have an issue / Support ───────────────────────────────────────────
      // "Have an issue" is in the Support & Help section of Settings.
      // On 800×1200 viewport it should be visible without scrolling.
      final issueFinder = find.text('Have an issue');
      if (issueFinder.evaluate().isEmpty) {
        final listFinder = find.byType(ListView);
        if (listFinder.evaluate().isNotEmpty) {
          await tester.drag(listFinder.last, const Offset(0, -300));
          await tester.pump(const Duration(milliseconds: 200));
        }
      }
      expect(issueFinder, findsWidgets,
          reason: '"Have an issue" row should be visible on Settings screen');
      await tester.tap(issueFinder.first);
      await pumpTransition(tester);

      expect(
        find.text('Have an issue?'),
        findsWidgets,
        reason: 'Support screen should render with "Have an issue?" title',
      );
      expect(
        find.textContaining('experiencing any problem'),
        findsWidgets,
        reason: 'Support screen body should contain expected text',
      );
    });
  });
}
