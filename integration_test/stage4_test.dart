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
    // Pre-create a verified user so the login test doesn't depend on registration UI.
    await createVerifiedUser(
      email: 'stage4@cartfly.test',
      password: 'TestPass123!',
    );
  });

  tearDownAll(clearEmulatorData);

  testWidgets('stage4: unauthenticated start → login screen shown', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.widgetWithText(CfButton, 'Login'), findsOneWidget);
  });

  testWidgets('stage4: login with valid credentials reaches /home', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Enter email into first TextField
    await tester.enterText(find.byType(TextField).at(0), 'stage4@cartfly.test');
    // Enter password into second TextField
    await tester.enterText(find.byType(TextField).at(1), 'TestPass123!');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CfButton, 'Login'));
    await tester.pumpAndSettle(const Duration(seconds: 6));

    // Authenticated → router redirects to /home → CfBottomNav visible
    expect(find.byType(CfBottomNav), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stage4: tapping register button navigates to register screen', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.widgetWithText(CfOutlineButton, "Don't have an account"));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Register form has a "Full name:" label from CfInput
    expect(find.text('Full name:'), findsOneWidget);
  });

  testWidgets('stage4: register form submits → verify screen appears', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.widgetWithText(CfOutlineButton, "Don't have an account"));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Fill register form
    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(find.byType(TextField).at(1), '0501234567');
    await tester.enterText(find.byType(TextField).at(2), 'newuser4@cartfly.test');
    // Select country (first DropdownButton)
    await tester.tap(find.byType(DropdownButton<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
    // Select currency (second DropdownButton)
    await tester.tap(find.byType(DropdownButton<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownMenuItem<String>).first);
    await tester.pumpAndSettle();
    // Password fields
    await tester.enterText(find.byType(TextField).at(3), 'TestPass123!');
    await tester.enterText(find.byType(TextField).at(4), 'TestPass123!');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CfButton, 'Register'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // AuthProvider sets pendingOtp → router shows verify screen
    expect(find.widgetWithText(CfButton, 'I have verified'), findsOneWidget);
  });
}
