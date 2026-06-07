import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/warehouses.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_background.dart';
import '../../widgets/flag_icon.dart';

class WarehouseDetailScreen extends StatelessWidget {
  const WarehouseDetailScreen({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final w = warehouseByCode(code);
    final isLocal = w.code == 'eg';
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 24),
                FlagIcon(code: w.code, size: 200),
                const SizedBox(height: 24),
                _Heading(t.bestFor(w.bestFor)),
                _Heading(isLocal ? t.whyBuyLocally : t.whyBuyHere),
                ...w.whyBuyHere.map(_bullet),
                const SizedBox(height: 16),
                _Heading(w.categoriesHeading),
                ...w.categories.map(_bullet),
                const SizedBox(height: 16),
                _Heading(t.bestWebsites),
                ...w.sites.map((s) => _bullet(
                    s.note == null ? s.label : '${s.label} (${s.note})')),
                const SizedBox(height: 24),
                SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text(t.back),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bullet(String s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text('• $s', textAlign: TextAlign.center),
      );
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
}
