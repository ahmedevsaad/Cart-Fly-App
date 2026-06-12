import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../data/pricing.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_dashed.dart';
import '../../widgets/cf_journey_nav.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import '../../widgets/icons/cf_icons.dart';

// Country options available for selection
class _Country {
  const _Country(this.code, this.pricingKey, this.name);
  final String code;       // ISO country code for flag (e.g. 'CN')
  final String pricingKey; // key used in pricing map (e.g. 'cn')
  final String name;
}

const _kFromCountries = <_Country>[
  _Country('CN', 'cn', 'China'),
  _Country('US', 'us', 'USA'),
  _Country('AE', 'ae', 'UAE'),
  _Country('SA', 'sa', 'Saudi Arabia'),
];

const _kToCountries = <_Country>[
  _Country('EG', 'eg', 'Egypt'),
  _Country('SA', 'sa', 'Saudi Arabia'),
  _Country('AE', 'ae', 'UAE'),
];

// Category options
class _Category {
  const _Category(this.key, this.labelKey);
  final String key;
  final String labelKey; // 'electronics' | 'fashion' | 'accessories' | 'other'
}

const _kCategories = [
  _Category('electronics', 'electronics'),
  _Category('fashion', 'fashion'),
  _Category('accessories', 'accessories'),
];

class ShippingCalculatorScreen extends StatefulWidget {
  const ShippingCalculatorScreen({super.key});

  @override
  State<ShippingCalculatorScreen> createState() =>
      _ShippingCalculatorScreenState();
}

