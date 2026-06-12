# CartFly Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Re-skin the entire CartFly Flutter app to the refined design system from the Claude Design handoff bundle, port all 31 redesigned screens faithfully, add the new journey screens, and verify with fresh `ui-ux-pro-max` agents.

**Architecture:** Tokens live in `lib/theme/` (single source of truth). Shared widgets in `lib/widgets/` own visual structure so the re-skin propagates without per-screen edits. Screens compose widgets and pull content from `lib/data`. New routes via `lib/router/`. Each screen is ported faithfully from a specific HTML frame (exact line range given).

**Tech Stack:** Flutter 3.27 / Dart 3.6, google_fonts (Playfair + Inter), go_router, Provider, country_flags, flutter_map, intl/ARB (EN + AR, RTL).

**Source of truth for visuals:** `.design-dl/graduation/project/CartFly Redesign.dc.html` (the "design HTML"). Read the exact frame line-range before porting each screen. Do NOT invent content — copy labels/prices/addresses verbatim.

---

## Design HTML frame index (gallery section 08)

| # | Frame | HTML lines | Flutter target | Action |
|---|---|---|---|---|
| 01 | Welcome | 591–608 | `features/welcome/welcome_screen.dart` | re-skin |
| 02 | Register | 609–634 | `features/auth/register_screen.dart` | re-skin (Country+Currency fields) |
| 03 | Login | 635–660 | `features/auth/login_screen.dart` | re-skin |
| 04 | How it works | 661–681 | `features/info/how_it_works_screen.dart` | re-skin |
| 05 | Home | 690–735 | `features/home/home_screen.dart` | re-skin |
| 06 | Our warehouses | 736–755 | `features/warehouses/warehouses_screen.dart` | re-skin |
| 07–11 | China/USA/UAE/Egypt/Saudi locations | 756–821 | `features/lockers/country_lockers_screen.dart` | re-skin + copy-address card |
| 12 | Locker locations | 822–849 | `features/lockers/lockers_screen.dart` | re-skin |
| 13 | My address | 850–877 | `features/address/my_address_screen.dart` | **NEW** |
| 14 | Declare a package | 878–913 | `features/shipments/create_shipment_screen.dart` | extend |
| 15 | My packages | 914–960 | `features/shipments/orders_screen.dart` | reshape to tabbed inbox |
| 16 | Our Plans | 961–981 | `features/plans/plans_screen.dart` | re-skin |
| 17–19 | Basic/Smart/Prime cart | 982–1041 | `features/plans/plan_detail_screen.dart` | re-skin |
| 20 | Plan payment | 1042–1096 | `features/payment/payment_screen.dart` | plan-checkout mode |
| 21 | Plan confirmed | 1097–1126 | `features/payment/payment_success_screen.dart` | receipt mode |
| 22 | Order hub | 1127–1178 | `features/shipments/order_detail_screen.dart` (hub) | re-skin |
| 23 | Confirm your order | 1179–1207 | `features/shipments/create_shipment_screen.dart` (confirm step) | re-skin |
| 24 | Payment | 1208–1238 | `features/payment/payment_screen.dart` | re-skin |
| 25 | Track your order | 1239–1285 | `features/shipments/track_order_screen.dart` | re-skin (responsive stepper) |
| 26 | My Profile | 1286–1309 | `features/profile/profile_screen.dart` | re-skin (+ currency line) |
| 27 | Settings | 1310–1351 | `features/settings/settings_screen.dart` | re-skin |
| 28 | Settings/Currency | 1352–1379 | `features/settings/currency_screen.dart` | re-skin |
| 29 | Settings/Language | 1380–1405 | `features/settings/language_screen.dart` | re-skin |
| 30 | About us | 1406–1422 | `features/info/about_screen.dart` | re-skin |
| 31 | Have an issue? | 1423–1440 | `features/support/support_screen.dart` | re-skin |

