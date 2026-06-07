# CartFly

Cross-border shopping assistant. Flutter app for Android, iOS, Web.

## Stack

Flutter 3.27 / Dart 3.6, Firebase Auth + Firestore, Provider, go_router,
flutter_map (OpenStreetMap), intl/ARB localization (EN + AR with RTL).

## Run

```
flutter pub get
dart pub global activate flutterfire_cli
flutterfire configure                 # writes real lib/firebase_options.dart
flutter run
```

Until `flutterfire configure` is run, `lib/firebase_options.dart` ships a
placeholder. The app builds and the UI navigates, but Firebase calls
(register / login / reset / Firestore writes) won't connect.

## Languages

English and Arabic. Toggle from the home drawer (top-right hamburger).

## Project layout

- `lib/features/<area>` — one folder per screen group
- `lib/data` — static content (warehouses, lockers, how-it-works)
- `lib/widgets` — shared UI (background pattern, logo, buttons, fields, drawer)
- `lib/theme` — palette, typography, theme builder
- `lib/router` — go_router config + auth redirect
- `lib/l10n` — ARB files + generated `app_localizations.dart`

## Out of scope (future specs)

Cart cost calculator, customs/HS engine, in-app wallet, order tracking,
subscription plans, browser extension. See
`docs/superpowers/specs/2026-05-09-cartfly-mockups-and-auth-design.md`.