class _ShippingCalculatorScreenState
    extends State<ShippingCalculatorScreen> {
  // Defaults: China -> Egypt, 2.5 kg, electronics
  int _fromIdx = 0; // index into _kFromCountries
  int _toIdx = 0;   // index into _kToCountries
  double _weightKg = 2.5;
  int _catIdx = 0;  // index into _kCategories

  late CalcResult _result;

  @override
  void initState() {
    super.initState();
    _recalc();
  }

  void _recalc() {
    _result = estimate(
      from: _kFromCountries[_fromIdx].pricingKey,
      to: _kToCountries[_toIdx].pricingKey,
      weightKg: _weightKg,
      category: _kCategories[_catIdx].key,
    );
  }

  void _setFrom(int idx) => setState(() {
        _fromIdx = idx;
        _recalc();
      });

  void _setTo(int idx) => setState(() {
        _toIdx = idx;
        _recalc();
      });

  void _setCategory(int idx) => setState(() {
        _catIdx = idx;
        _recalc();
      });

  void _showWeightPicker() async {
    final picked = await showDialog<double>(
      context: context,
      builder: (_) => _WeightDialog(initial: _weightKg),
    );
    if (picked != null) {
      setState(() {
        _weightKg = picked;
        _recalc();
      });
    }
  }

  void _showCountryPicker<T extends _Country>({
    required List<T> options,
    required int selectedIdx,
    required void Function(int) onSelected,
  }) async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CountryPicker(
        countries: options,
        selectedIdx: selectedIdx,
      ),
    );
    if (picked != null) onSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final from = _kFromCountries[_fromIdx];
    final to = _kToCountries[_toIdx];
    final r = _result;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      bottomNav: cfJourneyNav(context),
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
                    countryCode: from.code,
                    countryName: from.name,
                    onTap: () => _showCountryPicker(
                      options: _kFromCountries,
                      selectedIdx: _fromIdx,
                      onSelected: _setFrom,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: _CountryField(
                    label: l10n.calcCountryTo,
                    countryCode: to.code,
                    countryName: to.name,
                    onTap: () => _showCountryPicker(
                      options: _kToCountries,
                      selectedIdx: _toIdx,
                      onSelected: _setTo,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Weight ────────────────────────────────────────────────
            Text(
              l10n.calcWeight,
              style: AppText.caption.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppColors.mutedLabel,
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _showWeightPicker,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.fieldBg,
                  borderRadius: BorderRadius.circular(AppColors.radius),
                  boxShadow: AppColors.shadowSoft,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 11),
                child: Row(
                  children: [
                    CfIcons.cartCalculator(
                        size: 20, color: AppColors.navy),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        _weightKg.toStringAsFixed(
                            _weightKg == _weightKg.roundToDouble() ? 1 : 2),
                        style: AppText.body.copyWith(
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
                        style: AppText.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: AppColors.mutedLabel,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Product Category ──────────────────────────────────────
            Text(
              l10n.calcProductCategory,
              style: AppText.caption.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppColors.mutedLabel,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setCategory(0),
                    child: _CategoryChip(
                      label: l10n.calcCatElectronics,
                      iconWidget: CfIcons.card(
                          size: 20,
                          color: _catIdx == 0
                              ? AppColors.primary
                              : AppColors.mutedLabel),
                      active: _catIdx == 0,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setCategory(1),
                    child: _CategoryChip(
                      label: l10n.calcCatFashion,
                      iconWidget: CfIcons.stepBag(
                          size: 20,
                          color: _catIdx == 1
                              ? AppColors.primary
                              : AppColors.mutedLabel),
                      active: _catIdx == 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setCategory(2),
                    child: _CategoryChip(
                      label: l10n.calcCatAccessories,
                      iconWidget: CfIcons.stepBox(
                          size: 20,
                          color: _catIdx == 2
                              ? AppColors.primary
                              : AppColors.mutedLabel),
                      active: _catIdx == 2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ── Calculate button ──────────────────────────────────────
            Semantics(
              button: true,
              label: l10n.calcCalculate,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Inputs are already live — button triggers a visual
                    // recalc confirmation (state already up-to-date).
                    setState(_recalc);
                  },
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CfIcons.cartCalculator(
                          size: 20, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        l10n.calcCalculate,
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
                    style: AppText.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 13),
                  _CostRow(
                    label: l10n.calcShippingCost,
                    value: '\$${r.shipping.toStringAsFixed(2)}',
                    borderBottom: true,
                  ),
                  _CostRow(
                    label: l10n.calcCustomsFee,
                    value: '\$${r.customs.toStringAsFixed(2)}',
                    borderBottom: true,
                  ),
                  _CostRow(
                    label: l10n.calcServiceFee,
                    value: '\$${r.service.toStringAsFixed(2)}',
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
                        style: AppText.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '\$${r.total.toStringAsFixed(2)}',
                        style: AppText.heading.copyWith(
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
                    child: Center(
                      child: CfIcons.stepTruck(
                          size: 22, color: AppColors.success),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.calcEstimatedDelivery,
                          style: AppText.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '${r.minDays} – ${r.maxDays} Days',
                          style: AppText.heading.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CfIcons.plans(size: 22, color: AppColors.success),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Weight Dialog ─────────────────────────────────────────────────────────────

class _WeightDialog extends StatefulWidget {
  const _WeightDialog({required this.initial});
  final double initial;

  @override
  State<_WeightDialog> createState() => _WeightDialogState();
}

class _WeightDialogState extends State<_WeightDialog> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial.toString());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Weight (kg)'),
      content: TextField(
        controller: _ctrl,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        autofocus: true,
        decoration: const InputDecoration(suffixText: 'kg'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final v = double.tryParse(_ctrl.text);
            if (v != null && v > 0) Navigator.pop(context, v);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

// ── Country Picker Bottom Sheet ───────────────────────────────────────────────

class _CountryPicker extends StatelessWidget {
  const _CountryPicker({
    required this.countries,
    required this.selectedIdx,
  });

  final List<_Country> countries;
  final int selectedIdx;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          for (int i = 0; i < countries.length; i++)
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: CountryFlag.fromCountryCode(
                  countries[i].code,
                  width: 32,
                  height: 22,
                ),
              ),
              title: Text(countries[i].name),
              trailing:
                  i == selectedIdx ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, i),
            ),
          const SizedBox(height: 8),
        ],
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
              style: AppText.heading.copyWith(
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
            style: AppText.caption.copyWith(
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
    required this.onTap,
  });

  final String label;
  final String countryCode;
  final String countryName;
  final VoidCallback onTap;

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
        GestureDetector(
          onTap: onTap,
          child: Container(
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
                    style: AppText.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.text,
                    ),
                  ),
                ),
                CfIcons.chevronDown(size: 16, color: AppColors.muted),
              ],
            ),
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
    required this.iconWidget,
    required this.active,
  });

  final String label;
  final Widget iconWidget;
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
          iconWidget,
          const SizedBox(height: 5),
          Text(
            label,
            style: AppText.caption.copyWith(
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: borderBottom ? 0 : 9,
            bottom: borderBottom ? 9 : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppText.body.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.text,
                ),
              ),
              Text(
                value,
                style: AppText.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
        if (borderBottom)
          CfDashedDivider(color: AppColors.calcDivider),
      ],
    );
  }
}
