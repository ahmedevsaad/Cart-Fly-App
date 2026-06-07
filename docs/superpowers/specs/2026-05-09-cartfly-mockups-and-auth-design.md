# CartFly — Mockup Screens + Auth Flow

**Date:** 2026-05-09
**Scope:** Replicate the 14 screens from `screenshots/` with a working email/password + OTP + password-reset auth flow on top of Firebase. Bilingual (EN + AR/RTL). Targets Android, iOS, Web.

This is a university project. Out of scope for this spec: cart cost calculator, customs/HS engine, wallet, order tracking, subscriptions, notifications, browser-extension widget. Those become later specs.

---

## 1. Stack

- Flutter 3.27 (current SDK), Dart 3.6
- **State:** `provider` (`ChangeNotifier`)
- **Routing:** `go_router` with auth redirect
- **Backend:** Firebase Auth + Cloud Firestore (user profile only)
- **Maps:** `flutter_map` + OpenStreetMap tiles, `latlong2`
- **i18n:** `flutter_localizations` + `intl` + ARB files
- **Fonts:** `google_fonts` — DM Serif Display (logo / display), Inter (body EN), Cairo (body AR)
- **SVG:** `flutter_svg` for the airplane/box background pattern

## 2. Folder Layout

```
lib/
  main.dart                  Firebase init, runApp(CartFlyApp())
  app.dart                   MaterialApp.router, theme, locale, providers
  theme/
    colors.dart
    text_theme.dart
    app_theme.dart           builds light theme
  l10n/
    app_en.arb
    app_ar.arb
  router/
    app_router.dart          GoRouter + redirect
    routes.dart              route name constants
  data/
    models/
      app_user.dart
      warehouse.dart
      locker.dart
      website_ref.dart
    warehouses.dart          static list of 5 warehouses
    lockers.dart             5 CountryLockers entries (cities + lockers + lat/lng — addresses supplied by user)
    how_it_works.dart        step text per locale
  features/
    auth/
      auth_provider.dart
      login_screen.dart
      register_screen.dart
      otp_screen.dart
      forgot_password_screen.dart
    splash/splash_screen.dart
    welcome/welcome_screen.dart
    home/home_screen.dart
    warehouses/
      warehouses_screen.dart
      warehouse_detail_screen.dart
    lockers/
      lockers_world_screen.dart
      country_lockers_screen.dart
    how_it_works/how_it_works_screen.dart
    support/support_screen.dart
  widgets/
    app_background.dart      airplane/box pattern bg
    app_logo.dart
    primary_button.dart
    outline_button.dart
    labeled_text_field.dart
    country_card.dart
    menu_button.dart
    section_drawer.dart      hamburger menu (lang/currency/profile/logout)
assets/
  flags/    sa.png eg.png ae.png us.png cn.png
  maps/     world.png  (kept as decorative only — real maps are flutter_map)
  pattern/  airplane_box.svg
  fonts/    (only if not using google_fonts cache)
```

## 3. Theme

### Colors (`theme/colors.dart`)

| Token | Hex | Use |
|---|---|---|
| `bgBlue` | `#DCE7FF` | splash bg |
| `bgSoft` | `#F4F7FF` | content pages bg |
| `primary` | `#3B5EE3` | logo, headings, link text |
| `primaryButton` | `#8FA8E8` | filled buttons |
| `border` | `#1B2C7A` | input borders, outlined buttons |
| `text` | `#0B0B0B` | body text |
| `muted` | `#6B6B6B` | captions |

### Typography

- Display (logo, screen titles like "Login", "Register"): DM Serif Display, italic where mockup shows italic
- Body EN: Inter regular / medium / semibold
- Body AR: Cairo regular / medium / bold
- Sizes: display 56 / title 28 / heading 20 / body 16 / caption 13

### Background pattern

`AppBackground` — `Stack` with `bgSoft` color and a tiled SVG (airplane + box silhouettes) at ~8 % opacity. Used on every auth screen and most info screens. Splash uses `bgBlue` only, no pattern (matches mockup).

## 4. Screens (14)

| Route | Screen | Mockup ref |
|---|---|---|
| `/` | Splash | `7.55.12 PM` |
| `/login` | Login | `7.55.13 PM` |
| `/register` | Register | `7.55.13 PM (1)` |
| `/otp` | OTP verify | new — same style |
| `/forgot` | Forgot password | new — same style |
| `/welcome` | Welcome | `7.55.13 PM (2)` |
| `/home` | Home menu | `7.55.13 PM (3)` |
| `/warehouses` | Warehouses grid | `7.55.13 PM (4)` |
| `/warehouses/:code` | Warehouse detail | `7.55.13 PM (5..7)`, `7.55.14 PM (1)` |
| `/how-it-works` | How it works (2 pages, swipe / Next-Back) | `7.55.14 PM (2..3)` |
| `/lockers` | Locker world | `7.55.14 PM (4)` |
| `/lockers/:code` | Country lockers (map + list) | `7.55.14 PM (5)`, `(6)` composites |
| `/support` | Have an issue | new — simple form |

## 5. Auth Flow

```
Splash ─ Login ─┬─ success ──> Welcome ──> Home
                ├─ Forgot ──> Forgot screen ──> back to Login
                └─ Don't have account ──> Register

Register ──> OTP verify ──> Welcome ──> Home

Home ──> Drawer ──> Logout ──> Login
```

