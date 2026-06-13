import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import '../../widgets/icons/cf_icons.dart';

class PaymentErrorScreen extends StatelessWidget {
  const PaymentErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return CfScaffold(
      topBar: const CfTopBar(showBack: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CfIcons.lock(size: 38, color: AppColors.danger),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              l.paymentErrorTitle,
              style: AppText.title.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Body
            Text(
              l.paymentErrorBody,
              style: AppText.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.muted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),

            // Try again — pops back to payment (or goes home if deep-linked)
            CfButton(
              label: l.tryAgain,
              onPressed: () => context.canPop() ? context.pop() : context.go(Routes.home),
            ),
            const SizedBox(height: 14),

            // Back to home — text link
            Semantics(
              button: true,
              label: l.backToHome,
              child: GestureDetector(
                onTap: () => context.go(Routes.home),
                child: Center(
                  child: Text(
                    l.backToHome,
                    style: AppText.caption.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
