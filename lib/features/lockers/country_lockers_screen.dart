import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';

import '../../data/lockers.dart';
import '../../data/models/locker.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/colors.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/flag_icon.dart';

class CountryLockersScreen extends StatefulWidget {
  const CountryLockersScreen({super.key, required this.code});
  final String code;

  @override
  State<CountryLockersScreen> createState() => _CountryLockersScreenState();
}

class _CountryLockersScreenState extends State<CountryLockersScreen> {
  final _map = MapController();
  final Map<String, GlobalKey> _itemKeys = {};
  String? _highlight;

  String _key(Locker l) => '${l.name}|${l.spot}';

  void _focus(Locker l) {
    setState(() => _highlight = _key(l));
    _map.move(l.coord, 14);
    final k = _itemKeys[_key(l)];
    if (k?.currentContext != null) {
      Scrollable.ensureVisible(
        k!.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.2,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final c = lockersByCode(widget.code);
    final allLockers = [for (final ct in c.cities) ...ct.lockers];

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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlagIcon(code: c.code, size: 36),
                  const SizedBox(width: 10),
                  Text(
                    c.displayName,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 280,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    mapController: _map,
                    options: MapOptions(
                      initialCenter: c.center,
                      initialZoom: c.zoom,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.cartfly.app',
                      ),
                      MarkerLayer(markers: [
                        for (final l in allLockers)
                          Marker(
                            point: l.coord,
                            width: 36,
                            height: 36,
                            child: GestureDetector(
                              onTap: () => _focus(l),
                              child: Icon(
                                Icons.location_on,
                                color: _highlight == _key(l)
                                    ? AppColors.primary
                                    : AppColors.border,
                                size: 32,
                              ),
                            ),
                          ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                children: [
                  for (final ct in c.cities) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 6),
                      child: Text(
                        ct.city,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    for (final l in ct.lockers)
                      Container(
                        key: _itemKeys.putIfAbsent(
                            _key(l), () => GlobalKey()),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _highlight == _key(l)
                              ? AppColors.bgBlue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.border, width: 1),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text('${l.name} – ${l.spot}'),
                          onTap: () => _focus(l),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
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
