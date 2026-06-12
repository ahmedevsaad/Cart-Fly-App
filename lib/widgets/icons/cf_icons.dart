import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Typed SVG icon kit extracted from the CartFly design files.
///
/// Nav idle color: #7E8AA0  (Color(0xFF7E8AA0))
/// All SVG bodies use a `{c}` placeholder that is replaced at render-time with
/// the hex colour string derived from [color].
class CfIcons {
  CfIcons._();

  // ---------------------------------------------------------------------------
  // Private helper
  // ---------------------------------------------------------------------------

  static Widget _svg(String body, double size, Color color) {
    // Use color.value (available in Flutter 3.27 / Dart 3.6).
    // ignore: deprecated_member_use
    final hex = '#${(color.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    return SvgPicture.string(
      body.replaceAll('{c}', hex),
      width: size,
      height: size,
    );
  }

  // ---------------------------------------------------------------------------
  // NAV ICONS  (verbatim from CFNav.dc.html)
  // ---------------------------------------------------------------------------

  /// Home — house outline (CFNav.dc.html)
  static Widget home({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M3 10.5 12 3l9 7.5M5 9.5V20h14V9.5"'
        ' stroke="{c}" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Account — user inside circle (CFNav.dc.html)
  static Widget account({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<circle cx="12" cy="8.5" r="3.4" stroke="{c}" stroke-width="1.9"/>'
        '<path d="M5.5 19.5c0-3.4 2.9-5.6 6.5-5.6s6.5 2.2 6.5 5.6"'
        ' stroke="{c}" stroke-width="1.9" stroke-linecap="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Orders — receipt/bookmark list (CFNav.dc.html)
  static Widget orders({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M5 4h14v16l-3-2-2 2-2-2-2 2-2-2-3 2V4Z"'
        ' stroke="{c}" stroke-width="1.9" stroke-linejoin="round"/>'
        '<path d="M9 9h6M9 12.5h6" stroke="{c}" stroke-width="1.9" stroke-linecap="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Settings — gear / cog (CFNav.dc.html)
  static Widget settings({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<circle cx="12" cy="12" r="3" stroke="{c}" stroke-width="1.9"/>'
        '<path d="M12 2.5v3M12 18.5v3M21.5 12h-3M5.5 12h-3'
        'M18.5 5.5l-2 2M7.5 16.5l-2 2M18.5 18.5l-2-2M7.5 7.5l-2-2"'
        ' stroke="{c}" stroke-width="1.9" stroke-linecap="round"/>'
        '</svg>',
        size,
        color,
      );

  // ---------------------------------------------------------------------------
  // HOME-SERVICE ICONS  (verbatim from CartFly Redesign.dc.html)
  // ---------------------------------------------------------------------------

  /// Warehouses — delivery truck outline
  static Widget warehouses({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M3 7h11v8H3zM14 10h4l3 3v2h-7z"'
        ' stroke="{c}" stroke-width="1.7" stroke-linejoin="round"/>'
        '<circle cx="7" cy="17.5" r="1.8" stroke="{c}" stroke-width="1.7"/>'
        '<circle cx="17.5" cy="17.5" r="1.8" stroke="{c}" stroke-width="1.7"/>'
        '</svg>',
        size,
        color,
      );

  /// Lockers — grid of vertical bars (barcode-locker)
  static Widget lockers({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<rect x="3" y="6" width="18" height="12" rx="2" stroke="{c}" stroke-width="1.6"/>'
        '<path d="M7 9v6M10 9v6M13 9v6M17 9v6"'
        ' stroke="{c}" stroke-width="1.6" stroke-linecap="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Plans — calendar
  static Widget plans({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<rect x="3" y="5" width="18" height="16" rx="2" stroke="{c}" stroke-width="1.7"/>'
        '<path d="M3 9h18M8 3v4M16 3v4" stroke="{c}" stroke-width="1.7" stroke-linecap="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Cart Calculator — shopping cart with circle (camera-bag style)
  static Widget cartCalculator({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M12 3a2 2 0 0 0-2 2H6a2 2 0 0 0-2 2l-1.5 11a2 2 0 0 0 2 2h15'
        'a2 2 0 0 0 2-2L20 7a2 2 0 0 0-2-2h-4a2 2 0 0 0-2-2Z"'
        ' stroke="{c}" stroke-width="1.6" stroke-linejoin="round"/>'
        '<circle cx="12" cy="12" r="3.2" stroke="{c}" stroke-width="1.6"/>'
        '</svg>',
        size,
        color,
      );

  // ---------------------------------------------------------------------------
  // STEPPER ICONS  (verbatim from CartFly Redesign.dc.html)
  // ---------------------------------------------------------------------------

  /// Step: Shopping Bag
  static Widget stepBag({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M6 8h12l-1 12H7L6 8ZM9 8V6a3 3 0 0 1 6 0v2"'
        ' stroke="{c}" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Step: Box / Package
  static Widget stepBox({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M3 8.5 12 4l9 4.5v7L12 20l-9-4.5zM3 8.5 12 13l9-4.5M12 13v7"'
        ' stroke="{c}" stroke-width="1.7" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Step: Truck / Shipping
  static Widget stepTruck({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M3 7h11v8H3zM14 10h4l3 3v2h-7z"'
        ' stroke="{c}" stroke-width="1.7" stroke-linejoin="round"/>'
        '<circle cx="7" cy="17" r="1.8" stroke="{c}" stroke-width="1.7"/>'
        '<circle cx="17.5" cy="17" r="1.8" stroke="{c}" stroke-width="1.7"/>'
        '</svg>',
        size,
        color,
      );

  /// Step: Check / Delivered
  static Widget stepCheck({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M5 12.5 10 17l9-10"'
        ' stroke="{c}" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  // ---------------------------------------------------------------------------
  // TRACKING / BARCODE
  // ---------------------------------------------------------------------------

  /// Barcode — vertical bars inside rectangle
  static Widget barcode({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<rect x="3" y="6" width="18" height="12" rx="2" stroke="{c}" stroke-width="1.6"/>'
        '<path d="M7 9v6M10 9v6M13 9v6M17 9v6"'
        ' stroke="{c}" stroke-width="1.6" stroke-linecap="round"/>'
        '</svg>',
        size,
        color,
      );

  // ---------------------------------------------------------------------------
  // PAYMENT METHOD ICONS
  // ---------------------------------------------------------------------------

  /// Card — credit/debit card with baseline (verbatim from CartFly Redesign.dc.html)
  static Widget card({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<rect x="3" y="5" width="18" height="12" rx="1.6" stroke="{c}" stroke-width="1.7"/>'
        '<path d="M2 20h20" stroke="{c}" stroke-width="1.7" stroke-linecap="round"/>'
        '</svg>',
        size,
        color,
      );

  /// PayPal / Envelope — email envelope (used for PayPal in design)
  static Widget paypal({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M3 7h18v11H3z" stroke="{c}" stroke-width="1.6" stroke-linejoin="round"/>'
        '<path d="M3 7l9 6 9-6" stroke="{c}" stroke-width="1.6" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Apple Pay — apple logo (crafted, consistent stroke style)
  static Widget apple({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M16 3c.2 1.5-.5 2.9-1.4 3.8-.9 1-2.3 1.7-3.5 1.6'
        '-.2-1.4.5-2.9 1.3-3.8C13.3 3.6 14.9 3 16 3Z"'
        ' fill="{c}"/>'
        '<path d="M19 17.5c-.5 1.2-1.1 2.3-2 3.3-.8.9-1.4 1.2-2.3 1.2'
        '-.9 0-1.2-.5-2.2-.5s-1.4.5-2.3.5c-.9 0-1.6-.4-2.4-1.3'
        '-1.7-2-3.1-5.2-3.1-7.7 0-3.2 2.2-4.8 4.3-4.8 1 0 1.9.5 2.6.5'
        '.7 0 1.7-.6 2.9-.6 1.2 0 2.4.5 3.2 1.5-2.8 1.7-2.3 5.4.3 6.9Z"'
        ' stroke="{c}" stroke-width="1.6" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  // ---------------------------------------------------------------------------
  // UTILITY ICONS
  // ---------------------------------------------------------------------------

  /// Copy — stacked pages (verbatim from CartFly Redesign.dc.html)
  static Widget copy({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<rect x="9" y="9" width="11" height="11" rx="2" stroke="{c}" stroke-width="1.7"/>'
        '<path d="M5 15V5a2 2 0 0 1 2-2h8" stroke="{c}" stroke-width="1.7" stroke-linecap="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Chevron Right (verbatim from CartFly Redesign.dc.html)
  static Widget chevronRight({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="m9 5 7 7-7 7" stroke="{c}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Chevron Left (verbatim from CartFly Redesign.dc.html)
  static Widget chevronLeft({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="m15 5-7 7 7 7" stroke="{c}" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Chevron Up (verbatim — rotated chevron-down from CartFly Redesign.dc.html)
  static Widget chevronUp({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="m18 15-6-6-6 6" stroke="{c}" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Chevron Down (verbatim from CartFly Redesign.dc.html)
  static Widget chevronDown({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="m6 9 6 6 6-6" stroke="{c}" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Location Pin (verbatim from CartFly Redesign.dc.html)
  static Widget pin({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M12 21s7-5.6 7-11a7 7 0 1 0-14 0c0 5.4 7 11 7 11Z"'
        ' stroke="{c}" stroke-width="1.7" stroke-linejoin="round"/>'
        '<circle cx="12" cy="10" r="2.3" stroke="{c}" stroke-width="1.7"/>'
        '</svg>',
        size,
        color,
      );

  /// Globe with pin (verbatim from CartFly Redesign.dc.html)
  static Widget globe({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<circle cx="11" cy="11" r="8" stroke="{c}" stroke-width="1.6"/>'
        '<path d="M3 11h16M11 3c2.2 2.2 2.2 13.8 0 16M11 3c-2.2 2.2-2.2 13.8 0 16"'
        ' stroke="{c}" stroke-width="1.4"/>'
        '<path d="M19 15s2 2 2 3.5S19 22 19 22s-2-2-2-3.5S19 15 19 15Z"'
        ' stroke="{c}" stroke-width="1.6" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Star — 5-pointed star (crafted, consistent stroke style)
  static Widget star({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77'
        'l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2Z"'
        ' stroke="{c}" stroke-width="1.7" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Plus / Add (verbatim from CartFly Redesign.dc.html)
  static Widget plus({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M12 5v14M5 12h14" stroke="{c}" stroke-width="2.2" stroke-linecap="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Sign Out / Exit (verbatim from CartFly Redesign.dc.html)
  static Widget signOut({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M15 4h3a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1h-3M10 8 6 12l4 4M6 12h11"'
        ' stroke="{c}" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Bell / Notification (verbatim from CartFly Redesign.dc.html)
  static Widget bell({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M6 9a6 6 0 0 1 12 0c0 5 2 6 2 6H4s2-1 2-6Z"'
        ' stroke="{c}" stroke-width="1.7" stroke-linejoin="round"/>'
        '<path d="M10 19a2 2 0 0 0 4 0" stroke="{c}" stroke-width="1.7" stroke-linecap="round"/>'
        '</svg>',
        size,
        color,
      );

  // ---------------------------------------------------------------------------
  // EXTRA ICONS
  // ---------------------------------------------------------------------------

  /// Home (residential building with door) — stepper variant
  static Widget homeBuilding({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M3 9.5 12 4l9 5.5M5 9v9h14V9M9 18v-5h6v5"'
        ' stroke="{c}" stroke-width="1.6" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Eye / Visibility
  static Widget eye({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7Z"'
        ' stroke="{c}" stroke-width="1.7"/>'
        '<circle cx="12" cy="12" r="2.6" stroke="{c}" stroke-width="1.7"/>'
        '</svg>',
        size,
        color,
      );

  /// Arrow Right (inline/row)
  static Widget arrowRight({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 14" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<path d="M1 7h20m-5-5 5 5-5 5" stroke="{c}" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Lock / Padlock
  static Widget lock({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<rect x="5" y="11" width="14" height="9" rx="2" stroke="{c}" stroke-width="1.7"/>'
        '<path d="M8 11V8a4 4 0 0 1 8 0v3" stroke="{c}" stroke-width="1.7" stroke-linecap="round"/>'
        '</svg>',
        size,
        color,
      );

  /// Card (simple rectangle + line — credit card variant)
  static Widget cardSimple({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg(
        '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">'
        '<rect x="3" y="6" width="18" height="13" rx="2" stroke="{c}" stroke-width="1.6"/>'
        '<path d="M3 10h18" stroke="{c}" stroke-width="1.6"/>'
        '</svg>',
        size,
        color,
      );
}