Plus: **Shipping Calculator** (design HTML lines 113–200, the "03 — REFACTORED" section) → **NEW** `features/calculator/shipping_calculator_screen.dart`.
Bottom nav source: `.design-dl/graduation/project/CFNav.dc.html` + design HTML lines 54–84.

---

## Per-screen porting checklist (apply to EVERY screen task)

For each screen task, the executing agent MUST:
1. `Read` the design HTML at the exact line range in the table above.
2. `Read` the current Flutter screen file.
3. Rebuild the screen using **only theme tokens** (`AppColors.*`, `AppText.*`) and shared widgets (`Cf*`) — no raw hex, no inline `TextStyle(fontFamily:...)`.
4. Keep all content verbatim (labels, prices, addresses, paragraphs). Country flags via `country_flags`.
5. Ensure the screen renders under both LTR (en) and RTL (ar); add any new strings to BOTH ARB files.
6. Run `flutter analyze` (clean) and any screen-specific widget test (green).
7. Commit.

---

## Stage 0: Baseline & asset sync

### Task 0.1: Confirm baseline builds

**Files:** none (verification only)

- [ ] **Step 1:** Run `flutter pub get`. Expected: resolves, no errors.
- [ ] **Step 2:** Run `flutter analyze`. Record the current warning/error count as the baseline (must not regress).
- [ ] **Step 3:** Run `flutter test`. Record pass/fail baseline.
- [ ] **Step 4:** Commit nothing; note baseline in the task log.

### Task 0.2: Sync redesign assets

**Files:**
- Copy into: `assets/maps/`, `assets/images/`
- Modify: `pubspec.yaml` (only if new asset dirs needed)

- [ ] **Step 1:** Compare `.design-dl/graduation/project/assets/` (map-china.jpg, map-egypt.png, map-saudi.png, map-uae.png, map-usa.jpg, wh-*.png, welcome-hero.jpg, avatar.png) against existing `assets/maps/` and `assets/images/`. List which the app is missing.
- [ ] **Step 2:** Copy any missing map/warehouse/hero images the redesign uses into the matching `assets/` subfolder. Do not overwrite an existing asset that already works unless the redesign's is clearly the intended one.
- [ ] **Step 3:** Run `flutter pub get` and confirm assets resolve.
- [ ] **Step 4:** Commit: `chore(assets): sync redesign map/warehouse/hero images`.

---

## Stage 1: Theme tokens

### Task 1.1: Rewrite color tokens

**Files:**
- Modify: `lib/theme/app_colors.dart`

- [ ] **Step 1:** Replace the token set with the redesign values:

```dart
import 'package:flutter/material.dart';

/// CartFly color tokens — mirror of CartFly Redesign.dc.html design system.
class AppColors {
  AppColors._();

  static const bgSplash = Color(0xFFC5E2FF);
  static const bgPage = Color(0xFFFFFFFF);
  static const primary = Color(0xFF2563EB);   // brand blue — buttons + accents
  static const navy = Color(0xFF16335E);      // deep accent / icon strokes
  static const fieldBg = Color(0xFFF1F3F5);   // gray input/card fill
  static const cardBorder = Color(0xFFE2E8F0);// hairline border
  static const text = Color(0xFF0F172A);      // slate-900
  static const muted = Color(0xFF64748B);
  static const mutedLabel = Color(0xFF475569);// field labels
  static const mutedDisabled = Color(0xFF94A3B8);
  static const success = Color(0xFF15803D);
  static const successBg = Color(0xFFDCFCE7);
  static const danger = Color(0xFFEF4444);
  static const navIdle = Color(0xFF7E8AA0);   // idle bottom-nav icon
  static const cardBg = Color(0xFFF1F3F5);

  static const double radius = 12;            // fields
  static const double radiusCard = 16;        // cards
  static const double radiusPill = 999;

  // Soft elevations (use in BoxShadow lists).
  static const shadowSoft = [
    BoxShadow(color: Color(0x0D0F172A), blurRadius: 3, offset: Offset(0, 1)),
  ];
  static const shadowCard = [
    BoxShadow(color: Color(0x210F172A), blurRadius: 44, offset: Offset(0, 18)),
  ];
}
```

