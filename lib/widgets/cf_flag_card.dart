import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../theme/app_text.dart';

/// Country flag + name card.
///
/// [code] is an ISO 3166-1 alpha-2 country code, e.g. 'SA', 'EG', 'AE', 'US', 'CN'.
/// Stable public API: [code], [name], [onTap].
class CfFlagCard extends StatelessWidget {
  const CfFlagCard({
    super.key,
    required this.code,
    required this.name,
    this.onTap,
  });
  final String code;
  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          CountryFlag.fromCountryCode(code, width: 135, height: 90),
          const SizedBox(height: 6),
          Text(name, style: AppText.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
