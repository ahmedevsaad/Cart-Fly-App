import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../data/lockers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/cf_scaffold.dart';
import '../../widgets/cf_top_bar.dart';

class CountryLockersScreen extends StatelessWidget {
  const CountryLockersScreen({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final country = lockersByCode(code);

    final allMarkers = <Marker>[
      for (final city in country.cities)
        for (final l in city.lockers)
          Marker(
            point: l.coord,
            width: 40,
            height: 40,
            child: const Icon(Icons.location_pin, color: AppColors.primary),
          ),
    ];

    return CfScaffold(
      topBar: const CfTopBar(showBack: true),
      body: Column(
        children: [
          Text(
            country.displayName,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 260,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: country.center,
                initialZoom: country.zoom,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.cartfly',
                ),
                MarkerLayer(markers: allMarkers),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                for (final city in country.cities) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      city.city,
                      style: AppText.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  for (final l in city.lockers)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${l.name} – ${l.spot}',
                              style: AppText.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
