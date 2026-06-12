import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/plans.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../state/plan_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import '../../widgets/icons/cf_icons.dart';

class PlanDetailScreen extends StatelessWidget {
  const PlanDetailScreen({super.key, required this.code});
  final String code;

  String planName(AppLocalizations l10n, String c) => switch (c) {
        'basic' => l10n.planBasicName,
        'smart' => l10n.planSmartName,
        'prime' => l10n.planPrimeName,
        _ => c,
      };

  String planDesc(AppLocalizations l10n, String c) => switch (c) {
        'basic' => l10n.planBasicDesc,
        'smart' => l10n.planSmartDesc,
        'prime' => l10n.planPrimeDesc,
        _ => '',
      };

  String? planFeatures(AppLocalizations l10n, String c) => switch (c) {
        'smart' => l10n.planSmartFeatures,
        'prime' => l10n.planPrimeFeatures,
        _ => null,
      };

  String planPrice(AppLocalizations l10n, String c) => switch (c) {
        'basic' => l10n.planBasicPrice,
        'smart' => l10n.planSmartPrice,
        'prime' => l10n.planPrimePrice,
        _ => '',
      };

  bool isFree(String c) => c == 'basic';

  Color priceColor(String c) =>
      isFree(c) ? AppColors.planFree : AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final allCodes = plans.map((p) => p.code).toList();
    final collapsedCodes = allCodes.where((c) => c != code).toList();

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Page title
            Text(
              l10n.ourPlans,
              style: AppText.heading.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),

            // Active plan title chip
            Container(
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppColors.shadowSoft,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Text(
                planName(l10n, code),
                style: AppText.heading.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),

            // Expanded detail card
            Container(
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius: BorderRadius.circular(AppColors.radiusCard),
                boxShadow: AppColors.shadowSoft,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Description
                  Text(
                    planDesc(l10n, code),
                    style: AppText.body.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.5,
                      height: 1.5,
                      color: AppColors.text,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Features (smart & prime only)
                  if (planFeatures(l10n, code) != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      planFeatures(l10n, code)!,
                      style: AppText.body.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.5,
                        height: 1.9,
                        color: AppColors.text,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  // Subscribe button
                  const SizedBox(height: 16),
                  if (!isFree(code))
                    OutlinedButton(
                      onPressed: () => context
                          .push('${Routes.payment}?for=plan_$code'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppColors.text, width: 1.5),
                        shape: const StadiumBorder(),
                        padding:
                            const EdgeInsets.symmetric(vertical: 13),
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.text,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.subscribeNow,
                            style: AppText.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(width: 12),
                          CfIcons.arrowRight(
                            size: 22,
                            color: AppColors.text,
                          ),
                        ],
                      ),
                    )
                  else
                    OutlinedButton(
                      onPressed: () async {
                        await context
                            .read<PlanProvider>()
                            .subscribe('basic');
                        if (context.mounted) {
                          context.go(Routes.paymentSuccess);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppColors.text, width: 1.5),
                        shape: const StadiumBorder(),
                        padding:
                            const EdgeInsets.symmetric(vertical: 13),
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.text,
                      ),
                      child: Text(
                        l10n.subscribeNow,
                        style: AppText.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  // Price — shown after features & subscribe button
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      planPrice(l10n, code),
                      style: AppText.heading.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: priceColor(code),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Collapsed other plans
            if (collapsedCodes.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.fieldBg,
                  borderRadius:
                      BorderRadius.circular(AppColors.radiusCard),
                  boxShadow: AppColors.shadowSoft,
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    for (int i = 0; i < collapsedCodes.length; i++) ...[
                      if (i != 0)
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16),
                          color: AppColors.cardBorder,
                        ),
                      InkWell(
                        onTap: () => context.pushReplacement(
                          Routes.planDetail.replaceFirst(
                              ':code', collapsedCodes[i]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 18),
                          child: Text(
                            planName(l10n, collapsedCodes[i]),
                            style: AppText.heading.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppColors.text,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
