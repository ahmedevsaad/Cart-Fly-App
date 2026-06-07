import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_provider.dart';
import '../features/home/home_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/menu/menu_screen.dart';
import '../features/settings/settings_screen.dart';
import '../widgets/cf_bottom_nav.dart';
import 'routes.dart';

const _bypassAuth = bool.fromEnvironment('DEBUG_BYPASS_AUTH');

GoRouter buildRouter(AuthProvider auth) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: auth,
    redirect: (ctx, state) {
      final loc = state.matchedLocation;

      if (_bypassAuth) {
        // In debug bypass mode, redirect '/' to '/home' so the shell loads.
        if (loc == Routes.splash) return Routes.home;
        return null;
      }

      final s = auth.state.status;
      const public = {Routes.splash, Routes.login, Routes.register, Routes.forgot};
      if (s == AuthStatus.loading) return loc == Routes.splash ? null : Routes.splash;
      if (s == AuthStatus.pendingOtp) return loc == Routes.verify ? null : Routes.verify;
      if (s == AuthStatus.unauthenticated) return public.contains(loc) ? null : Routes.login;
      if (public.contains(loc) || loc == Routes.verify) return Routes.home;
      return null;
    },
    routes: [
      // --- auth & full-screen routes (Stage 4+) registered here as added ---
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) => _ShellScaffold(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.profile, builder: (_, __) => const ProfileScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.menu, builder: (_, __) => const MenuScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.settings, builder: (_, __) => const SettingsScreen()),
          ]),
        ],
      ),
    ],
  );
}

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: CfBottomNav(
        currentIndex: shell.currentIndex,
        onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}
