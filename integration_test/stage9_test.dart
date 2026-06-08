import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_bottom_nav.dart';
import 'package:cartfly/widgets/cf_button.dart';
import 'package:cartfly/widgets/cf_status_timeline.dart';

import 'test_helpers.dart';

/// Pump discrete frames while also yielding real time so Firebase auth
/// state Promises (JS) can resolve between Flutter frame pumps.
Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  int maxSeconds = 15,
}) async {
  for (int i = 0; i < maxSeconds * 2; i++) {
    await tester.pump(const Duration(milliseconds: 500));
    if (condition()) return;
  }
}

/// Like pumpUntil but uses runAsync for each wait to let JS Promises fire.
/// Use this for auth-driven navigation (register→verify, login→home).
Future<void> pumpUntilAsync(
  WidgetTester tester,
  bool Function() condition, {
  int maxSeconds = 15,
}) async {
  for (int i = 0; i < maxSeconds; i++) {
    // Yield real time so JS Promises / Firebase stream events can fire.
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 800)));
    // Pump 1 second of frames so page transitions and state rebuilds complete.
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));
    if (condition()) return;
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initTestFirebase);
  tearDownAll(clearEmulatorData);

  testWidgets('acceptance: login as verified user reaches /home', (tester) async {
    // Create a verified user (same helper used by all other tests).
    await createVerifiedUser(
      email: 'accept9@cartfly.test',
      password: 'Accept123!',
    );
    // Sign in (user is verified) → AuthProvider.authenticated → router → /home.
    await signInUser('accept9@cartfly.test', 'Accept123!');

    await tester.pumpWidget(const CartFlyApp());
    await pumpUntilAsync(
      tester,
      () => find.byType(CfBottomNav).evaluate().isNotEmpty,
      maxSeconds: 12,
    );
    expect(find.byType(CfBottomNav), findsOneWidget);
  });

  testWidgets('acceptance: create shipment persists + tracks', (tester) async {
    await createVerifiedUser(email: 'shiptest@cartfly.test', password: 'TestPass123!');
    await signInUser('shiptest@cartfly.test', 'TestPass123!');

    await tester.pumpWidget(const CartFlyApp());
    await pumpUntil(
      tester,
      () => find.widgetWithText(CfButton, 'Create shipment').evaluate().isNotEmpty,
    );

    await tester.tap(find.widgetWithText(CfButton, 'Create shipment'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.enterText(find.byType(TextField).first, 'Final Acceptance Item');
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CfButton, 'Create'));
    await pumpUntil(
      tester,
      () => find.byType(CfStatusTimeline).evaluate().isNotEmpty,
      maxSeconds: 10,
    );

    // Track screen shows timeline
    expect(find.byType(CfStatusTimeline), findsOneWidget);

    // Advance status and verify in Firestore
    await tester.tap(find.widgetWithText(CfButton, 'Advance status'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final orders = await FirebaseFirestore.instance
        .collection('users').doc(uid).collection('orders').get();
    expect(orders.docs.first.data()['status'], 'atWarehouse');
  });

  testWidgets('acceptance: subscribe to plan sets Firestore field', (tester) async {
    await createVerifiedUser(email: 'plantest@cartfly.test', password: 'TestPass123!');
    await signInUser('plantest@cartfly.test', 'TestPass123!');

    await tester.pumpWidget(const CartFlyApp());
    await pumpUntil(
      tester,
      () => find.text('Subscription plans').evaluate().isNotEmpty,
    );

    await tester.tap(find.text('Subscription plans'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await tester.tap(find.text('Prime cart'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.widgetWithText(CfButton, 'Subscribe now'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.enterText(find.byType(TextField).at(0), 'Test Holder');
    await tester.enterText(find.byType(TextField).at(1), '4111111111111111');
    await tester.enterText(find.byType(TextField).at(2), '123');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CfButton, 'Confirm'));
    await pumpUntil(
      tester,
      () => find.text('Payment Successful').evaluate().isNotEmpty,
      maxSeconds: 10,
    );

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    expect(doc.data()!['plan'], 'prime');
  });

  testWidgets('acceptance: sign-out and login returns to /home', (tester) async {
    await createVerifiedUser(email: 'signout@cartfly.test', password: 'TestPass123!');
    await signInUser('signout@cartfly.test', 'TestPass123!');

    await tester.pumpWidget(const CartFlyApp());
    await pumpUntil(
      tester,
      () => find.byType(CfBottomNav).evaluate().isNotEmpty,
    );

    // Navigate to Settings tab
    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Scroll down to make Sign out visible if needed
    await tester.scrollUntilVisible(
      find.widgetWithText(CfButton, 'Sign out'),
      200,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CfButton, 'Sign out'));
    await pumpUntil(
      tester,
      () => find.widgetWithText(CfButton, 'Login').evaluate().isNotEmpty,
      maxSeconds: 10,
    );

    expect(find.widgetWithText(CfButton, 'Login'), findsOneWidget);

    // Log back in
    await tester.enterText(find.byType(TextField).at(0), 'signout@cartfly.test');
    await tester.enterText(find.byType(TextField).at(1), 'TestPass123!');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CfButton, 'Login'));
    await pumpUntil(
      tester,
      () => find.byType(CfBottomNav).evaluate().isNotEmpty,
      maxSeconds: 12,
    );

    expect(find.byType(CfBottomNav), findsOneWidget);
  });

  testWidgets('acceptance: language switch produces RTL layout', (tester) async {
    await createVerifiedUser(email: 'rtl@cartfly.test', password: 'TestPass123!');
    await signInUser('rtl@cartfly.test', 'TestPass123!');

    await tester.pumpWidget(const CartFlyApp());
    await pumpUntil(
      tester,
      () => find.byType(CfBottomNav).evaluate().isNotEmpty,
    );

    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text('Languages'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text('العربية'));
    await pumpUntil(
      tester,
      () {
        final dirs = tester.widgetList<Directionality>(find.byType(Directionality));
        return dirs.isNotEmpty && dirs.first.textDirection == TextDirection.rtl;
      },
      maxSeconds: 5,
    );

    final dir = tester.widget<Directionality>(find.byType(Directionality).first);
    expect(dir.textDirection, TextDirection.rtl);
  });
}
