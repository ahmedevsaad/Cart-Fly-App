import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_flags/country_flags.dart';

import '../../data/warehouse_addresses.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class CountryLockersScreen extends StatelessWidget {
  const CountryLockersScreen({super.key, required this.code});
  final String code;

  String get _mapAsset {
    switch (code) {
      case 'cn':
        return 'assets/maps/map-china.jpg';
      case 'us':
        return 'assets/maps/map-usa.jpg';
      case 'ae':
        return 'assets/maps/map-uae.png';
      case 'eg':
        return 'assets/maps/map-egypt.png';
      case 'sa':
        return 'assets/maps/map-saudi.png';
      default:
        return 'assets/maps/map-egypt.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final addr = addressByCode(code);

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Country heading row ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CountryFlag.fromCountryCode(
                    code.toUpperCase(),
                    width: 30,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 9),
                Text(
                  addr.countryLabel,
                  style: AppText.heading.copyWith(
                      fontWeight: FontWeight.w800, fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Copy-address card ───────────────────────────────────
            _AddressCard(addr: addr, l10n: l10n),
            const SizedBox(height: 13),

            // ── Map image ───────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(AppColors.radiusCard),
              child: Image.asset(
                _mapAsset,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 280,
                  color: AppColors.fieldBg,
                  alignment: Alignment.center,
                  child: const Icon(Icons.map_outlined,
                      size: 48, color: AppColors.mutedDisabled),
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

// ──────────────────────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.addr, required this.l10n});
  final WarehouseAddress addr;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        boxShadow: AppColors.shadowSoft,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.yourCartFlyAddress,
                style: AppText.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
              _CopyButton(addr: addr, l10n: l10n),
            ],
          ),
          const SizedBox(height: 11),
          // Rows
          _AddressRow(label: l10n.recipient, value: addr.recipient,
              bold: true),
          const SizedBox(height: 7),
          _AddressRow(label: l10n.address, value: addr.address),
          const SizedBox(height: 7),
          _AddressRow(label: l10n.city, value: addr.city),
        ],
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.addr, required this.l10n});
  final WarehouseAddress addr;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: addr.fullText));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.addressCopied),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFCFE0FB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.copy_rounded,
                size: 13, color: AppColors.primary),
            const SizedBox(width: 5),
            Text(
              l10n.copyAddress,
              style: AppText.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.label,
    required this.value,
    this.bold = false,
  });
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.caption.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: AppColors.muted),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: AppText.caption.copyWith(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              fontSize: 12.5,
              color: AppColors.text,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
