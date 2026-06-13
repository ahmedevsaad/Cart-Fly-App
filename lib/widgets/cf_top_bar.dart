import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_text.dart';
import 'icons/cf_icons.dart';

/// AppBar with centred Playfair "CartFly" logo and optional back chevron.
///
/// Back chevron uses [CfIcons.chevronLeft]; RTL-aware via [Directionality].
/// Stable public API: [showBack], [onBack].
class CfTopBar extends StatelessWidget implements PreferredSizeWidget {
  const CfTopBar({super.key, this.showBack = true, this.onBack});
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: isRtl
                  ? CfIcons.chevronRight(size: 24)
                  : CfIcons.chevronLeft(size: 24),
            )
          : null,
      centerTitle: true,
      title: Text(AppLocalizations.of(context)!.appTitle, style: AppText.logo),
    );
  }
}
