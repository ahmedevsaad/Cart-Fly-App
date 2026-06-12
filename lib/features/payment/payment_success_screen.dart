import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_dashed.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

/// Payment success — dual-mode:
///
/// * When [planName] is provided (plan checkout, Frame 21):
///   Shows the full plan-confirmed receipt layout.
///
/// * When [planName] is null (order payment, existing callers):
///   Shows the simple "Payment Successful / Done" layout.
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key, this.planName});

  /// Localised plan name, e.g. "Prime cart". Null → order-mode layout.
  final String? planName;

  @override
  Widget build(BuildContext context) {
    return planName != null
        ? _buildPlanMode(context, planName!)
        : _buildOrderMode(context);
  }

  // ── Plan confirmed (Frame 21) ───────────────────────────────────────────────

  Widget _buildPlanMode(BuildContext context, String plan) {
    final l10n = AppLocalizations.of(context)!;

    return CfScaffold(
      topBar: const CfTopBar(showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Green check circle
            const SizedBox(height: 46),
            Center(
              child: Container(
                width: 104,
                height: 104,
                decoration: const BoxDecoration(
                  color: AppColors.deliveryBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: AppColors.planFree,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.planFree
                              .withValues(alpha: 0.34),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Thank you heading
            Text(
              l10n.planConfirmedThankYou,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 27,
                letterSpacing: -0.54,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.planConfirmedBody(plan),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                height: 1.55,
                color: AppColors.muted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 26),

            // Receipt card
            Container(
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius:
                    BorderRadius.circular(AppColors.radiusCard),
                boxShadow: AppColors.shadowSoft,
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _ReceiptRow(
                    label: l10n.receiptPlan,
                    value: l10n.checkoutPlanName,
                    dashedBottom: true,
                    paddingTop: 0,
                  ),
                  _ReceiptRow(
                    label: l10n.receiptBilling,
                    value: l10n.receiptBillingMonthly,
                    dashedBottom: true,
                    paddingTop: 11,
                  ),
                  _ReceiptRow(
                    label: l10n.receiptNextRenewal,
                    value: l10n.receiptRenewalDate,
                    dashedBottom: true,
                    paddingTop: 11,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.receiptAmountPaid,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          l10n.receiptAmountVal,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: AppColors.planFree,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Back to home button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go(Routes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                ),
                icon: const Icon(Icons.home_outlined,
                    size: 19, color: Colors.white),
                label: Text(
                  l10n.backToHome,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),

            // View subscription text button
            TextButton(
              onPressed: () => context.go(Routes.plans),
              child: Text(
                l10n.viewSubscription,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.planPrime,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Simple order-mode success (keeps existing callers working) ──────────────

  Widget _buildOrderMode(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CfScaffold(
      topBar: const CfTopBar(showBack: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 80, color: AppColors.success),
            const SizedBox(height: 24),
            Text(
              l10n.planConfirmedThankYou,
              style: AppText.heading.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go(Routes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppColors.radius),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  l10n.backToHome,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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

// ── Receipt Row ───────────────────────────────────────────────────────────────

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    required this.dashedBottom,
    required this.paddingTop,
  });

  final String label;
  final String value;
  final bool dashedBottom;
  final double paddingTop;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: paddingTop, bottom: dashedBottom ? 11 : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  color: AppColors.muted,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
        if (dashedBottom)
          CfDashedDivider(color: AppColors.radioIdle),
      ],
    );
  }
}
