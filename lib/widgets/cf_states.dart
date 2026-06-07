import 'package:flutter/material.dart';
import '../theme/app_text.dart';

class CfLoading extends StatelessWidget {
  const CfLoading({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class CfEmptyState extends StatelessWidget {
  const CfEmptyState({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) =>
      Center(child: Text(message, style: AppText.caption, textAlign: TextAlign.center));
}

class CfErrorState extends StatelessWidget {
  const CfErrorState({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(message, style: AppText.body, textAlign: TextAlign.center),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ]),
      );
}
