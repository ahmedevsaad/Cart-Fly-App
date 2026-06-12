import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CfCard extends StatelessWidget {
  const CfCard({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppColors.shadowSoft,
      ),
      child: child,
    );
  }
}
