import 'package:flutter/material.dart';

/// CartFly color tokens — mirror of `CartFly Redesign.dc.html` design system.
class AppColors {
  AppColors._();

  static const bgSplash = Color(0xFFC5E2FF);
  static const bgPage = Color(0xFFFFFFFF);
  static const primary = Color(0xFF2563EB); // brand blue — buttons + accents
  static const navy = Color(0xFF16335E); // deep accent / icon strokes
  static const fieldBg = Color(0xFFF1F3F5); // gray input/card fill
  static const cardBorder = Color(0xFFE2E8F0); // hairline border
  static const text = Color(0xFF0F172A); // slate-900
  static const muted = Color(0xFF64748B);
  static const mutedLabel = Color(0xFF475569); // field labels
  static const mutedDisabled = Color(0xFF94A3B8);
  static const success = Color(0xFF15803D);
  static const successBg = Color(0xFFDCFCE7);
  static const danger = Color(0xFFEF4444);
  static const navIdle = Color(0xFF7E8AA0); // idle bottom-nav icon
  static const cardBg = Color(0xFFF1F3F5);
  static const navyTile = Color(0xFF86A6EA);   // "About us" card bg (Frame 27)
  static const navyLabel = Color(0xFF16447B);  // "About us" card label/icon
  static const activeTint = Color(0xFFE7EEFB); // expanded-section highlight bg

  static const double radius = 12; // fields
  static const double radiusCard = 16; // cards
  static const double radiusPill = 999;

  // Soft elevations (use in BoxShadow lists).
  static const List<BoxShadow> shadowSoft = [
    BoxShadow(color: Color(0x0D0F172A), blurRadius: 3, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> shadowCard = [
    BoxShadow(color: Color(0x210F172A), blurRadius: 44, offset: Offset(0, 18)),
  ];
}
