import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.text,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-bleed hero image
          Image.asset(
            'assets/images/welcome-hero-redesign.jpg',
            fit: BoxFit.cover,
          ),
          // Content overlay
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo wordmark at top center
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      'CartFly',
                      style: AppText.logo.copyWith(
                        fontSize: 40,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Color(0x662B2B2B),
                            blurRadius: 12,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Bottom content: tagline + CTA
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create shipments, monitor status and manage deliveries from one powerful logistics app.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              color: Color(0x99000000),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Frosted-glass CTA button
                      GestureDetector(
                        onTap: () => context.go(Routes.home),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.66),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 15),
                          child: Row(
                            children: [
                              // Box/shipment icon
                              const _ShipmentIcon(),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tap to create shipment',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Double chevron right
                              const _DoubleChevronIcon(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShipmentIcon extends StatelessWidget {
  const _ShipmentIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(26, 26),
      painter: _ShipmentIconPainter(),
    );
  }
}

class _ShipmentIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final s = size.width / 24;
    // Box shape: M3 8.5 L12 4 L21 8.5 V15.5 L12 20 L3 15.5Z
    final path = Path()
      ..moveTo(3 * s, 8.5 * s)
      ..lineTo(12 * s, 4 * s)
      ..lineTo(21 * s, 8.5 * s)
      ..lineTo(21 * s, 15.5 * s)
      ..lineTo(12 * s, 20 * s)
      ..lineTo(3 * s, 15.5 * s)
      ..close();
    canvas.drawPath(path, paint);
    // Middle line: M3 8.5 L12 13 L21 8.5
    final midPath = Path()
      ..moveTo(3 * s, 8.5 * s)
      ..lineTo(12 * s, 13 * s)
      ..lineTo(21 * s, 8.5 * s);
    canvas.drawPath(midPath, paint);
    // Vertical: M12 13 V20
    final vertPath = Path()
      ..moveTo(12 * s, 13 * s)
      ..lineTo(12 * s, 20 * s);
    canvas.drawPath(vertPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DoubleChevronIcon extends StatelessWidget {
  const _DoubleChevronIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(22, 22),
      painter: _DoubleChevronPainter(),
    );
  }
}

class _DoubleChevronPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final s = size.width / 24;
    // m6 6 l5 6 l-5 6
    final path1 = Path()
      ..moveTo(6 * s, 6 * s)
      ..lineTo(11 * s, 12 * s)
      ..lineTo(6 * s, 18 * s);
    canvas.drawPath(path1, paint);
    // m12 6 l5 6 l-5 6
    final path2 = Path()
      ..moveTo(12 * s, 6 * s)
      ..lineTo(17 * s, 12 * s)
      ..lineTo(12 * s, 18 * s);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