### `AuthProvider` (`ChangeNotifier`)

State:
- `User? firebaseUser`
- `AppUser? profile` (Firestore profile)
- `AuthStatus status` — `loading | authenticated | unauthenticated | pendingOtp`
- `String? errorKey` (i18n key for last error)

Methods:
- `register({name, phone, email, country, currency, password})` — creates auth user, writes Firestore `users/{uid}` doc, calls `sendEmailVerification()`, sets `status = pendingOtp`.
- `verifyOtp()` — reloads `currentUser`, if `emailVerified` then `status = authenticated`. (Note: Firebase email verification is link-based, not 6-digit. We frame it as "we sent you a verification email — tap continue once verified". If user wants real 6-digit codes we'd need Phone Auth or a custom Cloud Function — out of scope.)
- `login(email, password)` — `signInWithEmailAndPassword`, loads profile.
- `resetPassword(email)` — `sendPasswordResetEmail`.
- `logout()` — `signOut`.

Subscribes to `FirebaseAuth.instance.authStateChanges()` in constructor.

### `go_router` redirect

```
if (status == loading)            -> /splash
if (status == pendingOtp)         -> /otp
if (status == unauthenticated)    -> allow /, /login, /register, /forgot; else /login
if (status == authenticated)      -> block /, /login, /register; else allow
```

## 6. Static Data

All free of network calls. Loaded synchronously at app start.

### `Warehouse` (`data/warehouses.dart`) — 5 entries

```dart
class Warehouse {
  final String code;             // sa, eg, ae, us, cn
  final String displayName;      // 'Saudi Arabia'
  final String flagAsset;
  final String bestFor;          // 'Perfumes & Beauty'
  final List<String> whyBuyHere; // bullets from screenshot
  final List<String> categories; // 'Luxury & Arabic perfumes' etc
  final List<WebsiteRef> sites;  // (label, url)
}
```

Content lifted verbatim from screenshots `7.55.13 PM (5..7)` and `(6)`, `7.55.14 PM (1)`.

### `CountryLockers` (`data/lockers.dart`) — 5 entries

```dart
class Locker {
  final String name;        // 'Downtown'
  final String spot;        // 'Dubai Mall'
  final LatLng coord;
  final LockerType type;    // mall | metro | plaza
}
class CityLockers { final String city; final List<Locker> lockers; }
class CountryLockers {
  final String code, displayName;
  final LatLng center; final double zoom;
  final List<CityLockers> cities;
}
```

File ships with the structure populated for the 5 countries and city names visible in screenshots; individual locker rows are stubs with `LatLng(0,0)` and a `// TODO: fill` comment, ready for the user to paste real entries.

### `how_it_works.dart`

Two pages of step text per locale, lifted from `7.55.14 PM (2..3)`.

## 7. Locker Country Screen

`country_lockers_screen.dart`:

- `Column`: top app bar (Back + CartFly + drawer) → country flag + name → `Expanded(map)` → `Expanded(list)`. On tablet/desktop (width > 700): `Row(map, list)` instead.
- Map: `FlutterMap` with OSM tile layer, `MarkerLayer` built from all `Locker.coord` for that country.
- List: scrollable; one section per `CityLockers` with bullets `<name> – <spot>`.
- Tap pin: scrolls list to corresponding locker (using `Scrollable.ensureVisible` + GlobalKeys per item) and opens a `Popup` over the marker.
- Tap list row: animates map camera to the locker via `MapController.move(...)`.

## 8. Localization

- Every UI string keyed in `app_en.arb` and `app_ar.arb`.
- Static dart content (warehouse `whyBuyHere`, `how_it_works` steps) stored as `Map<Locale, T>` and resolved via `Localizations.localeOf(context)`.
- Drawer hosts language toggle: `EN | AR`. Persists to `SharedPreferences` and rebuilds `MaterialApp.locale`.
- RTL is automatic from `Directionality` driven by locale. Test on register form (which has many fields) and warehouse detail (which has bullet lists).

## 9. Drawer (hamburger top-right on home/warehouses)

- Profile (placeholder route, lists name/phone/country/currency from Firestore)
- Language: EN / AR
- Currency: USD / SAR / AED / EGP / CNY (set in Firestore `users/{uid}.currency`)
- Logout

## 10. Out of Scope (deferred specs)

The PDF describes much more. These are not built in this iteration:

- Cart cost calculator
- Customs & HS code engine
- In-app wallet + transaction history
- Order tracking + shipment status notifications
- Subscription plans (Basic/Plus/Pro) + payment
- Smart-address browser extension / floating widget
- Promotional offers / discount codes
- Countries & market insights dashboard
- Delivery options (home vs locker pickup) integration with checkout

Each becomes its own design + plan when scheduled.

## 11. Open Items

- **Locker addresses:** user supplies the per-city locker list with mall names + lat/lng. Spec ships with stubs.
- **Assets:** flag PNGs and the airplane/box pattern SVG need final files. Initial implementation can use the `country_flags` Flutter package and a hand-drawn SVG approximating the pattern.

## 12. Acceptance

- All 14 screens reachable and styled to match screenshots.
- Register → email verification → home works on a real Firebase project.
- Login + forgot password work.
- Locale switch between EN and AR flips all visible text and direction.
- Locker country screens show OSM map with at least the city centers pinned.
- App builds for Android, iOS (when on macOS), and Web.
