import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      solidBackground: AppColors.bgSplash,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text('CartFly', style: AppText.display)),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'from cart to doorstep',
                style: AppText.caption,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
            Center(
              child: Text(
                'Welcome aboard!',
                style: AppText.title,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Your account is ready. Start shipping with CartFly today.',
                style: AppText.body,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
            CfButton(
              label: 'Tap to create shipment',
              onPressed: () => context.go(Routes.home),
            ),
          ],
        ),
      ),
    );
  }
}
