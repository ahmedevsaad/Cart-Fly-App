import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cartfly/widgets/cf_input.dart';

void main() {
  testWidgets('CfInput shows label and accepts text', (tester) async {
    final c = TextEditingController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: CfInput(label: 'Email:', controller: c)),
    ));
    expect(find.text('Email:'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'a@b.com');
    expect(c.text, 'a@b.com');
  });
}
