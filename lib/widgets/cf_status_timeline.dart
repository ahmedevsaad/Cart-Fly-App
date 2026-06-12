import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'icons/cf_icons.dart';

/// Horizontal step-progress timeline.
///
/// Stable public API:
///   - [steps] — list of label strings
///   - [activeIndex] — 0-based index; steps ≤ activeIndex are done/active
///
/// Connectors are centered on circles via Stack + Positioned (no fixed px).
/// Active circle uses [AppColors.chipBlue] with a per-step [CfIcons] glyph
/// (stepBag/stepBox/stepTruck/stepCheck) when the step count is 4; otherwise
/// falls back to the step number.
/// Idle circle: white fill + [AppColors.radioIdle] border + [AppColors.mutedDisabled] number.
/// Connector active: [AppColors.navyTile], idle: [AppColors.cardBorder].
class CfStatusTimeline extends StatelessWidget {
  const CfStatusTimeline({
    super.key,
    required this.steps,
    required this.activeIndex,
  });

  final List<String> steps;
  final int activeIndex;

  static const double _circleSize = 30.0;

  Widget _circleContent(int i, bool active) {
    if (steps.length == 4) {
      final color = active ? AppColors.primary : AppColors.mutedDisabled;
      return switch (i) {
        0 => CfIcons.stepBag(size: 15, color: color),
        1 => CfIcons.stepBox(size: 15, color: color),
        2 => CfIcons.stepTruck(size: 15, color: color),
        3 => CfIcons.stepCheck(size: 15, color: color),
        _ => _numberText(i, active),
      };
    }
    return _numberText(i, active);
  }

  Widget _numberText(int i, bool active) => Text(
        '${i + 1}',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: active ? AppColors.primary : AppColors.mutedDisabled,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Expanded(
            child: Column(
              children: [
                // Circle row + connector lines via Stack
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
                                ? AppColors.navyTile
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
                                ? AppColors.navyTile
                                : AppColors.cardBorder,
                          ),
                        ),
                      // Circle
                      Container(
                        width: _circleSize,
                        height: _circleSize,
                        decoration: BoxDecoration(
                          color: i <= activeIndex
                              ? AppColors.chipBlue
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: i <= activeIndex
                              ? null
                              : Border.all(
                                  color: AppColors.radioIdle,
                                  width: 1.5,
                                ),
                        ),
                        alignment: Alignment.center,
                        child: _circleContent(i, i <= activeIndex),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Label — wraps naturally inside Expanded
                Text(
                  steps[i],
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: i <= activeIndex
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color:
                        i <= activeIndex ? AppColors.text : AppColors.muted,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
