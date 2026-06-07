import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

TextTheme buildTextTheme(Locale locale) {
  final body = locale.languageCode == 'ar'
      ? GoogleFonts.cairoTextTheme()
      : GoogleFonts.interTextTheme();
  final display = GoogleFonts.dmSerifDisplay();

  return body.copyWith(
    displayLarge: display.copyWith(
      fontSize: 56,
      color: AppColors.primary,
      fontStyle: FontStyle.italic,
    ),
    displayMedium: display.copyWith(
      fontSize: 40,
      color: AppColors.primary,
      fontStyle: FontStyle.italic,
    ),
    headlineLarge: display.copyWith(fontSize: 28, color: AppColors.primary),
    headlineSmall:
        body.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: AppColors.text),
    titleLarge:
        body.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.text),
    bodyLarge: body.bodyLarge?.copyWith(fontSize: 16, color: AppColors.text),
    bodyMedium: body.bodyMedium?.copyWith(fontSize: 14, color: AppColors.text),
    labelLarge: body.labelLarge?.copyWith(fontWeight: FontWeight.w600),
  );
}
