import 'package:flutter/material.dart';
import '../theme/app_text.dart';
import 'icons/cf_icons.dart';

/// Single tappable row with a label and a trailing chevron / arrow icon.
///
/// RTL-aware: uses chevronLeft (mirrored) in RTL, chevronRight in LTR.
/// Stable public API: [label], [onTap].
class CfListRow extends StatelessWidget {
  const CfListRow({super.key, required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppText.bodyMedium)),
            isRtl
                ? CfIcons.chevronLeft(size: 24)
                : CfIcons.chevronRight(size: 24),
          ],
        ),
      ),
    );
  }
}
