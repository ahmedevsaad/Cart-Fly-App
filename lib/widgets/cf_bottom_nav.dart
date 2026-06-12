import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'icons/cf_icons.dart';

/// Floating 4-tab bottom navigation bar.
///
/// Active tab expands into a labelled blue pill (r15, pad 14x10);
/// idle tabs show icon-only in [AppColors.navIdle].
/// Stable public API: [currentIndex] + [onTap].
class CfBottomNav extends StatelessWidget {
  const CfBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// 0 = Home, 1 = Account, 2 = Orders, 3 = Settings
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _labels = ['Home', 'Account', 'Orders', 'Settings'];

  Widget _icon(int index, bool active) {
    final color = active ? Colors.white : AppColors.navIdle;
    return switch (index) {
      0 => CfIcons.home(size: 21, color: color),
      1 => CfIcons.account(size: 21, color: color),
      2 => CfIcons.orders(size: 21, color: color),
      3 => CfIcons.settings(size: 21, color: color),
      _ => CfIcons.home(size: 21, color: color),
    };
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.navBarBorder),
        boxShadow: AppColors.shadowNav,
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < _labels.length; i++) _buildItem(i),
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    final active = index == currentIndex;

    return Semantics(
      label: _labels[index],
      selected: active,
      button: true,
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _icon(index, active),
              if (active) ...[
                const SizedBox(width: 7),
                Text(
                  _labels[index],
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
