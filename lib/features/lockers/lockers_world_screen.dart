import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../data/lockers.dart';
import '../../l10n/app_localizations.dart';
import '../../router/routes.dart';
import '../../theme/colors.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/flag_icon.dart';

class LockersWorldScreen extends StatelessWidget {
  const LockersWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(children: [
            Row(children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 28),
                onPressed: () => context.pop(),
              ),
              const Spacer(),
              const AppLogo(size: 24),
              const Spacer(),
              const SizedBox(width: 48),
            ]),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border, width: 1.4),
              ),
              child: Text(
                t.ourLockerLocations,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    options: const MapOptions(
                      initialCenter: LatLng(20, 30),
                      initialZoom: 1.5,
                      interactionOptions: InteractionOptions(
                        flags: InteractiveFlag.pinchZoom |
                            InteractiveFlag.drag,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.cartfly.app',
                      ),
                      MarkerLayer(markers: [
                        for (final c in countryLockers)
                          Marker(
                            point: c.center,
                            width: 44,
                            height: 44,
                            child: GestureDetector(
                              onTap: () => context
                                  .push('${Routes.lockers}/${c.code}'),
                              child: const Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                                size: 36,
                              ),
                            ),
                          ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  for (final c in countryLockers)
                    OutlinedButton(
                      onPressed: () =>
                          context.push('${Routes.lockers}/${c.code}'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(140, 40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FlagIcon(code: c.code, size: 22),
                          const SizedBox(width: 8),
                          Text(c.displayName),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text(t.back),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
