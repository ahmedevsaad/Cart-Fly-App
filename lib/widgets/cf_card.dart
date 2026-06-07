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
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
