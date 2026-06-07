import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../theme/app_text.dart';

/// [code] is an ISO country code, e.g. 'SA','EG','AE','US','CN'.
class CfFlagCard extends StatelessWidget {
  const CfFlagCard({super.key, required this.code, required this.name, this.onTap});
  final String code;
  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
