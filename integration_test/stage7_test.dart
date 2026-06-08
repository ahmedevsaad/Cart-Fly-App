import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_button.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initTestFirebase();
    await createVerifiedUser(
      email: 'stage7@cartfly.test',
      password: 'TestPass123!',
    );
    await signInUser('stage7@cartfly.test', 'TestPass123!');
  });

  tearDownAll(clearEmulatorData);

  testWidgets('stage7: plans screen lists Basic, Smart, Prime', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text('Subscription plans'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Basic cart'), findsOneWidget);
    expect(find.text('Smart cart'), findsOneWidget);
    expect(find.text('Prime cart'), findsOneWidget);
  });

  testWidgets('stage7: subscribe to Prime sets plan in Firestore', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Navigate to Plans
    await tester.tap(find.text('Subscription plans'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Tap Prime
    await tester.tap(find.text('Prime cart'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Subscribe now
    await tester.tap(find.widgetWithText(CfButton, 'Subscribe now'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Fill card form (valid inputs — all non-empty, card ≥12 digits)
    await tester.enterText(find.byType(TextField).at(0), 'Test Holder');
    await tester.enterText(find.byType(TextField).at(1), '4111111111111111');
    await tester.enterText(find.byType(TextField).at(2), '123');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CfButton, 'Confirm'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Success screen
    expect(find.text('Payment Successful'), findsOneWidget);

    // Verify Firestore users/{uid}.plan == 'prime'
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    expect(doc.data()!['plan'], 'prime');
  });

  testWidgets('stage7: invalid card → payment error screen', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text('Subscription plans'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    await tester.tap(find.text('Smart cart'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.widgetWithText(CfButton, 'Subscribe now'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Leave all fields empty → should fail validation
    await tester.tap(find.widgetWithText(CfButton, 'Confirm'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Payment Error'), findsOneWidget);

    // "Try again" returns to card form
    await tester.tap(find.widgetWithText(CfButton, 'Try again'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.widgetWithText(CfButton, 'Confirm'), findsOneWidget);
  });
}
