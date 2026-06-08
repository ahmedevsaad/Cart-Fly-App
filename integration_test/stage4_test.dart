import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_bottom_nav.dart';
import 'package:cartfly/widgets/cf_button.dart';

import 'test_helpers.dart';

// Pump until login form is on screen (caption + TextField present).
Future<void> waitForLoginForm(WidgetTester tester) async {
  for (int i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 500));
    final hasCaption =
        find.text('from cart to doorstep').evaluate().isNotEmpty;
    final hasField = find.byType(TextField).evaluate().isNotEmpty;
    if (hasCaption && hasField) break;
  }
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initTestFirebase();
    await createVerifiedUser(
      email: 'stage4@cartfly.test',
      password: 'TestPass123!',
    );
  });

  tearDownAll(clearEmulatorData);

  // All stage-4 checks run in one testWidgets to avoid the auth-resubscription issue.
  testWidgets('stage4: full auth flow — unauthenticated → login → home', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await waitForLoginForm(tester);

    // 1. Login screen visible
    expect(find.text('from cart to doorstep'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);

    // 2. Enter credentials and log in
    await tester.enterText(find.byType(TextField).at(0), 'stage4@cartfly.test');
    await tester.enterText(find.byType(TextField).at(1), 'TestPass123!');
    await tester.pumpAndSettle();

    // Scroll to reveal the Login CfButton then tap
    await tester.drag(find.byType(ListView).first, const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CfButton, 'Login'));

    // Wait for login + profile load + redirect to /home
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (find.byType(CfBottomNav).evaluate().isNotEmpty) break;
    }
    await tester.pumpAndSettle();

    // 3. Home reached → CfBottomNav visible
    expect(find.byType(CfBottomNav), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stage4: register button navigates to register screen', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await waitForLoginForm(tester);

    // Scroll to reveal register button then tap
    await tester.drag(find.byType(ListView).first, const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CfOutlineButton, "Don't have an account"));
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 300));
      if (find.text('Full name:').evaluate().isNotEmpty) break;
    }
    await tester.pumpAndSettle();
    expect(find.text('Full name:'), findsOneWidget);
  });
}
