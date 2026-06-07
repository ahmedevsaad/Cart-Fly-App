import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/theme/app_colors.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initTestFirebase);
  tearDownAll(clearEmulatorData);

  testWidgets('stage1: smoke screen renders design tokens', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Display text present
    expect(find.text('CartFly'), findsOneWidget);
    // Caption present
    expect(find.text('from cart to doorstep'), findsOneWidget);
    // Login ElevatedButton rendered
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    // Scaffold background colour matches bgSplash token
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.backgroundColor, AppColors.bgSplash);
    // No uncaught exceptions
    expect(tester.takeException(), isNull);
  });
}
