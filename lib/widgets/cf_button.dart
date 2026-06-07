import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class CfButton extends StatelessWidget {
  const CfButton({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}

class CfOutlineButton extends StatelessWidget {
  const CfOutlineButton({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.btnAlt,
          foregroundColor: Colors.white,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppColors.radius)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label, style: AppText.bodyMedium.copyWith(color: Colors.white)),
      ),
    );
  }
}
