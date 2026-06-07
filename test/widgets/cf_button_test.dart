import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cartfly/widgets/cf_button.dart';

void main() {
  testWidgets('CfButton shows label and fires onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CfButton(label: 'Login', onPressed: () => tapped = true),
      ),
    ));
    expect(find.text('Login'), findsOneWidget);
    await tester.tap(find.text('Login'));
    expect(tapped, isTrue);
  });
}
