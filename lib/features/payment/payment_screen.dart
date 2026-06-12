import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../state/plan_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_dashed.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import '../../widgets/icons/cf_icons.dart';

/// Payment screen — dual-mode:
///
/// * **Plan mode** (`forItem` starts with `"plan_"`):
///   Renders the Frame-20 plan-checkout layout (Prime cart summary,
///   payment-method picker, card fields, "Pay \$19.99").
///
/// * **Order mode** (any other `forItem`):
///   Falls back to the simple card-form layout used by existing order flows.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.forItem});
  final String forItem;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Card controllers (order mode)
  final _holderCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  // Plan mode — selected payment method index (0=Card, 1=PayPal, 2=Apple)
  int _selectedMethod = 0;

  @override
  void dispose() {
    _holderCtrl.dispose();
    _cardCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  bool get _isPlanMode => widget.forItem.startsWith('plan_');

  String get _planCode =>
      _isPlanMode ? widget.forItem.substring('plan_'.length) : '';

  bool _orderValid() =>
      _holderCtrl.text.isNotEmpty &&
      _cardCtrl.text.isNotEmpty &&
      _cvvCtrl.text.isNotEmpty &&
      _cardCtrl.text.length >= 12;

  Future<void> _confirm() async {
    if (_isPlanMode) {
      final planProvider = context.read<PlanProvider>();
      final authProvider = context.read<AuthProvider>();
      await planProvider.subscribe(_planCode);
      await authProvider.refreshProfile();
      if (mounted) context.go(Routes.paymentSuccess);
    } else {
      if (!_orderValid()) {
        context.go(Routes.paymentError);
        return;
      }
      if (mounted) context.go(Routes.paymentSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isPlanMode ? _buildPlanMode(context) : _buildOrderMode(context);
  }

  // ── Plan checkout (Frame 20) ────────────────────────────────────────────────

  Widget _buildPlanMode(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              l10n.checkoutTitle,
              style: AppText.heading.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.checkoutSubtitle,
              style: AppText.caption.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 16),

            // Plan summary card
            Container(
              decoration: BoxDecoration(
                color: AppColors.planPrimeBg,
                border: Border.all(
                    color: AppColors.planPrimeBorder, width: 1.5),
                borderRadius:
                    BorderRadius.circular(AppColors.radiusCard),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.planPrime,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CfIcons.stepBag(
                          size: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.checkoutPlanName,
                          style: AppText.heading.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          l10n.checkoutBilledMonthly,
                          style: AppText.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                            color: AppColors.planPrime,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.checkoutPlanPrice,
                        style: AppText.heading.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        l10n.checkoutPerMonth,
                        style: AppText.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: AppColors.mutedDisabled,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Payment method label
            Text(
              l10n.paymentMethod,
              style: AppText.caption.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.mutedLabel,
              ),
            ),
            const SizedBox(height: 9),

            // Payment method chips
            Row(
              children: [
                Expanded(
                  child: _MethodChip(
                    label: l10n.payMethodCard,
                    iconWidget: CfIcons.card(
                      size: 24,
                      color: _selectedMethod == 0
                          ? AppColors.primary
                          : AppColors.mutedLabel,
                    ),
                    active: _selectedMethod == 0,
                    onTap: () => setState(() => _selectedMethod = 0),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _MethodChip(
                    label: l10n.payMethodPaypal,
                    iconWidget: CfIcons.paypal(
                      size: 24,
                      color: _selectedMethod == 1
                          ? AppColors.primary
                          : AppColors.mutedLabel,
                    ),
                    active: _selectedMethod == 1,
                    onTap: () => setState(() => _selectedMethod = 1),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: _MethodChip(
                    label: l10n.payMethodApple,
                    iconWidget: CfIcons.apple(
                      size: 24,
                      color: _selectedMethod == 2
                          ? AppColors.primary
                          : AppColors.mutedLabel,
                    ),
                    active: _selectedMethod == 2,
                    onTap: () => setState(() => _selectedMethod = 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Card number field
            Text(
              l10n.cardNumber,
              style: AppText.caption.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppColors.mutedLabel,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius:
                    BorderRadius.circular(AppColors.radius),
                boxShadow: AppColors.shadowSoft,
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 13, vertical: 12),
              child: Row(
                children: [
                  CfIcons.cardSimple(
                      size: 20, color: AppColors.navy),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.cardNumberHint,
                      style: AppText.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.06 * 14,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 11),

            // Expiry + CVV row
            Row(
              children: [
                Expanded(
                  child: _CardSubField(
                    label: l10n.cardExpiry,
                    value: l10n.cardExpiryHint,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: _CardSubField(
                    label: l10n.cardCvv,
                    value: '•••',
                    letterSpacing: 0.18 * 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Total row — dashed separator per design (1px dashed #CBD5E1)
            CfDashedDivider(color: AppColors.radioIdle),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.totalToday,
                  style: AppText.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  l10n.checkoutPlanPrice,
                  style: AppText.heading.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: AppColors.planPrime,
                    letterSpacing: -0.22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Pay button
            Semantics(
              button: true,
              label: l10n.payButton,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                    shadowColor:
                        AppColors.primary.withValues(alpha: 0.28),
                  ).copyWith(
                    elevation: WidgetStateProperty.all(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CfIcons.stepCheck(
                          size: 19, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        l10n.payButton,
                        style: AppText.body.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 11),

            // Security note
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CfIcons.lock(size: 14, color: AppColors.mutedDisabled),
                const SizedBox(width: 6),
                Text(
                  l10n.securedEncryption,
                  style: AppText.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
                    color: AppColors.mutedDisabled,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Order payment fallback (keeps existing callers working) ────────────────

  Widget _buildOrderMode(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.checkoutTitle,
              style: AppText.heading.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _SimpleField(
              label: l10n.cardHolderName,
              controller: _holderCtrl,
            ),
            const SizedBox(height: 12),
            _SimpleField(
              label: l10n.cardNumber,
              controller: _cardCtrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _SimpleField(
              label: l10n.cardCvv,
              controller: _cvvCtrl,
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppColors.radius),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  l10n.orderConfirmButton,
                  style: AppText.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Method Chip ───────────────────────────────────────────────────────────────

class _MethodChip extends StatelessWidget {
  const _MethodChip({
    required this.label,
    required this.iconWidget,
    required this.active,
    required this.onTap,
  });

  final String label;
  final Widget iconWidget;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: active ? AppColors.tabActiveBg : AppColors.fieldBg,
            borderRadius: BorderRadius.circular(AppColors.radius),
            border: Border.all(
              color: active ? AppColors.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          padding:
              const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
          child: Column(
            children: [
              iconWidget,
              const SizedBox(height: 6),
              Text(
                label,
                style: AppText.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: active ? AppColors.primary : AppColors.mutedLabel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Card Sub Field (Expiry / CVV display) ─────────────────────────────────────

class _CardSubField extends StatelessWidget {
  const _CardSubField({
    required this.label,
    required this.value,
    this.letterSpacing,
  });

  final String label;
  final String value;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.caption.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: AppColors.mutedLabel,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.fieldBg,
            borderRadius: BorderRadius.circular(AppColors.radius),
            boxShadow: AppColors.shadowSoft,
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 13, vertical: 12),
          child: Text(
            value,
            style: AppText.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.text,
              letterSpacing: letterSpacing,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Simple field for order-mode fallback ──────────────────────────────────────

class _SimpleField extends StatelessWidget {
  const _SimpleField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.caption.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: AppColors.mutedLabel,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.fieldBg,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppColors.radius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 13, vertical: 12),
          ),
        ),
      ],
    );
  }
}
