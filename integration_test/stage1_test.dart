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

    // Pump repeatedly to allow Firebase auth to resolve and router to redirect.
    // Each cycle: pump 500ms to process events, then check if auth resolved.
    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (find.text('from cart to doorstep').evaluate().isNotEmpty) break;
    }
    await tester.pumpAndSettle();

    // CartFly brand text present
    expect(find.textContaining('CartFly'), findsWidgets);

    // A Scaffold is rendered
    expect(find.byType(Scaffold), findsWidgets);

    // "from cart to doorstep" is on either splash or login screen
    expect(find.text('from cart to doorstep'), findsOneWidget);

    // Scaffold background colour matches bgSplash token
    final allScaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
    final hasCorrectBg =
        allScaffolds.any((s) => s.backgroundColor == AppColors.bgSplash);
    expect(hasCorrectBg, isTrue);

    // No uncaught exceptions
    expect(tester.takeException(), isNull);
  });
}
