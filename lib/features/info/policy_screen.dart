import 'package:flutter/material.dart';

import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

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
              'Privacy Policy',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: January 2025\n\n'
              '1. Information We Collect\n'
              'We collect information you provide directly to us, such as your '
              'name, email address, phone number, and shipping addresses when '
              'you create an account or place an order.\n\n'
              '2. How We Use Your Information\n'
              'We use the information we collect to process your orders, '
              'communicate with you about your shipments, and improve our '
              'services.\n\n'
              '3. Information Sharing\n'
              'We do not sell or share your personal information with third '
              'parties except as necessary to fulfill your orders or as '
              'required by law.\n\n'
              '4. Data Security\n'
              'We implement industry-standard security measures to protect '
              'your personal information against unauthorized access or '
              'disclosure.\n\n'
              '5. Your Rights\n'
              'You have the right to access, update, or delete your personal '
              'information at any time by contacting our support team.\n\n'
              '6. Contact Us\n'
              'If you have any questions about this Privacy Policy, please '
              'contact us at privacy@cartfly.com.',
              style: TextStyle(fontSize: 15, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
