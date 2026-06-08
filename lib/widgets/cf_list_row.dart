import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_text.dart';

class CfListRow extends StatelessWidget {
  const CfListRow({super.key, required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppText.bodyMedium)),
            Directionality.of(context) == TextDirection.rtl
                ? Transform.flip(
                    flipX: true,
                    child: SvgPicture.asset('assets/icons/arrow-right-circle.svg',
                        width: 24, height: 24),
                  )
                : SvgPicture.asset('assets/icons/arrow-right-circle.svg',
                    width: 24, height: 24),
          ],
        ),
      ),
    );
  }
}
