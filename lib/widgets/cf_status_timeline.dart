import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class CfStatusTimeline extends StatelessWidget {
  const CfStatusTimeline({super.key, required this.steps, required this.activeIndex});
  final List<String> steps;       // e.g. ['Waiting','At warehouse',...]
  final int activeIndex;          // 0-based; steps up to & including are 'done'

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Row(
            children: [
              Icon(i <= activeIndex ? Icons.check_circle : Icons.circle_outlined,
                  color: i <= activeIndex ? AppColors.primary : AppColors.muted),
              const SizedBox(width: 10),
              Text(steps[i], style: AppText.body),
            ],
          ),
          if (i < steps.length - 1)
            const Padding(
              padding: EdgeInsetsDirectional.only(start: 11),
              child: SizedBox(height: 20, child: VerticalDivider(width: 2)),
            ),
        ],
      ],
    );
  }
}
