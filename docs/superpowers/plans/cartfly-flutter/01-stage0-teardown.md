# Stage 0 — Teardown & Scaffolding

**Goal:** Remove the old UI, keep the foundation, leave the app compiling to a minimal blank screen. No features yet.

**Prereq:** none (first stage).

**Files:**
- Delete: `lib/theme/colors.dart`, `lib/theme/text_theme.dart`, `lib/theme/app_theme.dart`, all of `lib/widgets/*`, every `lib/features/**/*_screen.dart`, `lib/router/app_router.dart` (rewritten later).
- Keep: `lib/main.dart`, `lib/firebase_options.dart`, `lib/features/auth/auth_provider.dart`, `lib/app/locale_provider.dart`, all `lib/data/**`, all `lib/l10n/**`, `lib/router/routes.dart`.
- Modify: `lib/app.dart` (temporary minimal app).

---

### Task 0.1: Delete old UI files

- [ ] **Step 1: Remove old theme, widgets, screens, router**

```bash
cd w:/cart-fly
rm lib/theme/colors.dart lib/theme/text_theme.dart lib/theme/app_theme.dart
rm -r lib/widgets
rm lib/features/splash/splash_screen.dart lib/features/welcome/welcome_screen.dart lib/features/home/home_screen.dart
rm lib/features/warehouses/warehouses_screen.dart lib/features/warehouses/warehouse_detail_screen.dart
rm lib/features/lockers/lockers_world_screen.dart lib/features/lockers/country_lockers_screen.dart
rm lib/features/how_it_works/how_it_works_screen.dart lib/features/support/support_screen.dart
rm lib/features/auth/login_screen.dart lib/features/auth/register_screen.dart lib/features/auth/otp_screen.dart lib/features/auth/forgot_password_screen.dart
rm lib/router/app_router.dart
```

- [ ] **Step 2: Confirm kept files still present**

Run: `ls lib/features/auth/ lib/data/models/ lib/app/`
Expected: `auth_provider.dart` present; models present; `locale_provider.dart` present.

### Task 0.2: Temporary minimal `app.dart`

- [ ] **Step 1: Replace `lib/app.dart` with a minimal app** (no router, no theme yet — just proves the app boots after teardown)

```dart
import 'package:flutter/material.dart';

class CartFlyApp extends StatelessWidget {
  const CartFlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CartFly',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('CartFly — rebuilding')),
      ),
    );
  }
}
```

- [ ] **Step 2: Analyze**

Run: `flutter analyze`
Expected: **No issues found!** (If analyzer complains about unused imports in kept files, leave kept files unchanged — they should be clean.)

- [ ] **Step 3: Run the app**

Run: `flutter run -d chrome`
Expected: a white screen reading "CartFly — rebuilding". Firebase still initializes in `main.dart` without error.

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "chore(stage0): teardown old UI, keep foundation, minimal app boots"
```

---

## Stage exit check
- `flutter analyze` → No issues found.
- App launches to the placeholder screen on web.
- Kept files intact: `auth_provider.dart`, `data/**`, `l10n/**`, `locale_provider.dart`, `firebase_options.dart`, `main.dart`, `router/routes.dart`.
