import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_scaffold.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => CfScaffold(
        solidBackground: AppColors.bgSplash,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('CartFly', style: AppText.display),
              Text('from cart to doorstep', style: AppText.caption),
            ],
          ),
        ),
      );
}
