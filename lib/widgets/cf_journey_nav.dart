import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../router/routes.dart';
import 'cf_bottom_nav.dart';

/// Floating nav for pushed journey screens. Highlights a tab, navigates on tap.
Widget cfJourneyNav(BuildContext context) {
  final loc = GoRouterState.of(context).matchedLocation;
  int index;
  if (loc.startsWith('/orders')) {
    index = 2;
  } else if (loc.startsWith('/profile')) {
    index = 1;
  } else if (loc.startsWith('/settings') ||
      loc == Routes.about ||
      loc == Routes.support ||
      loc == Routes.policy) {
    // About / Support / Policy are reached from Settings — highlight that tab.
    index = 3;
  } else {
    index = 0;
  }
  const tabRoutes = [Routes.home, Routes.profile, Routes.orders, Routes.settings];
  return CfBottomNav(
    currentIndex: index,
    onTap: (i) => context.go(tabRoutes[i]),
  );
}
