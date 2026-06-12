import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class ShippingCalculatorScreen extends StatelessWidget {
  const ShippingCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              l10n.calcTitle,
              style: AppText.heading.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.calcSubtitle,
              style: AppText.caption.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 16),

            // ── 3-step header ────────────────────────────────────────
            _StepHeader(
              steps: [l10n.calcStep1, l10n.calcStep2, l10n.calcStep3],
              activeIndex: 0,
            ),
            const SizedBox(height: 18),

            // ── Country row ───────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _CountryField(
                    label: l10n.calcCountryFrom,
                    countryCode: 'CN',
                    countryName: l10n.calcCountryChina,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: _CountryField(
                    label: l10n.calcCountryTo,
                    countryCode: 'EG',
                    countryName: l10n.calcCountryEgypt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Weight ────────────────────────────────────────────────
            Text(
              l10n.calcWeight,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppColors.mutedLabel,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius: BorderRadius.circular(AppColors.radius),
                boxShadow: AppColors.shadowSoft,
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 11),
              child: Row(
                children: [
                  const Icon(Icons.monitor_weight_outlined,
                      size: 20, color: AppColors.navy),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      '2.5',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.tagBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: Text(
                      l10n.calcWeightUnit,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: AppColors.mutedLabel,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Product Category ──────────────────────────────────────
            Text(
              l10n.calcProductCategory,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppColors.mutedLabel,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _CategoryChip(
                    label: l10n.calcCatElectronics,
                    icon: Icons.desktop_windows_outlined,
                    active: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CategoryChip(
                    label: l10n.calcCatFashion,
                    icon: Icons.checkroom_outlined,
                    active: false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CategoryChip(
                    label: l10n.calcCatAccessories,
                    icon: Icons.shopping_bag_outlined,
                    active: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ── Calculate button ──────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ).copyWith(
                  elevation: WidgetStateProperty.all(0),
                  overlayColor: WidgetStateProperty.all(
                      Colors.white.withValues(alpha: 0.1)),
                ),
                icon: const Icon(Icons.calculate_outlined,
                    size: 20, color: Colors.white),
                label: Text(
                  l10n.calcCalculate,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // ── Estimated Cost card ───────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.calcCardBg,
                borderRadius:
                    BorderRadius.circular(AppColors.radiusCard),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.calcEstimatedCost,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 13),
                  _CostRow(
                    label: l10n.calcShippingCost,
                    value: l10n.calcShippingVal,
                    borderBottom: true,
                  ),
                  _CostRow(
                    label: l10n.calcCustomsFee,
                    value: l10n.calcCustomsVal,
                    borderBottom: true,
                  ),
                  _CostRow(
                    label: l10n.calcServiceFee,
                    value: l10n.calcServiceVal,
                    borderBottom: false,
                  ),
                  Container(
                    height: 1,
                    color: AppColors.calcDivider,
                    margin: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.calcTotalEstimated,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        l10n.calcTotalVal,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                          color: AppColors.primary,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 13),

            // ── Estimated Delivery card ───────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.deliveryBg,
                borderRadius:
                    BorderRadius.circular(AppColors.radiusCard),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.deliveryIconBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_shipping_outlined,
                        size: 22, color: AppColors.success),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.calcEstimatedDelivery,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          l10n.calcDeliveryDays,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.calendar_month_outlined,
                      size: 22, color: AppColors.success),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step Header ───────────────────────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.steps,
    required this.activeIndex,
  });

  final List<String> steps;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          _StepCircle(
            number: i + 1,
            label: steps[i],
            active: i == activeIndex,
          ),
          if (i < steps.length - 1)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 18),
                color: AppColors.radioIdle,
              ),
            ),
        ],
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.number,
    required this.label,
    required this.active,
  });

  final int number;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? AppColors.primary : AppColors.fieldBg,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: active
                    ? Colors.white
                    : AppColors.mutedDisabled,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: active ? FontWeight.w700 : FontWeight.w600,
              fontSize: 11,
              color: active ? AppColors.primary : AppColors.mutedDisabled,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Country Field ─────────────────────────────────────────────────────────────

class _CountryField extends StatelessWidget {
  const _CountryField({
    required this.label,
    required this.countryCode,
    required this.countryName,
  });

  final String label;
  final String countryCode;
  final String countryName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: AppColors.mutedLabel,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.fieldBg,
            borderRadius: BorderRadius.circular(AppColors.radius),
            boxShadow: AppColors.shadowSoft,
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: CountryFlag.fromCountryCode(
                  countryCode,
                  width: 24,
                  height: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  countryName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 18, color: AppColors.muted),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Category Chip ─────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.active,
  });

  final String label;
  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: active ? AppColors.tabActiveBg : AppColors.fieldBg,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: active ? AppColors.primary : Colors.transparent,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: active ? AppColors.primary : AppColors.mutedLabel,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 11.5,
              color: active ? AppColors.primary : AppColors.mutedLabel,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Cost Row ──────────────────────────────────────────────────────────────────

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.label,
    required this.value,
    required this.borderBottom,
  });

  final String label;
  final String value;
  final bool borderBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: borderBottom ? 0 : 9,
        bottom: borderBottom ? 9 : 0,
      ),
      decoration: borderBottom
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.calcDivider,
                  style: BorderStyle.solid,
                ),
              ),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.text,
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
    );
  }
}
