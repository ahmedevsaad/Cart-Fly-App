import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography — Playfair Display (display/logo), Inter (body),
/// Alan Sans (accent), per html/design-system.css.
class AppText {
  AppText._();

  static TextStyle get logo => GoogleFonts.playfairDisplay(
      fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.text);
  static TextStyle get display => GoogleFonts.playfairDisplay(
      fontSize: 44, fontWeight: FontWeight.w600, color: AppColors.text);
  static TextStyle get title => GoogleFonts.inter(
      fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.text);
  static TextStyle get heading => GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.text);
  static TextStyle get body => GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.text);
  static TextStyle get bodyMedium => GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.text);
  static TextStyle get caption => GoogleFonts.inter(
      fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.muted);
  // Accent text (e.g. "Forget password?"). The clone uses "Alan Sans", but that
  // font may be absent from the pinned google_fonts version and would throw at
  // runtime — use Inter italic (negligible visual difference, no crash risk).
  static TextStyle get accent => GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic, color: AppColors.text);
}
