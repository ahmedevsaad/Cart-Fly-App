# CartFly — Flutter App (functional rebuild) Design

**Date:** 2026-06-07
**Scope:** Rebuild the CartFly Flutter app UI **from scratch** on the new design system (the HTML clone in `html/`), and make it a **functional** app backed by the existing Firebase project. University project — functional but deliberately not over-engineered.

The HTML clone in `html/` is the **visual reference**. The Flutter app is the **living, dynamic implementation** (persistent shell, dynamic bottom bar, reusable themed widgets, data-driven screens) — not 44 static screens.

---

## 1. Decisions (locked)

- **Functional scope:** Core real, rest static.
  - **REAL (Firebase):** auth, user profile, settings (language/currency), shipments/orders (create + track), plan subscription.
  - **STATIC (in-app data):** warehouses, lockers, info pages (about/policy/how-it-works).
  - **SIMULATED:** payment (fake card form → success/error); shipment status progression (demo "advance status").
- **Existing code:** Scrap UI, keep foundation. Delete `lib/features/*`, `lib/theme/*`, `lib/widgets/*`. **Keep:** Firebase setup (`firebase_options.dart`, `main.dart`), `AuthProvider` logic, `data/` models + static data, `l10n/`, `app/locale_provider.dart`.
- **Payment / widget:** Simulated payment. The Shein checkout pages and CartFly browser-widget popups are **excluded** (browser-extension concept, not an app feature).
- **Bottom-nav tabs:** Home / Profile / Menu / Settings (matches the clone), dynamic active-tab highlight.

## 2. Stack (reuse what exists)

- Flutter (SDK ≥3.4), Dart 3.4+
- State: `provider` (ChangeNotifier)
- Routing: `go_router` with **`StatefulShellRoute.indexedStack`**
- Backend: `firebase_core`, `firebase_auth`, `cloud_firestore` (project `cartfly-4382a`)
- Maps: `flutter_map` + OSM, `latlong2`
- i18n: `flutter_localizations` + `intl` + ARB (en/ar), RTL
- Fonts: `google_fonts` (Playfair Display, Inter, Alan Sans, Instrument Serif)
- `flutter_svg`, `country_flags`, `shared_preferences`

No new heavy dependencies required.

## 3. Architecture

### Navigation
`StatefulShellRoute.indexedStack` with 4 branches (Home/Profile/Menu/Settings). A single `CfBottomNav` reads the shell index and highlights the active tab; tabs keep their own stacks/state. Detail & flow screens push on top of the active branch. Auth/splash live outside the shell (no bottom bar).

### State (providers)
- `AuthProvider` — **reuse existing** (register/login/verify/reset/logout, `authStateChanges`).
- `SettingsProvider` — locale (persist via `shared_preferences`, exists as `LocaleProvider`) + currency (persist to Firestore `users/{uid}.currency`). Consolidates locale + currency.
- `OrdersProvider` — streams/creates/updates the user's shipments via `OrderRepository`.
- `PlanProvider` — current subscription plan; subscribe action via `UserRepository`.

### Repositories (Firestore isolation)
- `UserRepository` — read/write profile, currency, plan.
- `OrderRepository` — create order, stream orders, advance status.
- Warehouses/lockers come from existing static `data/` (no repository needed).

Screens never call Firestore directly — only providers/repositories.

### Folder layout
```
lib/
  main.dart                    (keep)
  app.dart                     (rewrite: providers + MaterialApp.router + shell)
  firebase_options.dart        (keep)
  theme/
    app_colors.dart
    app_text.dart
    app_theme.dart
  widgets/                     (component library — see §5)
  router/
    app_router.dart            (StatefulShellRoute)
    routes.dart
  data/
    models/  (keep app_user, warehouse, locker, website_ref; ADD order.dart)
    warehouses.dart lockers.dart how_it_works.dart   (keep)
    repositories/
      user_repository.dart
      order_repository.dart
  state/
    settings_provider.dart
    orders_provider.dart
    plan_provider.dart
  features/
    auth/ (auth_provider.dart kept; screens rebuilt)
    splash/ welcome/
    home/ profile/ menu/ settings/
    warehouses/ lockers/ plans/ payment/ shipments/ support/ info/
  l10n/  (keep + extend ARB)
assets/  (icons, flags, pattern, maps — copied from html/assets)
```

## 4. Design system (from `html/design-system.css`)

### `app_colors.dart`
`bgSplash #c5e2ff`, `bgPage #ffffff`, `primary #2563eb`, `btnFill #86a6ea`, `btnAlt #649dde`, `borderStrong #16447b`, `inputBg #ffffff`, `inputBgAlt #f1f3f5`, `inputBorder #848484`, `text #000000`, `textSoft #120101`, `muted #64748b`, `navBar #86a6ea`, `navPill #c7d3f2`, `radius 10`.

### `app_text.dart`
`google_fonts`: Playfair Display SemiBold (display/logo), Inter (body, 300–600), Alan Sans (accents), Instrument Serif (minor). Scale: display 44/32, title 28, heading 20, body 16, caption 13.

### `app_theme.dart`
`ThemeData` wiring colors + text + `InputDecorationTheme` (white fill, blue border, radius 10) + `ElevatedButton`/`OutlinedButton` themes (pill, radius 10). Light theme only.

### Assets
Copy from `html/assets/` → `assets/`: `icons/` (home, account_circle, settings, chevron-back, arrow-right-circle), `images/` (flags, logos), `pattern/airplane_box.svg`.

## 5. Component library (`lib/widgets/`)

