import 'package:go_router/go_router.dart';

import '../features/auth/auth_provider.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/home/home_screen.dart';
import '../features/how_it_works/how_it_works_screen.dart';
import '../features/lockers/country_lockers_screen.dart';
import '../features/lockers/lockers_world_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/support/support_screen.dart';
import '../features/warehouses/warehouse_detail_screen.dart';
import '../features/warehouses/warehouses_screen.dart';
import '../features/welcome/welcome_screen.dart';
import 'routes.dart';

const _bypassAuth = bool.fromEnvironment('DEBUG_BYPASS_AUTH');

GoRouter buildRouter(AuthProvider auth) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: auth,
    redirect: (ctx, state) {
      if (_bypassAuth) return null;
      final s = auth.state.status;
      final loc = state.matchedLocation;
      const publicRoutes = {
        Routes.splash,
        Routes.login,
        Routes.register,
        Routes.forgot,
      };

      if (s == AuthStatus.loading) {
        return loc == Routes.splash ? null : Routes.splash;
      }
      if (s == AuthStatus.pendingOtp) {
        return loc == Routes.otp ? null : Routes.otp;
      }
      if (s == AuthStatus.unauthenticated) {
        return publicRoutes.contains(loc) ? null : Routes.login;
      }
      if (publicRoutes.contains(loc) || loc == Routes.otp) {
        return Routes.home;
      }
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: Routes.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(path: Routes.otp, builder: (_, __) => const OtpScreen()),
      GoRoute(path: Routes.forgot, builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: Routes.welcome, builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
      GoRoute(path: Routes.warehouses, builder: (_, __) => const WarehousesScreen()),
      GoRoute(
        path: Routes.warehouseDetail,
        builder: (_, st) =>
            WarehouseDetailScreen(code: st.pathParameters['code']!),
      ),
      GoRoute(path: Routes.howItWorks, builder: (_, __) => const HowItWorksScreen()),
      GoRoute(path: Routes.lockers, builder: (_, __) => const LockersWorldScreen()),
      GoRoute(
        path: Routes.lockersCountry,
        builder: (_, st) =>
            CountryLockersScreen(code: st.pathParameters['code']!),
      ),
      GoRoute(path: Routes.support, builder: (_, __) => const SupportScreen()),
    ],
  );
}
