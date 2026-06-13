import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/plans.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_journey_nav.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      bottomNav: cfJourneyNav(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.ourPlans,
              style: AppText.heading.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            // Accordion-style card with dividers
            Container(
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius: BorderRadius.circular(AppColors.radiusCard),
                boxShadow: AppColors.shadowSoft,
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  for (int i = 0; i < plans.length; i++) ...[
                    if (i != 0)
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: AppColors.cardBorder,
                      ),
                    _PlanRow(plan: plans[i]),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.tapPlanHint,
              style: AppText.caption.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedDisabled,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({required this.plan});
  final Plan plan;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: plan.name,
      child: InkWell(
        onTap: () => context.push(
          Routes.planDetail.replaceFirst(':code', plan.code),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          child: Text(
            plan.name,
            style: AppText.heading.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
