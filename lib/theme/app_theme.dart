import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text.dart';

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bgPage,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primary,
      surface: AppColors.bgPage,
    ),
    textTheme: base.textTheme.apply(bodyColor: AppColors.text),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fieldBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      hintStyle: AppText.body.copyWith(color: AppColors.mutedDisabled),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radius),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: AppText.bodyMedium.copyWith(
            color: Colors.white, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radius)),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        elevation: 0,
      ),
    ),
  );
}
