import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/widgets/cf_background.dart';
import 'package:cartfly/widgets/cf_button.dart';
import 'package:cartfly/widgets/cf_card.dart';
import 'package:cartfly/widgets/cf_input.dart';
import 'package:cartfly/widgets/cf_states.dart';
import 'package:cartfly/widgets/cf_status_timeline.dart';
import 'package:cartfly/theme/app_theme.dart';

import 'test_helpers.dart';

/// Minimal wrapper that does NOT need Firebase — tests the widget library only.
Widget _wrap(Widget child) => MaterialApp(
      theme: buildAppTheme(),
      home: Scaffold(body: child),
    );

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initTestFirebase);
  tearDownAll(clearEmulatorData);

  testWidgets('stage2: Cf* widget library renders without exception',
      (tester) async {
    bool tapped = false;
    final ctrl = TextEditingController();
    await tester.pumpWidget(_wrap(
      SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 80,
            child: CfBackground(child: const SizedBox.expand()),
          ),
          CfButton(label: 'Test', onPressed: () => tapped = true),
          CfOutlineButton(label: 'Outline', onPressed: () {}),
          CfInput(label: 'Email', controller: ctrl),
          const CfCard(child: Text('card content')),
          const CfStatusTimeline(steps: ['A', 'B', 'C'], activeIndex: 1),
          const CfEmptyState(message: 'Nothing here'),
          const CfErrorState(message: 'Error!'),
        ]),
      ),
    ));
    await tester.pumpAndSettle();

    // All Cf* widgets rendered
    expect(find.byType(CfButton), findsOneWidget);
    expect(find.byType(CfOutlineButton), findsOneWidget);
    expect(find.byType(CfCard), findsOneWidget);
    expect(find.byType(CfStatusTimeline), findsOneWidget);
    expect(find.byType(CfEmptyState), findsOneWidget);
    expect(find.byType(CfErrorState), findsOneWidget);

    // CfButton tap fires callback
    await tester.tap(find.byType(CfButton));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);

    expect(tester.takeException(), isNull);
  });
}
