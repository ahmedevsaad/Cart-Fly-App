import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Full-screen loading indicator.
class CfLoading extends StatelessWidget {
  const CfLoading({super.key});
  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2.5,
        ),
      );
}

/// Full-screen empty-state message.
class CfEmptyState extends StatelessWidget {
  const CfEmptyState({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          message,
          style: AppText.caption,
          textAlign: TextAlign.center,
        ),
      );
}

/// Full-screen error state with optional retry action.
class CfErrorState extends StatelessWidget {
  const CfErrorState({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: AppText.body, textAlign: TextAlign.center),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(AppLocalizations.of(context)!.retry),
              ),
          ],
        ),
      );
}
