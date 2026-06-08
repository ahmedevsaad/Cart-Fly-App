import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_bottom_nav.dart';
import 'package:cartfly/widgets/cf_button.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initTestFirebase();
    await createVerifiedUser(
      email: 'stage8@cartfly.test',
      password: 'TestPass123!',
    );
    await signInUser('stage8@cartfly.test', 'TestPass123!');
  });

  tearDownAll(clearEmulatorData);

  testWidgets('stage8: sign-out redirects to login screen', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Navigate to Settings tab
    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Scroll the Sign out button into view (it may be below the fold)
    await tester.scrollUntilVisible(
      find.widgetWithText(CfButton, 'Sign out'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // Tap Sign out button
    await tester.tap(find.widgetWithText(CfButton, 'Sign out'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Should be on login screen
    expect(find.widgetWithText(CfButton, 'Login'), findsOneWidget);
  });

  testWidgets('stage8: language switch changes app locale to Arabic', (tester) async {
    // Sign back in after previous test signed out
    await signInUser('stage8@cartfly.test', 'TestPass123!');

    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Navigate to Settings tab
    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Languages
    await tester.tap(find.text('Languages'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Arabic option
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Locale should be ar — text directionality is RTL
    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
  });
}
