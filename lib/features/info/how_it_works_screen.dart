import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../router/routes.dart';
import '../../state/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_button.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  // Steps verbatim from frame 04 of the design
  static const _stepsEn = <_HowStep>[
    _HowStep(
      title: 'Choose a warehouse',
      body: "Pick the country you're shopping from and copy your CartFly address.",
    ),
    _HowStep(
      title: 'Shop & ship to us',
      body: 'Buy from any store and send the package to that address.',
    ),
    _HowStep(
      title: 'We forward it',
      body: 'Calculate the cost, then we ship it to your door.',
    ),
    _HowStep(
      title: 'Confirm your order',
      body: 'Open Order Confirmation and enter your order number, name and phone. It appears as Pending.',
    ),
    _HowStep(
      title: 'Warehouse arrival & final payment',
      body: 'We notify you, calculate customs, taxes & shipping, then deliver to your doorstep.',
    ),
  ];

  static const _stepsAr = <_HowStep>[
    _HowStep(
      title: 'اختر مستودعاً',
      body: 'اختر الدولة التي تتسوق منها وانسخ عنوان كارت فلاي الخاص بك.',
    ),
    _HowStep(
      title: 'تسوّق وأرسل إلينا',
      body: 'اشترِ من أي متجر وأرسل الطرد إلى ذلك العنوان.',
    ),
    _HowStep(
      title: 'نحن نُعيد شحنه',
      body: 'نحسب التكلفة ثم نشحنه إلى بابك.',
    ),
    _HowStep(
      title: 'تأكيد طلبك',
      body: 'افتح تأكيد الطلب وأدخل رقم طلبك واسمك وهاتفك. سيظهر بحالة "قيد الانتظار".',
    ),
    _HowStep(
      title: 'وصول المستودع والدفع النهائي',
      body: 'نُعلمك ونحسب الجمارك والضرائب والشحن، ثم نوصّله إلى بابك.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().locale;
    final steps =
        locale.languageCode == 'ar' ? _stepsAr : _stepsEn;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'How CartFly works?',
                    textAlign: TextAlign.center,
                    style: AppText.title.copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.fieldBg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        for (int i = 0; i < steps.length; i++) ...[
                          if (i > 0) const SizedBox(height: 13),
                          _StepRow(number: i + 1, step: steps[i]),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
            child: CfButton(
              label: 'Next',
              onPressed: () => context.canPop() ? context.pop() : context.go(Routes.home),
            ),
          ),
        ],
      ),
    );
  }
}

class _HowStep {
  const _HowStep({required this.title, required this.body});
  final String title;
  final String body;
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.step});
  final int number;
  final _HowStep step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Numbered circle
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Title + body
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                step.body,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
