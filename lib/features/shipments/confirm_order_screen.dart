import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Frame 23 — "Confirm your order"
// Step 1 of 3: pre-filled customer name / phone / email.
// "Next" → payment screen (existing /payment route).
// ──────────────────────────────────────────────────────────────────────────────

class ConfirmOrderScreen extends StatelessWidget {
  const ConfirmOrderScreen({super.key, this.orderId});

  /// Optional: the order being confirmed. Passed via query param if needed.
  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authState = context.watch<AuthProvider>().state;
    final user = authState.user;

    final name = user?.name ?? '';
    final phone = user?.phone ?? '';
    final email = user?.email ?? '';

    return CfScaffold(
      topBar: const CfTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 22, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Title ─────────────────────────────────────────────────
            Text(
              l.confirmOrderTitle,
              style: AppText.title.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),

            // ── 1-2-3 step indicator ──────────────────────────────────
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 6),
              child: _StepIndicator(activeStep: 0),
            ),
            const SizedBox(height: 20),

            // ── Info card ─────────────────────────────────────────────
            Container(
              padding: const EdgeInsetsDirectional.fromSTEB(18, 20, 18, 20),
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius: BorderRadius.circular(AppColors.radiusCard),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D0F172A),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _InfoField(
                    label: l.confirmCustomerName,
                    value: name.isNotEmpty ? name : '—',
                  ),
                  const SizedBox(height: 16),
                  _InfoField(
                    label: l.confirmCustomerPhone,
                    value: phone.isNotEmpty ? phone : '—',
                  ),
                  const SizedBox(height: 16),
                  _InfoField(
                    label: l.confirmCustomerEmail,
                    value: email.isNotEmpty ? email : '—',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Next button ───────────────────────────────────────────
            Semantics(
              button: true,
              label: l.next,
              child: GestureDetector(
                onTap: () {
                  final forParam = orderId != null && orderId!.isNotEmpty
                      ? '?for=order_$orderId'
                      : '';
                  context.push('${Routes.payment}$forParam');
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.navyTile,
                    borderRadius: BorderRadius.circular(AppColors.radius),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    l.next,
                    style: AppText.body.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 1-2-3 step indicator  (green = done/active, grey = pending)
// Connectors use Expanded so they fill remaining space responsively.
// ──────────────────────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.activeStep});

  /// 0-based: 0 = step 1 done, 1 = steps 1+2 done, 2 = all done
  final int activeStep;

  static const Color _greenBg = AppColors.stepGreen;
  static const Color _greyBg = Color(0xFFD9D9D9); // neutral stepper grey — intentional

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Circle(number: 1, done: activeStep >= 0, greenBg: _greenBg, greyBg: _greyBg),
        _Connector(done: activeStep >= 1),
        _Circle(number: 2, done: activeStep >= 1, greenBg: _greenBg, greyBg: _greyBg),
        _Connector(done: activeStep >= 2),
        _Circle(number: 3, done: activeStep >= 2, greenBg: _greenBg, greyBg: _greyBg),
      ],
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({
    required this.number,
    required this.done,
    required this.greenBg,
    required this.greyBg,
  });
  final int number;
  final bool done;
  final Color greenBg;
  final Color greyBg;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step $number',
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: done ? greenBg : greyBg,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$number',
          style: AppText.body.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 17,
            color: done ? AppColors.text : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({required this.done});
  final bool done;

  static const Color _greenBg = AppColors.stepGreen;
  static const Color _greyBg = Color(0xFFD9D9D9); // neutral stepper grey — intentional

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 3,
        color: done ? _greenBg : _greyBg,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Info field row (label centered above, value in box)
// ──────────────────────────────────────────────────────────────────────────────

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppText.body.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: AppColors.text,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Semantics(
          label: '$label $value',
          child: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(14, 11, 14, 11),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.text),
              borderRadius: BorderRadius.circular(AppColors.radius),
            ),
            child: Text(
              value,
              style: AppText.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
