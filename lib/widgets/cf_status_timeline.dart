import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CfStatusTimeline extends StatelessWidget {
  const CfStatusTimeline({
    super.key,
    required this.steps,
    required this.activeIndex,
  });

  /// Step labels, e.g. ['Waiting', 'At warehouse', 'Shipped', 'Delivered'].
  final List<String> steps;

  /// 0-based index; steps up to & including this are considered active/done.
  final int activeIndex;

  static const double _circleSize = 28.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                // Circle row with connector lines via Stack
                SizedBox(
                  height: _circleSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Left connector
                      if (i > 0)
                        Positioned(
                          left: 0,
                          right: _circleSize / 2,
                          child: Container(
                            height: 2,
                            color: i <= activeIndex
                                ? AppColors.primary
                                : AppColors.cardBorder,
                          ),
                        ),
                      // Right connector
                      if (i < steps.length - 1)
                        Positioned(
                          left: _circleSize / 2,
                          right: 0,
                          child: Container(
                            height: 2,
                            color: i < activeIndex
                                ? AppColors.primary
                                : AppColors.cardBorder,
                          ),
                        ),
                      // Circle
                      Container(
                        width: _circleSize,
                        height: _circleSize,
                        decoration: BoxDecoration(
                          color: i <= activeIndex
                              ? AppColors.primary
                              : AppColors.fieldBg,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${i + 1}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: i <= activeIndex
                                ? Colors.white
                                : AppColors.mutedDisabled,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Label
                Text(
                  steps[i],
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: i <= activeIndex
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: i <= activeIndex
                        ? AppColors.text
                        : AppColors.mutedDisabled,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
