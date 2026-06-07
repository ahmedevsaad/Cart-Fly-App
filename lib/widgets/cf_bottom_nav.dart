import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class CfBottomNav extends StatelessWidget {
  const CfBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// 0 = Home, 1 = Profile, 2 = Menu, 3 = Settings
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.navBar,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(0, 'assets/icons/home.svg', 'Home'),
          _item(1, 'assets/icons/account_circle.svg', null),
          _item(2, 'assets/icons/settings.svg', null, isMenu: true),
          _item(3, 'assets/icons/settings.svg', 'Settings'),
        ],
      ),
    );
  }

  Widget _item(int index, String icon, String? label, {bool isMenu = false}) {
    final active = index == currentIndex;
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.black : AppColors.navPill,
          borderRadius: BorderRadius.circular(active ? 8 : 9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: 22,
              height: 22,
              colorFilter: active
                  ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                  : null,
            ),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: AppText.caption.copyWith(
                  color: active ? Colors.white : Colors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