- [ ] **Step 2:** Run `flutter analyze lib/theme/app_colors.dart`. Expected: no errors. (Downstream files referencing removed tokens like `btnFill`, `navBar`, `navPill`, `inputBg`, `borderStrong` will now error — those are fixed in their own tasks. If the analyzer blocks, add temporary aliases `static const btnFill = primary; static const navBar = primary; static const navPill = fieldBg; static const inputBg = bgPage; static const inputBgAlt = fieldBg; static const inputBorder = cardBorder; static const textSoft = text; static const borderStrong = navy;` and remove them in Stage 2 once widgets are migrated.)
- [ ] **Step 3:** Commit: `feat(theme): redesign color tokens (#2563EB primary, gray fields, soft elevation)`.

### Task 1.2: Refresh theme builder

**Files:**
- Modify: `lib/theme/app_theme.dart`

- [ ] **Step 1:** Update `buildAppTheme()`: `colorScheme.primary = AppColors.primary`; `inputDecorationTheme` → `fillColor: AppColors.fieldBg`, no hard border (use `OutlineInputBorder` with `BorderSide.none` and `borderRadius: AppColors.radius`); `elevatedButtonTheme` → `backgroundColor: AppColors.primary`, `foregroundColor: Colors.white`, radius `AppColors.radius`, padding 14×20; `textTheme.apply(bodyColor: AppColors.text)`.
- [ ] **Step 2:** Run `flutter analyze lib/theme/`. Expected: clean (modulo temporary aliases).
- [ ] **Step 3:** Commit: `feat(theme): gray filled inputs + solid blue buttons`.

### Task 1.3: Verify type scale

**Files:**
- Modify: `lib/theme/app_text.dart` (only if needed)

- [ ] **Step 1:** Confirm Playfair (logo/display) + Inter (everything). Adjust `logo` to `fontWeight: w800, color: AppColors.primary` to match design (`.logo{font-weight:800;color:#2563EB}`). Keep other styles; ensure all colors reference `AppColors`.
- [ ] **Step 2:** Run `flutter analyze lib/theme/app_text.dart`. Expected: clean.
- [ ] **Step 3:** Commit: `feat(theme): logo wordmark weight + brand color`.

**STAGE 1 GATE:** dispatch a fresh `ui-ux-pro-max` agent to review `lib/theme/*` against the design-system section of the HTML (lines 16–19, 87–98). Fix findings before Stage 2.

---

## Stage 2: Shared widgets

### Task 2.1: New floating bottom nav `CfBottomNav`

**Files:**
- Modify: `lib/widgets/cf_bottom_nav.dart`
- Source: `CFNav.dc.html` + design HTML 54–84.

- [ ] **Step 1:** Read `CFNav.dc.html`. Rebuild `CfBottomNav` as a floating white bar: margin 16, `borderRadius: 22`, `AppColors.shadowCard` (lighter), padding 8. Four items: Home, Account, Orders, Settings. Active item = `AppColors.primary` pill (`borderRadius:15`, padding 10×14) with icon + label (white, w700, 12.5px). Idle items = icon-only, stroke `AppColors.navIdle`, no label. Expose `currentIndex` + `onTap`/route mapping consistent with the existing nav's API so call sites don't break.
- [ ] **Step 2:** Keep the same constructor signature the shell currently calls (check call sites with grep) so no screen breaks; only the visual changes.
- [ ] **Step 3:** Run `flutter analyze lib/widgets/cf_bottom_nav.dart`. Expected: clean.
- [ ] **Step 4:** Commit: `feat(nav): floating 4-tab pill bottom navigation`.

### Task 2.2: `CfButton` solid blue

**Files:** Modify `lib/widgets/cf_button.dart`
- [ ] **Step 1:** Fill `AppColors.primary`, white text Inter w700 16px, radius `AppColors.radius`, padding 15. Remove old `btnFill`/`btnAlt` usage.
- [ ] **Step 2:** `flutter analyze` the file. Commit: `feat(widgets): solid blue primary button`.

