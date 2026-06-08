import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/verify_screen.dart';
import '../features/home/home_screen.dart';
import '../features/lockers/country_lockers_screen.dart';
import '../features/lockers/lockers_screen.dart';
import '../features/menu/menu_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shipments/create_shipment_screen.dart';
import '../features/shipments/order_detail_screen.dart';
import '../features/shipments/orders_screen.dart';
import '../features/shipments/track_order_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/warehouses/warehouse_detail_screen.dart';
import '../features/warehouses/warehouses_screen.dart';
import '../features/welcome/welcome_screen.dart';
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
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: Routes.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(path: Routes.verify, builder: (_, __) => const VerifyScreen()),
      GoRoute(path: Routes.forgot, builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: Routes.welcome, builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: Routes.warehouses, builder: (_, __) => const WarehousesScreen()),
      GoRoute(
          path: Routes.warehouseDetail,
          builder: (_, s) => WarehouseDetailScreen(code: s.pathParameters['code']!)),
      GoRoute(path: Routes.lockers, builder: (_, __) => const LockersScreen()),
      GoRoute(
          path: Routes.lockersCountry,
          builder: (_, s) =>
              CountryLockersScreen(code: s.pathParameters['code']!)),
      GoRoute(
          path: Routes.createShipment,
          builder: (_, __) => const CreateShipmentScreen()),
      GoRoute(
          path: Routes.orders,
          builder: (_, __) => const OrdersScreen()),
      GoRoute(
          path: Routes.orderDetail,
          builder: (_, s) =>
              OrderDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(
          path: Routes.trackOrder,
          builder: (_, s) =>
              TrackOrderScreen(id: s.pathParameters['id']!)),
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
