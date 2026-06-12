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

  // Redesign accent + surface tokens
  static const chipBlue = Color(0xFFCFE0FB);       // light-blue chip/avatar bg
  static const navBarBorder = Color(0xFFEAEFF5);   // bottom nav bar border
  static const radioIdle = Color(0xFFCBD5E1);      // unselected radio ring
  static const tagBg = Color(0xFFE3E8EE);          // KG pill / tag background
  static const calcCardBg = Color(0xFFEAF1FE);     // calculator estimated cost card
  static const calcDivider = Color(0xFFC5D6F3);    // calculator card divider
  static const deliveryBg = Color(0xFFECFBF0);     // estimated delivery card bg
  static const deliveryIconBg = Color(0xFFD2F1DC); // delivery icon circle bg
  static const planPrime = Color(0xFF7C3AED);      // prime plan purple
  static const planPrimeBg = Color(0xFFF5F0FF);    // prime plan card background
  static const planPrimeBorder = Color(0xFFE4D5FF); // prime plan card border
  static const planFree = Color(0xFF16A34A);        // free/basic plan green
  static const stepGreen = Color(0xFFACFF9C);       // done-step connector on confirm/track
  static const signOutBg = Color(0xFFFA5D5F);       // sign-out button background

  // Teal "ship" accent + warning + tab tokens
  static const teal = Color(0xFF0D9488);
  static const tealDark = Color(0xFF0F766E);
  static const tealBg = Color(0xFFF0FDFA);
  static const warnBg = Color(0xFFFFFBEB);
  static const warnBorder = Color(0xFFFCEFC7);
  static const warnIcon = Color(0xFFE0A800);
  static const warnText = Color(0xFF92740C);
  static const statusAmber = Color(0xFF92740C);
  static const statusAmberBg = Color(0xFFFEF3C7);
  static const statusBlue = Color(0xFF1D4ED8);
  static const statusBlueBg = Color(0xFFDBEAFE);
  static const tabActiveBg = Color(0xFFEFF4FE);
  static const dashedDivider = Color(0xFFD5DCE3);

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
