import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_text.dart';

class CfTopBar extends StatelessWidget implements PreferredSizeWidget {
  const CfTopBar({super.key, this.showBack = true, this.onBack});
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: Directionality.of(context) == TextDirection.rtl
                  ? Transform.flip(
                      flipX: true,
                      child: SvgPicture.asset('assets/icons/chevron-back.svg',
                          width: 24, height: 24),
                    )
                  : SvgPicture.asset('assets/icons/chevron-back.svg',
                      width: 24, height: 24),
            )
          : null,
      centerTitle: true,
      title: Text('CartFly', style: AppText.logo),
    );
  }
}
