import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_button.dart';
import 'package:cartfly/widgets/cf_card.dart';
import 'package:cartfly/widgets/cf_input.dart';
import 'package:cartfly/widgets/cf_states.dart';
import 'package:cartfly/widgets/cf_status_timeline.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initTestFirebase);
  tearDownAll(clearEmulatorData);

  testWidgets('stage2: gallery renders all Cf* widgets', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(CfButton), findsWidgets);
    expect(find.byType(CfOutlineButton), findsWidgets);
    expect(find.byType(CfInput), findsWidgets);
    expect(find.byType(CfCard), findsWidgets);
    expect(find.byType(CfStatusTimeline), findsOneWidget);
    expect(find.byType(CfEmptyState), findsOneWidget);
    expect(find.byType(CfErrorState), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stage2: CfButton tap fires without exception', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.byType(CfButton).first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
