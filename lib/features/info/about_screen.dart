import 'package:flutter/material.dart';

import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'About CartFly',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'CartFly is a cross-border shopping delivery platform that '
              'bridges the gap between international online stores and customers '
              'in the Middle East and beyond.\n\n'
              'Our mission is to make global shopping accessible, affordable, '
              'and effortless for everyone. We operate warehouses in the UAE, '
              'Saudi Arabia, Egypt, USA, and China, giving our members direct '
              'access to the world\'s best products.\n\n'
              'With CartFly, you can:\n'
              '• Shop from any international store\n'
              '• Ship to our warehouse address\n'
              '• Track your package in real time\n'
              '• Receive delivery at your doorstep\n\n'
              'We are committed to transparent pricing, fast shipping, and '
              'exceptional customer service.',
              style: TextStyle(fontSize: 15, height: 1.6),
            ),
            SizedBox(height: 24),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}
