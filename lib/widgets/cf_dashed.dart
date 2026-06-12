import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A horizontal dashed line drawn via [CustomPaint].
///
/// Drop-in replacement for a solid [Divider] where the design calls for a
/// dashed separator (e.g. receipt rows, total separator).
class CfDashedDivider extends StatelessWidget {
  const CfDashedDivider({
    super.key,
    Color? color,
    this.dashWidth = 4.0,
    this.gap = 3.0,
    this.thickness = 1.0,
  }) : color = color ?? AppColors.dashedDivider;

  final Color color;
  final double dashWidth;
  final double gap;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: thickness,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: color,
          dashWidth: dashWidth,
          gap: gap,
          thickness: thickness,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.gap,
    required this.thickness,
  });

  final Color color;
  final double dashWidth;
  final double gap;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    double startX = 0;
    final y = size.height / 2;
    while (startX < size.width) {
      final endX = (startX + dashWidth).clamp(0.0, size.width);
      canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
      startX += dashWidth + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter old) =>
      old.color != color ||
      old.dashWidth != dashWidth ||
      old.gap != gap ||
      old.thickness != thickness;
}

/// A [CustomPainter] that draws a dashed rectangular border.
///
/// Attach via [CustomPaint] wrapping the child:
/// ```dart
/// CustomPaint(
///   painter: CfDashedBorderPainter(color: AppColors.radioIdle, radius: 12),
///   child: myWidget,
/// )
/// ```
class CfDashedBorderPainter extends CustomPainter {
  const CfDashedBorderPainter({
    required this.color,
    this.dashWidth = 5.0,
    this.gap = 3.0,
    this.strokeWidth = 1.5,
    this.radius = 0.0,
  });

  final Color color;
  final double dashWidth;
  final double gap;
  final double strokeWidth;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final len = draw ? dashWidth : gap;
        if (draw) {
          final extracted = metric.extractPath(
            distance,
            (distance + len).clamp(0, metric.length),
          );
          canvas.drawPath(extracted, paint);
        }
        distance += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CfDashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.gap != gap ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.radius != radius;
}
