import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'CartFly',
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: size,
            color: AppColors.primary,
            fontStyle: FontStyle.italic,
          ),
    );
  }
}
