import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/warehouse_addresses.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_dashed.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  // Warehouse codes available on this screen
  static const _warehouses = ['cn', 'eg'];
  String _selected = 'cn';

  WarehouseAddress get _addr => addressByCode(_selected);

  // Extra detail fields that aren't in WarehouseAddress model —
  // sourced verbatim from Frame 13 of the design.
  static const _postalCodeByCn = '510310';
  static const _postalCodeByEg = '11765';
  static const _phoneByCn = '+86 20 8930 0000';
  static const _phoneByEg = '+20 2 2695 0000';

  String get _postalCode =>
      _selected == 'cn' ? _postalCodeByCn : _postalCodeByEg;
  String get _phone => _selected == 'cn' ? _phoneByCn : _phoneByEg;

  void _copyField(String value) {
    Clipboard.setData(ClipboardData(text: value));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied', style: GoogleFonts.inter()),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.text,
        ),
      );
    }
  }

  void _copyFullAddress() {
    final full = [
      'Recipient: ${_addr.recipient}',
      'Address: ${_addr.address}',
      'City: ${_addr.city}',
      'Postal Code: $_postalCode',
      'Phone: $_phone',
    ].join('\n');
    Clipboard.setData(ClipboardData(text: full));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Full address copied',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      topBar: const CfTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your warehouse address',
              style: AppText.heading
                  .copyWith(fontWeight: FontWeight.w800, fontSize: 22),
            ),
            const SizedBox(height: 4),
            Text(
              'Ship your online orders to this address. We receive them, then forward to you.',
              style: AppText.bodyMedium.copyWith(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
            ),
            const SizedBox(height: 16),

            // ── Warehouse selector ────────────────────────────────────
            Row(
              children: _warehouses
                  .map((code) => Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selected = code),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: EdgeInsetsDirectional.only(
                                end: code == 'cn' ? 9 : 0),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: code == _selected
                                  ? const Color(0xFFF0FDFA)
                                  : AppColors.fieldBg,
                              border: Border.all(
                                color: code == _selected
                                    ? const Color(0xFF0D9488)
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                              borderRadius:
                                  BorderRadius.circular(AppColors.radius),
                            ),
                            child: Row(
                              children: [
                                _WarehouseFlag(code: code),
                                const SizedBox(width: 8),
                                Text(
                                  code == 'cn' ? 'China' : 'Egypt',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: code == _selected
                                        ? const Color(0xFF0F766E)
                                        : AppColors.mutedLabel,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 14),

            // ── Address card ──────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius:
                    BorderRadius.circular(AppColors.radiusCard),
                boxShadow: AppColors.shadowSoft,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                children: [
                  _AddressRow(
                    label: 'Recipient',
                    value: _addr.recipient,
                    onCopy: () => _copyField(_addr.recipient),
                    showDivider: true,
                  ),
                  _AddressRow(
                    label: 'Address',
                    value: _addr.address,
                    onCopy: () => _copyField(_addr.address),
                    showDivider: true,
                  ),
                  _AddressRow(
                    label: 'City / Province',
                    value: _addr.city,
                    onCopy: () => _copyField(_addr.city),
                    showDivider: true,
                  ),
                  _AddressRow(
                    label: 'Postal code',
                    value: _postalCode,
                    onCopy: () => _copyField(_postalCode),
                    showDivider: true,
                  ),
                  _AddressRow(
                    label: 'Phone',
                    value: _phone,
                    onCopy: () => _copyField(_phone),
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Copy full address button ───────────────────────────────
            GestureDetector(
              onTap: _copyFullAddress,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488),
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
                    const Icon(Icons.copy_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      'Copy full address',
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
            const SizedBox(height: 13),

            // ── CF-ID reminder note ────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                border: Border.all(color: const Color(0xFFFCEFC7)),
                borderRadius: BorderRadius.circular(AppColors.radius),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: Color(0xFFE0A800), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF92740C),
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                        ),
                        children: const [
                          TextSpan(text: 'Always add your '),
                          TextSpan(
                            text: 'CF-ID',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          TextSpan(
                              text:
                                  ' to the recipient name so we can match the package to you.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Address row with copy icon
// ──────────────────────────────────────────────────────────────────────────────

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.label,
    required this.value,
    required this.onCopy,
    required this.showDivider,
  });
  final String label;
  final String value;
  final VoidCallback onCopy;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mutedDisabled,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              Semantics(
                button: true,
                label: 'Copy $label',
                child: InkWell(
                  onTap: onCopy,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    // visual 30×30, hit area extended to ≥44px via padding
                    constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.tagBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: 30,
                    height: 30,
                    child: const Icon(
                      Icons.copy_rounded,
                      size: 15,
                      color: AppColors.mutedLabel,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          CfDashedDivider(color: const Color(0xFFD5DCE3)),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Tiny flag widget (paint-drawn, no package dependency needed)
// ──────────────────────────────────────────────────────────────────────────────

class _WarehouseFlag extends StatelessWidget {
  const _WarehouseFlag({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    if (code == 'cn') {
      return Container(
        width: 22,
        height: 15,
        decoration: BoxDecoration(
          color: const Color(0xFFDE2910),
          borderRadius: BorderRadius.circular(3),
        ),
        alignment: Alignment.center,
        child: const Text(
          '★',
          style: TextStyle(
            color: Color(0xFFFFDE00),
            fontSize: 10,
            height: 1,
          ),
        ),
      );
    }
    // Egypt flag: red / white / black stripes
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        width: 22,
        height: 15,
        child: Column(
          children: const [
            Expanded(child: ColoredBox(color: Color(0xFFCE1126))),
            Expanded(child: ColoredBox(color: Colors.white)),
            Expanded(child: ColoredBox(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
