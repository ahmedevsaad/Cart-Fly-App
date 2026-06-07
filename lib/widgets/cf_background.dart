import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

/// Faint tiled airplane/box watermark. Pass [solid] for a flat color (splash).
class CfBackground extends StatelessWidget {
  const CfBackground({super.key, required this.child, this.solid});
  final Widget child;
  final Color? solid;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: solid ?? AppColors.bgPage,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (solid == null)
            IgnorePointer(
              child: LayoutBuilder(builder: (context, c) {
                const tile = 240.0;
                final cols = (c.maxWidth / tile).ceil();
                final rows = (c.maxHeight / tile).ceil();
                return Wrap(
                  children: List.generate(
                    cols * rows,
                    (_) => SizedBox(
                      width: tile, height: tile,
                      child: SvgPicture.asset('assets/pattern/airplane_box.svg'),
                    ),
                  ),
                );
              }),
            ),
          child,
        ],
      ),
    );
  }
}
