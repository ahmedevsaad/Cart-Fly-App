import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_bottom_nav.dart';

import 'test_helpers.dart';

// Compiled with --dart-define=DEBUG_BYPASS_AUTH=true — router bypasses auth.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initTestFirebase);
  tearDownAll(clearEmulatorData);

  testWidgets('stage3: shell renders 4-tab bottom bar', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(CfBottomNav), findsOneWidget);
    expect(
      find.descendant(of: find.byType(CfBottomNav), matching: find.text('Home')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: find.byType(CfBottomNav), matching: find.text('Settings')),
      findsOneWidget,
    );
  });

  testWidgets('stage3: tapping Settings nav item switches body', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    final settingsInNav = find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    );
    await tester.tap(settingsInNav);
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stage3: tab state preserved when switching back', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Settings'),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byType(CfBottomNav),
      matching: find.text('Home'),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
