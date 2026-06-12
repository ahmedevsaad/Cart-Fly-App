import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CfBottomNav extends StatelessWidget {
  const CfBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// 0 = Home, 1 = Account, 2 = Orders, 3 = Settings
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _navShadow = BoxShadow(
    color: Color(0x210F172A), // rgba(15,23,42,0.13)
    blurRadius: 26,
    offset: Offset(0, 8),
  );

  static const _items = [
    _NavItem(
      label: 'Home',
      svgBody: '''<svg width="21" height="21" viewBox="0 0 24 24" fill="none"><path d="M3 10.5 12 3l9 7.5M5 9.5V20h14V9.5" stroke="{{color}}" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"/></svg>''',
    ),
    _NavItem(
      label: 'Account',
      svgBody: '''<svg width="21" height="21" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="8.5" r="3.4" stroke="{{color}}" stroke-width="1.9"/><path d="M5.5 19.5c0-3.4 2.9-5.6 6.5-5.6s6.5 2.2 6.5 5.6" stroke="{{color}}" stroke-width="1.9" stroke-linecap="round"/></svg>''',
    ),
    _NavItem(
      label: 'Orders',
      svgBody: '''<svg width="21" height="21" viewBox="0 0 24 24" fill="none"><path d="M5 4h14v16l-3-2-2 2-2-2-2 2-2-2-3 2V4Z" stroke="{{color}}" stroke-width="1.9" stroke-linejoin="round"/><path d="M9 9h6M9 12.5h6" stroke="{{color}}" stroke-width="1.9" stroke-linecap="round"/></svg>''',
    ),
    _NavItem(
      label: 'Settings',
      svgBody: '''<svg width="21" height="21" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="12" r="3" stroke="{{color}}" stroke-width="1.9"/><path d="M12 2.5v3M12 18.5v3M21.5 12h-3M5.5 12h-3M18.5 5.5l-2 2M7.5 16.5l-2 2M18.5 18.5l-2-2M7.5 7.5l-2-2" stroke="{{color}}" stroke-width="1.9" stroke-linecap="round"/></svg>''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [_navShadow],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < _items.length; i++)
            _buildItem(i, _items[i]),
        ],
      ),
    );
  }

  Widget _buildItem(int index, _NavItem item) {
    final active = index == currentIndex;
    final color = active ? Colors.white : AppColors.navIdle;
    final colorHex = active ? '#FFFFFF' : '#7E8AA0';
    final svg = item.svgBody.replaceAll('{{color}}', colorHex);

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.string(svg, width: 21, height: 21),
            if (active) ...[
              const SizedBox(width: 7),
              Text(
                item.label,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.label, required this.svgBody});
  final String label;
  final String svgBody;
}
