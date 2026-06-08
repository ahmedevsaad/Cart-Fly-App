import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(initTestFirebase);
  tearDownAll(clearEmulatorData);

  testWidgets('stage0: app launches and shows CartFly brand', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('CartFly'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
