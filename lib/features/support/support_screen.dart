import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../widgets/cf_journey_nav.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      bottomNav: cfJourneyNav(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
        children: [
          // Page title
          Text(
            l.supportIssueTitle,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),

          // Body card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.fieldBg,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppColors.shadowSoft,
            ),
            child: Text(
              l.supportIssueBody,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                height: 1.6,
                color: AppColors.text,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Contact card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.fieldBg,
              borderRadius: BorderRadius.circular(AppColors.radiusCard),
              boxShadow: AppColors.shadowSoft,
            ),
            child: Column(
              children: [
                Text(
                  l.supportContactLabel,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  l.supportContactEmail,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
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