### Task 2.3: `CfInput` gray field + label

**Files:** Modify `lib/widgets/cf_input.dart`
- [ ] **Step 1:** Optional label above (Inter w700 12px `AppColors.mutedLabel`), field `AppColors.fieldBg`, radius 12, soft shadow, no hard border, placeholder `AppColors.mutedDisabled`. Source: HTML 136–158.
- [ ] **Step 2:** `flutter analyze`. Commit: `feat(widgets): gray filled input with label`.

### Task 2.4: `CfCard` soft card

**Files:** Modify `lib/widgets/cf_card.dart`
- [ ] **Step 1:** White bg, `AppColors.cardBorder` 1px, radius 16, `AppColors.shadowSoft`. Source: HTML 58, 90.
- [ ] **Step 2:** `flutter analyze`. Commit: `feat(widgets): soft elevated card`.

### Task 2.5: `CfBackground` calmer watermark

**Files:** Modify `lib/widgets/cf_background.dart`
- [ ] **Step 1:** Drop watermark opacity to ~0.05.
- [ ] **Step 2:** `flutter analyze`. Commit: `feat(widgets): calmer 5% watermark`.

### Task 2.6: `CfStatusTimeline` responsive stepper

**Files:** Modify `lib/widgets/cf_status_timeline.dart`
- [ ] **Step 1:** Each step `Expanded` (equal width); connector lines positioned to cross the **center of the circles** (use a Stack/aligned line, not fixed margins); labels wrap without shifting alignment; active circle `AppColors.primary` white number, idle `AppColors.fieldBg` `AppColors.mutedDisabled`. Source: HTML 127–131 (calc stepper) and the Track frame 25 (1239–1285).
- [ ] **Step 2:** `flutter analyze`. Commit: `fix(widgets): responsive status stepper with centered connectors`.

### Task 2.7: Flag chips + remaining widgets token refresh

**Files:** Modify `lib/widgets/cf_flag_card.dart`, `cf_top_bar.dart`, `cf_scaffold.dart`, `cf_list_row.dart`, `cf_states.dart`
- [ ] **Step 1:** Replace any removed tokens / raw hex with new `AppColors.*`. Ensure flag chips use `country_flags` for CN/US/AE/EG/SA.
- [ ] **Step 2:** Remove the temporary aliases added in Task 1.1 Step 2; fix any remaining references.
- [ ] **Step 3:** Run `flutter analyze`. Expected: clean across `lib/widgets/` and `lib/theme/`.
- [ ] **Step 4:** Commit: `refactor(widgets): migrate all shared widgets to redesign tokens`.

**STAGE 2 GATE:** `flutter run -d chrome` (or build web), screenshot the home + a tabbed screen, dispatch a fresh `ui-ux-pro-max` agent to review the nav + widgets against HTML 54–84 / 90–98. Fix findings.

---

## Stage 3: Auth + onboarding screens

Port frames 01–04. Apply the **Per-screen porting checklist** to each.

### Task 3.1: Welcome (frame 01, HTML 591–608) → `welcome_screen.dart`
- [ ] Port full-bleed hero + serif CartFly + "Tap to create shipment" CTA. Commit `feat(welcome): port redesign frame 01`.
### Task 3.2: Register (frame 02, HTML 609–634) → `register_screen.dart`
- [ ] Fields incl. Country + Currency; gray fields, blue button. Commit `feat(auth): port register frame 02`.
### Task 3.3: Login (frame 03, HTML 635–660) → `login_screen.dart`
- [ ] "Welcome back", email/password, "Don't have an account? Register". Commit `feat(auth): port login frame 03`.
### Task 3.4: How it works (frame 04, HTML 661–681) → `how_it_works_screen.dart`
- [ ] Steps content verbatim. Commit `feat(info): port how-it-works frame 04`.

**STAGE 3 GATE:** fresh `ui-ux-pro-max` review of the 4 screens (LTR + RTL). Fix findings.

---

