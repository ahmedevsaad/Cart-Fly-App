import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class FlagIcon extends StatelessWidget {
  const FlagIcon({super.key, required this.code, this.size = 96});
  final String code;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CountryFlag.fromCountryCode(
      code.toUpperCase(),
      width: size,
      height: size * 0.7,
      shape: RoundedRectangle(18),
    );
  }
}
