import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cartfly/app.dart';
import 'package:cartfly/widgets/cf_bottom_nav.dart';
import 'package:cartfly/widgets/cf_flag_card.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initTestFirebase();
    await createVerifiedUser(
      email: 'stage5@cartfly.test',
      password: 'TestPass123!',
    );
    await signInUser('stage5@cartfly.test', 'TestPass123!');
  });

  tearDownAll(clearEmulatorData);

  testWidgets('stage5: home screen shows warehouse and locker rows', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(CfBottomNav), findsOneWidget);
    expect(find.text('Our warehouses'), findsOneWidget);
    expect(find.text('Locker locations'), findsOneWidget);
  });

  testWidgets('stage5: tapping warehouses row loads flag-card grid', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text('Our warehouses'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Warehouses screen shows at least 5 CfFlagCards (one per country)
    expect(find.byType(CfFlagCard), findsNWidgets(5));
  });

  testWidgets('stage5: tapping a flag card loads warehouse detail', (tester) async {
    await tester.pumpWidget(const CartFlyApp());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.tap(find.text('Our warehouses'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.byType(CfFlagCard).first);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Detail screen contains 'Best for:' label
    expect(find.textContaining('Best for'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
