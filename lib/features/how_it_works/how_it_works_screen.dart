import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/how_it_works.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_background.dart';
import '../../widgets/app_logo.dart';

class HowItWorksScreen extends StatefulWidget {
  const HowItWorksScreen({super.key});

  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen> {
  final _ctrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final pages = isAr ? howItWorksAr : howItWorksEn;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
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
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) => SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(children: [
                      const SizedBox(height: 16),
                      Text(
                        pages[i].heading,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(pages[i].body, textAlign: TextAlign.center),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_page < pages.length - 1) {
                        _ctrl.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.pop();
                      }
                    },
                    child: Text(_page < pages.length - 1 ? t.next : t.back),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
