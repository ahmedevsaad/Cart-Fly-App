import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../theme/colors.dart';
import '../../widgets/app_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bgBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const AppLogo(size: 72),
              const SizedBox(height: 8),
              Text(
                t.tagline,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.muted),
              ),
              const Spacer(flex: 5),
              ElevatedButton(
                onPressed: () => context.go(Routes.login),
                child: Text(t.login),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go(Routes.register),
                child: Text(t.dontHaveAccount),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
