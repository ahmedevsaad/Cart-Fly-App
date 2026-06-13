import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_scaffold.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CfScaffold(
      solidBackground: AppColors.bgSplash,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Brand name is constant across all languages — never localized.
            Text('CartFly', style: AppText.display),
            Text(l10n.tagline, style: AppText.caption),
          ],
        ),
      ),
    );
  }
}