## Stage 4: Home / warehouses / countries / lockers

Port frames 05–12.

### Task 4.1: Home (frame 05, HTML 690–735) → `home_screen.dart`
- [ ] Avatar + "welcome, User", My order tracker, "Our services:" heading, gray service cards w/ arrow-circles, bottom nav. Commit `feat(home): port frame 05`.
### Task 4.2: Our warehouses (frame 06, HTML 736–755) → `warehouses_screen.dart`
- [ ] Commit `feat(warehouses): port frame 06`.
### Task 4.3: Country locations (frames 07–11, HTML 756–821) → `country_lockers_screen.dart`
- [ ] One screen parameterized by country; real flag chip, map image, **copy-address card** above map. China/USA/UAE/Egypt/Saudi. Commit `feat(lockers): port country frames 07-11 + copy-address`.
### Task 4.4: Locker locations (frame 12, HTML 822–849) → `lockers_screen.dart`
- [ ] Commit `feat(lockers): port frame 12`.

**STAGE 4 GATE:** fresh `ui-ux-pro-max` review (maps, flags, copy-address, nav, RTL). Fix findings.

---

## Stage 5: Plans + calculator + plan payment

Port frames 16–21 + the Shipping Calculator.

### Task 5.1: Our Plans (frame 16, HTML 961–981) → `plans_screen.dart`
- [ ] Accordion list Basic/Smart/Prime. Commit `feat(plans): port frame 16`.
### Task 5.2: Plan details (frames 17–19, HTML 982–1041) → `plan_detail_screen.dart`
- [ ] Basic/Smart/Prime expanded copy verbatim. Commit `feat(plans): port plan details 17-19`.
### Task 5.3: Shipping Calculator (HTML 113–200) → **NEW** `features/calculator/shipping_calculator_screen.dart` + route
- [ ] 3-step header (Details/Calculate/Result), Country From/To flag chips (China→Egypt), Weight 2.5 KG, category chips, Estimated Cost $12+$8+$3=$23.00, 7–10 Days green card, 4-tab nav. Register route in `routes.dart`/`app_router.dart`; link from Home "Cart calculator". Add strings to both ARB. Commit `feat(calculator): new shipping calculator screen`.
### Task 5.4: Plan payment (frame 20, HTML 1042–1096) → `payment_screen.dart` (plan mode)
- [ ] Plan summary ($19.99/mo Prime), method select (Card/PayPal/Apple), card fields, Pay button. Commit `feat(payment): plan-checkout mode frame 20`.
### Task 5.5: Plan confirmed (frame 21, HTML 1097–1126) → `payment_success_screen.dart` (receipt)
- [ ] Green check, "Thank you!", receipt rows, Back to home. Commit `feat(payment): plan-confirmed receipt frame 21`.

**STAGE 5 GATE:** fresh `ui-ux-pro-max` review of plans + calculator + plan checkout. Fix findings.

---

## Stage 6: Ship-a-package + order/track (new screens)

Port frames 13–15, 22–25.

### Task 6.1: My address (frame 13, HTML 850–877) → **NEW** `features/address/my_address_screen.dart` + route
- [ ] Personal warehouse address, copy-per-field + "Copy full address", warehouse switch, CF-ID note. Use `Clipboard.setData`. Register route; link from Home/Discover. Strings → both ARB. Commit `feat(address): new My address screen frame 13`.
### Task 6.2: Declare a package (frame 14, HTML 878–913) → extend `create_shipment_screen.dart`
- [ ] Add store/merchant, tracking number, category chips, est value, qty, "Add package". Preserve existing create-shipment flow + tests. Commit `feat(shipments): declare-package form frame 14`.
### Task 6.3: My packages (frame 15, HTML 914–960) → reshape `orders_screen.dart`
- [ ] All / At warehouse / In transit tabs, package cards w/ status pills (At warehouse · In transit · Declared), consolidation hint. Preserve order data binding. Commit `feat(shipments): My packages inbox frame 15`.
### Task 6.4: Order hub (frame 22, HTML 1127–1178) → `order_detail_screen.dart`
- [ ] "My order:" responsive stepper (uses `CfStatusTimeline`), warehouses/lockers/plans hub. Commit `feat(shipments): order hub frame 22`.
### Task 6.5: Confirm order (frame 23, HTML 1179–1207) → `create_shipment_screen.dart` confirm step
- [ ] Commit `feat(shipments): confirm-order frame 23`.
### Task 6.6: Payment (frame 24, HTML 1208–1238) → `payment_screen.dart`
- [ ] Commit `feat(payment): order payment frame 24`.
### Task 6.7: Track your order (frame 25, HTML 1239–1285) → `track_order_screen.dart`
- [ ] 1-2-3 stepper + history, green states, uses `CfStatusTimeline`. Commit `feat(track): port frame 25`.

