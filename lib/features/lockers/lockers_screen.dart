import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_journey_nav.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';
import '../../widgets/icons/cf_icons.dart';

/// Locker locations list — Frame 12 of CartFly Redesign.
/// Content is verbatim from the design: four locker spots.
class LockersScreen extends StatelessWidget {
  const LockersScreen({super.key});

  static const _lockers = [
    _LockerItem(name: 'Cairo Festival City', sub: 'New Cairo · open 24/7'),
    _LockerItem(name: 'Mall of Arabia', sub: '6th of October · 10am–11pm'),
    _LockerItem(name: 'City Stars', sub: 'Nasr City · 10am–11pm'),
    _LockerItem(
        name: 'San Stefano Grand Plaza', sub: 'Alexandria · 10am–11pm'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      bottomNav: cfJourneyNav(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.ourLockerLocations,
              style: AppText.heading.copyWith(
                  fontWeight: FontWeight.w800, fontSize: 23),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            for (final item in _lockers) ...[
              _LockerCard(item: item),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _LockerItem {
  const _LockerItem({required this.name, required this.sub});
  final String name;
  final String sub;
}

class _LockerCard extends StatelessWidget {
  const _LockerCard({required this.item});
  final _LockerItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.shadowSoft,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          // Pin icon in blue pill
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.chipBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: CfIcons.pin(size: 20, color: AppColors.navy),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppText.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.sub,
                  style: AppText.caption.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.muted),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