- `CfScaffold({topBar, bottomNav, child})` — watermark background (`airplane_box.svg` tiled, faint) + safe areas; optional `CfTopBar` and `CfBottomNav`.
- `CfBottomNav` — reads shell index; 4 items (Home/Profile/Menu/Settings) with active highlight (black pill on active, per the clone's menu item style).
- `CfTopBar({title})` — back chevron + "CartFly" wordmark.
- `CfButton` / `CfOutlineButton` — pill buttons.
- `CfInput({label, controller, obscure, keyboardType})` — labeled field.
- `CfCard` — bordered/elevated container.
- `CfFlagCard({code, name, onTap})` — country flag card (warehouses/lockers).
- `CfListRow({icon, label, trailingArrow, onTap})` — settings rows.
- `CfStatusTimeline(status)` — order tracking timeline (placed→delivered).
- `CfEmptyState`, `CfLoading`, `CfErrorState` — shared states.

Every screen composes these; visual changes happen in one place.

## 6. Data model (Firestore)

```
users/{uid}
  name, phone, email, country, currency        (exists)
  plan: "none"|"basic"|"smart"|"prime"          (NEW)
  createdAt

users/{uid}/orders/{orderId}                    (NEW)
  title: string
  sourceCountry: "sa"|"eg"|"ae"|"us"|"cn"
  deliveryMethod: "locker"|"home"
  lockerId: string?                              (when locker)
  status: "placed"|"atWarehouse"|"packaging"|"shipped"|"ready"|"delivered"
  statusHistory: [{status, at: Timestamp}]
  createdAt: Timestamp
```

`Order` model (`data/models/order.dart`) with `OrderStatus` enum, `fromMap`/`toMap`, and `OrderStatus.next` for the demo advance action.

Static data (warehouses, lockers) stays as existing Dart objects. Firestore security rules: user can only read/write their own `users/{uid}` subtree (rules file to be added; documented in plan).

## 7. Core functional flows

- **Auth:** register → write profile + `sendEmailVerification` → verify-email gate (`reloadVerified`) → home; login; `resetPassword`; logout. (Existing `AuthProvider`; only screens are new.)
- **Create shipment:** Home/Welcome "Create shipment" → form (source country, delivery method [locker→pick locker / home], item title) → `OrderRepository.create` (status=placed) → order details/track.
- **Track order:** `CfStatusTimeline` from `order.status`; demo "Advance status" button calls `OrderRepository.advance`.
- **Subscribe plan:** plans → plan detail → simulated payment (card form, no gateway, no card stored) → on Confirm set `user.plan` → success screen.
- **Settings:** change language (locale persisted, app rebuilds, RTL), currency (Firestore), edit profile, change password (`updatePassword`/reauth or reset email), sign out.

## 8. Screen inventory

**Auth (no shell):** splash, login, register, verify-email, forgot-password, welcome.
**Home tab:** dashboard (create-shipment CTA, latest order strip→track, entries to warehouses/lockers/plans), order list/history.
**Profile tab:** my-profile, edit-profile, change-password.
**Menu tab:** services hub (shipping method: lockers/home delivery), how-it-works.
**Settings tab:** settings, language, currency, support (have-an-issue), about, policy.
**Pushed flows:** warehouses grid, warehouse detail, lockers map, country lockers, create-shipment, order details, track order, plans, plan detail, payment (card), payment success, payment error.

**New screens to create (same design system):** create-shipment form, order list/history, edit-profile, change-password, verify-email (proper), empty/loading/error states.

**Excluded:** Shein checkout (×2), CartFly widget popups (×4).

## 9. Localization & RTL

Extend existing ARB (`app_en.arb`/`app_ar.arb`) with all new UI strings. Static Dart content (warehouse copy, how-it-works, plan features) keyed per-locale. Language toggle in Settings persists and flips `Directionality`. RTL verified on forms and lists.

## 10. Staging (one plan file per stage, in a directory)

Full plan lives in `docs/superpowers/plans/cartfly-flutter/` — `00-overview.md` + one file per stage. Each stage compiles & is testable.

0. **Teardown & scaffolding** — remove old UI; keep foundation; blank shell compiles.
1. **Design system** — colors/text/theme + assets; token smoke screen.
2. **Component library** — all `Cf*` widgets + gallery screen.
3. **Navigation shell** — `StatefulShellRoute`, dynamic bottom bar, auth redirect, placeholder tabs.
4. **Auth flow** — splash/login/register/verify/forgot/welcome on new design, wired to `AuthProvider`.
5. **Home + static catalogs** — dashboard, warehouses grid+detail, lockers map+country.
6. **Shipments** — `Order` model, repository/provider, create-shipment, order list, details, track timeline, demo advance.
7. **Plans + payment** — chooser/detail, simulated card payment, success/error, set `user.plan`.
8. **Settings & profile** — language, currency, edit-profile, change-password, about/policy/support; persistence.
9. **Polish** — empty/loading/error states, RTL pass, final wiring, manual test checklist.

## 11. Testing & acceptance

- Each stage: `flutter analyze` clean + manual smoke per its checklist.
- Widget tests for the component library and `Order` model/`OrderStatus.next`.
- Acceptance: register→verify→home works on the real Firebase project; create-shipment persists and tracks; subscribe sets plan; language/currency persist; dynamic bottom bar highlights the active tab and persists across tabs; app builds for Android + Web.

## 12. Out of scope

Real payment gateway, real logistics/shipment tracking backend, push notifications, saved-addresses CRUD, order-level chat/support tickets, the browser-extension widget, customs/HS engine, wallet. (Some may become later specs.)

## 13. Open items

- Firestore security rules file to be written in Stage 6 (orders) — restrict to owner.
- Exact per-locale copy for new screens (create-shipment, payment) — drafted in plan, refined during implementation.
- Change-password approach: in-app `updatePassword` (needs recent login / reauth) vs password-reset email — plan picks `updatePassword` with reauth fallback.
