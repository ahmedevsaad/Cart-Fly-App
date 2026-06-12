import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../l10n/auth_error.dart';
import '../../router/routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_input.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_email.text.trim(), _password.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (!ok) _error = authErrorText(auth.errorKey);
    });
    // success → router redirect navigates to /home automatically
  }

  @override
  Widget build(BuildContext context) {
    return CfScaffold(
      topBar: CfTopBar(onBack: () => context.pop()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  // Avatar icon
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.chipBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: _UserIcon(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Welcome back',
                      style: AppText.title.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      'Sign in to continue to CartFly.',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CfInput(
                    label: 'Email:',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CfInput(
                    label: 'Password:',
                    controller: _password,
                    obscure: true,
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: GestureDetector(
                      onTap: () => context.push(Routes.forgot),
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: AppText.caption.copyWith(color: AppColors.danger),
                    ),
                  ],
                  const SizedBox(height: 8),
                  CfButton(
                    label: _busy ? '...' : 'Login',
                    onPressed: _busy ? null : _submit,
                  ),
                ],
              ),
            ),
            // "Don't have an account? Register" pinned at bottom
            Semantics(
              button: true,
              label: 'Register — create a new account',
              child: InkWell(
                onTap: () => context.push(Routes.register),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.muted,
                        ),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Register',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserIcon extends StatelessWidget {
  const _UserIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(36, 36),
      painter: _UserIconPainter(),
    );
  }
}

class _UserIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const strokeColor = AppColors.navyLabel;
    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final s = size.width / 24;
    // Circle head: cx=12 cy=8.5 r=3.6
    canvas.drawCircle(Offset(12 * s, 8.5 * s), 3.6 * s, paint);
    // Shoulders arc: M5.5 19.5 c0-3.6 2.9-5.8 6.5-5.8 s6.5 2.2 6.5 5.8
    final path = Path()
      ..moveTo(5.5 * s, 19.5 * s)
      ..cubicTo(
        5.5 * s, 15.9 * s,
        8.4 * s, 13.7 * s,
        12 * s,  13.7 * s,
      )
      ..cubicTo(
        15.6 * s, 13.7 * s,
        18.5 * s, 15.9 * s,
        18.5 * s, 19.5 * s,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
