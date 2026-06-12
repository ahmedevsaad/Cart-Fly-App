import 'package:cartfly/widgets/icons/cf_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CfIcons render without error', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Wrap(children: [
          CfIcons.home(),
          CfIcons.account(),
          CfIcons.orders(),
          CfIcons.settings(),
          CfIcons.warehouses(),
          CfIcons.lockers(),
          CfIcons.plans(),
          CfIcons.cartCalculator(),
          CfIcons.stepBag(),
          CfIcons.stepBox(),
          CfIcons.stepTruck(),
          CfIcons.stepCheck(),
          CfIcons.barcode(),
          CfIcons.copy(),
          CfIcons.chevronRight(),
          CfIcons.signOut(),
        ]),
      ),
    ));
    expect(find.byType(SvgPicture), findsWidgets);
  });

  testWidgets('CfIcons accept custom size and color', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Wrap(children: [
          CfIcons.home(size: 32, color: const Color(0xFF2563EB)),
          CfIcons.pin(size: 18, color: Colors.red),
          CfIcons.star(size: 16, color: Colors.amber),
          CfIcons.bell(size: 24, color: Colors.black),
          CfIcons.plus(size: 20, color: Colors.green),
          CfIcons.globe(size: 22, color: Colors.teal),
          CfIcons.chevronLeft(),
          CfIcons.chevronUp(),
          CfIcons.chevronDown(),
          CfIcons.card(),
          CfIcons.paypal(),
          CfIcons.apple(),
          CfIcons.eye(),
          CfIcons.lock(),
          CfIcons.arrowRight(),
          CfIcons.homeBuilding(),
        ]),
      ),
    ));
    expect(find.byType(SvgPicture), findsWidgets);
  });
}
