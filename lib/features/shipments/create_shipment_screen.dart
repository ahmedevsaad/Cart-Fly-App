import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/lockers.dart';
import '../../data/models/order.dart';
import '../../data/warehouses.dart';
import '../../state/orders_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Category chips definition
// ──────────────────────────────────────────────────────────────────────────────
enum _Category { electronics, fashion, other }

extension _CategoryLabel on _Category {
  String get label {
    switch (this) {
      case _Category.electronics:
        return 'Electronics';
      case _Category.fashion:
        return 'Fashion';
      case _Category.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case _Category.electronics:
        return Icons.desktop_windows_outlined;
      case _Category.fashion:
        return Icons.checkroom_outlined;
      case _Category.other:
        return Icons.shopping_bag_outlined;
    }
  }
}

class CreateShipmentScreen extends StatefulWidget {
  const CreateShipmentScreen({super.key});

  @override
  State<CreateShipmentScreen> createState() => _CreateShipmentScreenState();
}

class _CreateShipmentScreenState extends State<CreateShipmentScreen> {
  // ── Pre-alert fields (Frame 14) ───────────────────────────────────────────
  final _merchant = TextEditingController();
  final _trackingNumber = TextEditingController();
  _Category _category = _Category.electronics;
  final _estimatedValue = TextEditingController();
  final _quantity = TextEditingController();

  // ── Original create-shipment fields ──────────────────────────────────────
  final _title = TextEditingController();
  String _country = warehouses.first.code;
  DeliveryMethod _method = DeliveryMethod.home;
  String? _lockerId;
  bool _loading = false;

  @override
  void dispose() {
    _merchant.dispose();
    _trackingNumber.dispose();
    _estimatedValue.dispose();
    _quantity.dispose();
    _title.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final titleText = _title.text.trim().isNotEmpty
        ? _title.text.trim()
        : (_merchant.text.trim().isNotEmpty
            ? '${_merchant.text.trim()} · ${_category.label}'
            : _category.label);

    setState(() => _loading = true);
    final provider = context.read<OrdersProvider>();
    try {
      final id = await provider.create(Order(
        id: '',
        title: titleText,
        sourceCountry: _country,
        deliveryMethod: _method,
        lockerId: _method == DeliveryMethod.locker ? _lockerId : null,
        status: OrderStatus.placed,
        createdAt: DateTime.now(),
      ));
      if (mounted) context.pushReplacement('/orders/$id/track');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockerCountry =
        countryLockers.where((c) => c.code == _country).firstOrNull;
    final allLockers = lockerCountry?.cities
            .expand((city) => city.lockers)
            .toList() ??
        [];

    return CfScaffold(
      topBar: const CfTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Title (Frame 14) ─────────────────────────────────────
            Text(
              'Declare a package',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.01 * 22,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tell us what\'s coming so we can match it on arrival.',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.muted,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),

            // ── Store / merchant ─────────────────────────────────────
            _FieldLabel('Store / merchant'),
            const SizedBox(height: 6),
            _FieldContainer(
              child: Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined,
                      color: AppColors.teal, size: 19),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _merchant,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700, fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: 'e.g. Taobao',
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Tracking number ──────────────────────────────────────
            _FieldLabel('Tracking number'),
            const SizedBox(height: 6),
            _FieldContainer(
              child: Row(
                children: [
                  const Icon(Icons.barcode_reader,
                      color: AppColors.navy, size: 19),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _trackingNumber,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 0.04 * 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: 'e.g. SF1234567890CN',
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Category chips ────────────────────────────────────────
            _FieldLabel('Category'),
            const SizedBox(height: 8),
            Row(
              children: _Category.values.map((cat) {
                final selected = _category == cat;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsetsDirectional.only(
                          end: cat != _Category.other ? 8 : 0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.tealBg
                            : AppColors.fieldBg,
                        border: Border.all(
                          color: selected
                              ? AppColors.teal
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        borderRadius:
                            BorderRadius.circular(11),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            cat.icon,
                            size: 20,
                            color: selected
                                ? AppColors.teal
                                : AppColors.mutedLabel,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            cat.label,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? AppColors.tealDark
                                  : AppColors.mutedLabel,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // ── Est. value + Quantity ─────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FieldLabel('Est. value'),
                      const SizedBox(height: 6),
                      _FieldContainer(
                        child: TextField(
                          controller: _estimatedValue,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700, fontSize: 14),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: r'$0',
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _FieldLabel('Quantity'),
                      const SizedBox(height: 6),
                      _FieldContainer(
                        child: TextField(
                          controller: _quantity,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700, fontSize: 14),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: '1',
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // ── Divider between pre-alert & shipment details ──────────
            const Divider(color: AppColors.cardBorder),
            const SizedBox(height: 14),

            // ── Original shipment fields ──────────────────────────────
            CfInput(
              label: 'Item / title',
              controller: _title,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _country,
              decoration: const InputDecoration(labelText: 'Source country'),
              items: warehouses
                  .map((w) => DropdownMenuItem(
                        value: w.code,
                        child: Text(w.displayName),
                      ))
                  .toList(),
              onChanged: (v) => setState(() {
                _country = v!;
                _lockerId = null;
              }),
            ),
            const SizedBox(height: 16),
            const Text('Delivery method'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _MethodButton(
                    label: 'Home',
                    selected: _method == DeliveryMethod.home,
                    onTap: () => setState(() => _method = DeliveryMethod.home),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MethodButton(
                    label: 'Locker',
                    selected: _method == DeliveryMethod.locker,
                    onTap: () =>
                        setState(() => _method = DeliveryMethod.locker),
                  ),
                ),
              ],
            ),
            if (_method == DeliveryMethod.locker &&
                allLockers.isNotEmpty) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _lockerId,
                decoration:
                    const InputDecoration(labelText: 'Select locker'),
                items: allLockers
                    .map((l) => DropdownMenuItem(
                          value: l.name,
                          child: Text('${l.name} – ${l.spot}'),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _lockerId = v),
              ),
            ],
            const SizedBox(height: 18),

            // ── Add package / submit ──────────────────────────────────
            _loading
                ? const Center(child: CircularProgressIndicator())
                : Semantics(
                    button: true,
                    label: 'Add package',
                    child: Material(
                      color: AppColors.teal,
                      borderRadius: BorderRadius.circular(13),
                      child: InkWell(
                        onTap: _submit,
                        borderRadius: BorderRadius.circular(13),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x470D9488),
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_rounded,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Add package',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
// Small helpers
// ──────────────────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: AppColors.mutedLabel,
        ),
      );
}

class _FieldContainer extends StatelessWidget {
  const _FieldContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.fieldBg,
          borderRadius: BorderRadius.circular(AppColors.radius),
          boxShadow: AppColors.shadowSoft,
        ),
        child: child,
      );
}

class _MethodButton extends StatelessWidget {
  const _MethodButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          border: Border.all(color: theme.colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