**STAGE 6 GATE:** fresh `ui-ux-pro-max` review of the ship flow + tracking (stepper responsiveness, RTL). Fix findings.

---

## Stage 7: Settings / profile / info

Port frames 26–31.

### Task 7.1: My Profile (frame 26, HTML 1286–1309) → `profile_screen.dart`
- [ ] Add currency line. Commit `feat(profile): port frame 26 + currency`.
### Task 7.2: Settings (frame 27, HTML 1310–1351) → `settings_screen.dart`
- [ ] Languages/Currency/Notification/Help/Have an issue/Report/Policy rows. Commit `feat(settings): port frame 27`.
### Task 7.3: Currency (frame 28, HTML 1352–1379) → `currency_screen.dart`
- [ ] EGP/SAR/... radio rows. Commit `feat(settings): port currency frame 28`.
### Task 7.4: Language (frame 29, HTML 1380–1405) → `language_screen.dart`
- [ ] Commit `feat(settings): port language frame 29`.
### Task 7.5: About us (frame 30, HTML 1406–1422) → `about_screen.dart`
- [ ] Commit `feat(info): port about frame 30`.
### Task 7.6: Have an issue (frame 31, HTML 1423–1440) → `support_screen.dart`
- [ ] Commit `feat(support): port have-an-issue frame 31`.

**STAGE 7 GATE:** fresh `ui-ux-pro-max` review of account/info screens. Fix findings.

---

## Stage 8: Final verification sweep

### Task 8.1: Regression
- [ ] `flutter analyze` clean. `flutter test` green. `flutter test integration_test` green (or document env limits). Commit fixes if any.

### Task 8.2: RTL pass
- [ ] Toggle to Arabic; walk every screen; fix any LTR-leak / mirrored-icon / overflow. Commit `fix(rtl): redesign RTL corrections`.

### Task 8.3: Multi-agent final sweep (fresh agents)
- [ ] Dispatch parallel fresh `ui-ux-pro-max` review agents across screen groups (auth, discover, ship, plans/pay, account). Each compares the running app against its HTML frames for: token fidelity, nav correctness, content verbatim, contrast/a11y, RTL. Collect findings.
- [ ] Triage + fix confirmed findings. Re-run the relevant agent to confirm closed.
- [ ] Commit `fix(redesign): final multi-agent sweep corrections`.

### Task 8.4: Finish
- [ ] Use superpowers:finishing-a-development-branch to integrate.

---

## Self-review notes

- **Spec coverage:** every spec section maps to a stage (tokens→S1, widgets→S2, screens→S3-7, new screens→S5/S6, i18n→per-screen + S8.2, testing→stage gates + S8.3). ✓
- **Removed-token risk:** Task 1.1 Step 2 gives a temporary-alias bridge so Stage 1 doesn't hard-break before widgets migrate in Stage 2 (Task 2.7 removes aliases). ✓
- **No duplication:** Declare/My-packages/Plan-payment/confirmed fold into existing files per the mapping table; only My address + Shipping Calculator are net-new screens. ✓
- **Frame 22 "Order hub":** mapped to `order_detail_screen.dart`; if at execution the running app routes the hub elsewhere, follow the actual call site rather than forcing this file.
