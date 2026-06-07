# CartFly Flutter App — Implementation Plan (Overview)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild the CartFly Flutter UI from scratch on the new design system (the `html/` clone) and make it a functional app backed by the existing Firebase project.

**Architecture:** `go_router` `StatefulShellRoute.indexedStack` with a dynamic bottom bar (4 tabs); `provider` state; thin repositories over Cloud Firestore; reusable themed `Cf*` widgets composed into data-driven screens. Core features real (auth, profile, shipments, plans), reference data static, payment simulated.

**Tech Stack:** Flutter (SDK ≥3.4), Dart 3.4+, provider, go_router, firebase_core/auth, cloud_firestore, flutter_map, google_fonts, flutter_svg, country_flags, shared_preferences, intl/flutter_localizations.

**Source spec:** `docs/superpowers/specs/2026-06-07-cartfly-flutter-app-design.md`
**Visual reference:** `html/` (the HTML/Tailwind clone — the look to match).

---

## How to use this plan

Implement stages **in order**. Each stage is its own file and ends in a **compiling, testable** app. Do not start a stage until the previous one's "Stage exit check" passes.

| Stage | File | Outcome |
|---|---|---|
| 0 | `01-stage0-teardown.md` | Old UI removed, foundation kept, app compiles to a blank shell |
| 1 | `02-stage1-design-system.md` | Colors/text/theme + assets; token smoke screen |
| 2 | `03-stage2-components.md` | `Cf*` widget library + gallery screen |
| 3 | `04-stage3-shell.md` | `StatefulShellRoute`, dynamic bottom bar, auth redirect, placeholder tabs |
| 4 | `05-stage4-auth.md` | Splash/login/register/verify/forgot/welcome wired to `AuthProvider` |
| 5 | `06-stage5-home-catalogs.md` | Home dashboard + warehouses + lockers (static) |
| 6 | `07-stage6-shipments.md` | Order model/repo/provider, create-shipment, list, details, track |
| 7 | `08-stage7-plans-payment.md` | Plans, simulated payment, subscription |
| 8 | `09-stage8-settings-profile.md` | Language, currency, edit-profile, change-password, info pages |
| 9 | `10-stage9-polish.md` | Empty/loading/error states, RTL pass, manual test checklist |

## Conventions for every stage

- **Branch/commit:** commit after each task with `feat(stageN): ...` / `chore(stageN): ...`.
- **Analyze gate:** every task that changes Dart ends by running `flutter analyze` → expect **No issues found**.
- **Tests:** unit/widget tests where they add value (models, component library, repositories with fakes). Screens are verified by a **manual smoke checklist** at each stage's end (Flutter UI is not unit-tested here — university scope).
- **Run the app:** `flutter run -d chrome` (web, fastest) or an Android emulator. For auth-gated screens during dev, `flutter run --dart-define=DEBUG_BYPASS_AUTH=true` bypasses the redirect (flag already supported in the old router; re-added in Stage 3).
- **Never call Firestore from a widget** — only via a provider/repository.
- **Keep files focused** — one widget/provider/screen per file.

## Target folder layout (end state)

```
lib/
  main.dart                      (keep)
  app.dart                       (rewritten in Stage 3)
  firebase_options.dart          (keep)
  theme/{app_colors,app_text,app_theme}.dart            (Stage 1)
  widgets/cf_*.dart                                      (Stage 2)
  router/{app_router,routes}.dart                       (Stage 3)
  state/{settings_provider,orders_provider,plan_provider}.dart  (Stages 3/6/7)
  data/
    models/{app_user,warehouse,locker,website_ref}.dart (keep) + order.dart (Stage 6)
    warehouses.dart lockers.dart how_it_works.dart      (keep)
    repositories/{user_repository,order_repository}.dart (Stages 6/7)
  features/
    auth/auth_provider.dart                             (keep)
    auth/*_screen.dart splash/ welcome/                 (Stage 4)
    home/ profile/ menu/ settings/                      (Stages 5/8)
    warehouses/ lockers/                                (Stage 5)
    shipments/ plans/ payment/ info/ support/           (Stages 6/7/8)
  l10n/*.arb *.dart                                     (keep + extend)
assets/{icons,images,pattern,maps}/                     (Stage 1, copied from html/assets)
```

## What is kept vs deleted (Stage 0 detail)

**Keep:** `main.dart`, `firebase_options.dart`, `features/auth/auth_provider.dart`, `app/locale_provider.dart`, all of `data/` (models + static data), all of `l10n/`, platform folders, `pubspec.yaml`.

**Delete:** `app.dart` (rewritten), `theme/*`, `widgets/*`, and every screen under `features/` except `auth/auth_provider.dart`.

## Cross-stage data contracts (define once, used everywhere)

These names are fixed — later stages depend on them:

- `OrderStatus` enum values: `placed, atWarehouse, packaging, shipped, ready, delivered` with `OrderStatus.next` (Stage 6).
- `Order` fields: `id, title, sourceCountry, deliveryMethod, lockerId, status, statusHistory, createdAt` (Stage 6).
- Plan values stored on `users/{uid}.plan`: `"none" | "basic" | "smart" | "prime"` (Stage 7).
- Tab order/index: `0=Home, 1=Profile, 2=Menu, 3=Settings` (Stage 3) — `CfBottomNav` and the shell rely on this.
- Route name constants live in `router/routes.dart` (Stage 3); every screen navigates by these constants, never raw strings.

## Stage exit checks (summary)

Each stage file ends with its own check. The whole plan is done when Stage 9's acceptance passes: register→verify→home on real Firebase, create-shipment persists & tracks, subscribe sets plan, language/currency persist, dynamic bottom bar highlights the active tab and persists across tabs, builds for Android + Web.
