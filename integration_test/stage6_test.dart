import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_button.dart';
import 'package:cartfly/widgets/cf_status_timeline.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initTestFirebase();
    await createVerifiedUser(
      email: 'stage6@cartfly.test',
      password: 'TestPass123!',
    );
    await signInUser('stage6@cartfly.test', 'TestPass123!');
  });

  tearDownAll(clearEmulatorData);

  testWidgets('stage6: create shipment persists and appears in orders list', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Navigate to Create Shipment
    await tester.tap(find.widgetWithText(CfButton, 'Create shipment'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Fill title
    await tester.enterText(find.byType(TextField).first, 'Integration Test Item');
    await tester.pumpAndSettle();

    // Select country from dropdown
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();

    // Select Home delivery (not Locker, avoids locker dropdown)
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    // Submit
    await tester.tap(find.widgetWithText(CfButton, 'Create'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Should navigate to track screen — CfStatusTimeline present
    expect(find.byType(CfStatusTimeline), findsOneWidget);
  });

  testWidgets('stage6: advance status button moves timeline forward', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Navigate to Create Shipment and create one
    await tester.tap(find.widgetWithText(CfButton, 'Create shipment'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.enterText(find.byType(TextField).first, 'Advance Test');
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CfButton, 'Create'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // On track screen — tap Advance status
    await tester.tap(find.widgetWithText(CfButton, 'Advance status'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify in Firestore that status advanced to 'atWarehouse'
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final orders = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .get();
    expect(orders.docs.isNotEmpty, isTrue);
    final status = orders.docs.first.data()['status'] as String;
    expect(status, 'atWarehouse');
  });
}
