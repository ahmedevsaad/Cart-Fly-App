# CartFly Clean-Room UI Rebuild Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild CartFly's entire Flutter UI layer (theme + widgets + every screen) from zero as strict 1:1 ports of the design frames, with a real extracted SVG icon set, on branch `redesign/cartfly-ui`.

**Architecture:** Bottom-up rebuild that stays compilable: (0) extract SVG icons, (1) rebuild theme + `cf_*` widget kit holding public class names/constructors STABLE, then (2-6) replace each screen body in place keeping its existing class name + constructor so the router never breaks. Logic/data/router/providers/l10n are kept untouched. `flutter analyze` + `flutter test` stay green at every commit.

**Tech Stack:** Flutter 3.27 / Dart 3.6, flutter_svg, google_fonts (Playfair + Inter), go_router, Provider, country_flags, intl/ARB (EN + AR, RTL).

**Source of truth:** `.design-dl/graduation/project/CartFly Redesign.dc.html` (read exact frame line range before each port) + `CFNav.dc.html`. Content verbatim; reuse the ARB keys already present.

---

## Frame index (gallery section 08)

| # | Frame | HTML lines | Flutter file | Notes |
|---|---|---|---|---|
| 01 | Welcome | 591–608 | `features/welcome/welcome_screen.dart` | hero + serif logo + CTA |
| 02 | Register | 609–634 | `features/auth/register_screen.dart` | + Country + Currency |
| 03 | Login | 635–660 | `features/auth/login_screen.dart` | |
| 04 | How it works | 661–681 | `features/info/how_it_works_screen.dart` | |
| 05 | Home | 690–735 | `features/home/home_screen.dart` | avatar, order tracker, service grid |
| 06 | Our warehouses | 736–755 | `features/warehouses/warehouses_screen.dart` | |
| 07–11 | China/USA/UAE/Egypt/Saudi | 756–821 | `features/lockers/country_lockers_screen.dart` | flag + map + copy-address card |
| 12 | Locker locations | 822–849 | `features/lockers/lockers_screen.dart` | |
| 13 | My address | 850–877 | `features/address/my_address_screen.dart` | NEW |
| 14 | Declare a package | 878–913 | `features/shipments/create_shipment_screen.dart` | extend; keep order-create flow |
| 15 | My packages | 914–960 | `features/shipments/orders_screen.dart` | tabbed inbox |
| 16 | Our Plans | 961–981 | `features/plans/plans_screen.dart` | |
| 17–19 | Basic/Smart/Prime | 982–1041 | `features/plans/plan_detail_screen.dart` | |
| Calc | Shipping Calculator | 113–200 | `features/calculator/shipping_calculator_screen.dart` | NEW |
| 20 | Plan payment | 1042–1096 | `features/payment/payment_screen.dart` | plan mode |
| 21 | Plan confirmed | 1097–1126 | `features/payment/payment_success_screen.dart` | receipt mode |
| 22 | Order hub | 1127–1178 | `features/shipments/order_detail_screen.dart` | |
| 23 | Confirm order | 1179–1207 | `features/shipments/confirm_order_screen.dart` | |
| 24 | Payment | 1208–1238 | `features/payment/payment_screen.dart` | order mode |
| 25 | Track | 1239–1285 | `features/shipments/track_order_screen.dart` | |
| 26 | My Profile | 1286–1309 | `features/profile/profile_screen.dart` | + currency |
| 27 | Settings | 1310–1351 | `features/settings/settings_screen.dart` | |
| 28 | Currency | 1352–1379 | `features/settings/currency_screen.dart` | |
| 29 | Language | 1380–1405 | `features/settings/language_screen.dart` | |
| 30 | About us | 1406–1422 | `features/info/about_screen.dart` | |
| 31 | Have an issue | 1423–1440 | `features/support/support_screen.dart` | |

---

## Per-screen porting checklist (apply to EVERY screen task)

1. `Read` the design HTML at the exact line range AND the current Flutter screen file.
2. Rebuild the screen body from scratch — keep the **existing class name + constructor signature** (router depends on them).
3. Use ONLY: `AppColors.*`, `AppText.*`, `Cf*` widgets, and `CfIcons.*` (the extracted SVG set). NO raw hex (except flag paints), NO `Icons.*` for design-specified glyphs, NO inline fontFamily.
4. Content verbatim. Country flags via `country_flags`. Reuse existing ARB keys; add new ones to BOTH `app_en.arb` + `app_ar.arb` and regenerate.
5. RTL via `EdgeInsetsDirectional` / `AlignmentDirectional`. ≥44px tap targets + `Semantics` on interactive elements.
6. `flutter analyze` clean + relevant tests green. Commit.

---

## Stage 0: Extract SVG icon set

### Task 0.1: Build `CfIcons`

**Files:**
- Create: `lib/widgets/icons/cf_icons.dart`
- Test: `test/widgets/cf_icons_test.dart`

- [ ] **Step 1:** Read `.design-dl/graduation/project/CFNav.dc.html` (nav icon SVG paths) and grep `CartFly Redesign.dc.html` for `<svg` to collect the recurring glyph paths (home, account/user, orders/receipt, settings/gear, warehouses, lockers, plans, cart-calculator, bag, box, truck, check, barcode, card, paypal, apple, copy, chevron-right/back/up, location-pin, globe-with-pin, star, plus, sign-out).
- [ ] **Step 2:** Implement `CfIcons` as a class of static methods returning `Widget`, each wrapping `SvgPicture.string('<svg ...>')` with parameters `{double size = 22, Color color}`. Template the stroke/fill color by string-substituting a placeholder. Example:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CfIcons {
  CfIcons._();
  static Widget _svg(String body, double size, Color color) {
    final hex = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
    return SvgPicture.string(body.replaceAll('{c}', hex), width: size, height: size);
  }
  static Widget home({double size = 22, Color color = const Color(0xFF7E8AA0)}) =>
      _svg('<svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path d="M3 10.5 12 3l9 7.5M5 9.5V20h14V9.5" stroke="{c}" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"/></svg>', size, color);
  // ...one method per glyph, paths copied verbatim from the design HTML...
}
```

- [ ] **Step 3:** Write a smoke test that pumps a few `CfIcons` widgets and asserts no exception:

```dart
testWidgets('CfIcons render', (t) async {
  await t.pumpWidget(MaterialApp(home: Row(children: [CfIcons.home(), CfIcons.account(), CfIcons.orders(), CfIcons.settings()])));
  expect(tester_takes_no_error: true, true); // replace with: expect(find.byType(SvgPicture), findsWidgets);
});
```
(Use `expect(find.byType(SvgPicture), findsWidgets);`.)

- [ ] **Step 4:** Run `flutter test test/widgets/cf_icons_test.dart` → PASS. Run `flutter analyze` → clean.
- [ ] **Step 5:** Commit: `feat(icons): extract design SVG icon set into CfIcons`.

---

## Stage 1: Foundation (theme + widget kit)

> Hold all `cf_*` public class names + constructor signatures STABLE. Grep call sites first (`grep -r "CfButton(" lib`, etc.) and keep required params.

### Task 1.1: Theme tokens, text, builder
**Files:** rewrite `lib/theme/app_colors.dart`, `app_text.dart`, `app_theme.dart`.
- [ ] **Step 1:** Write `app_colors.dart` with the full token set from the spec's Foundation/Tokens section (all hex values listed there), plus radii (field 12, card 16, nav 22, pill 999) and `shadowSoft` / `shadowCard` BoxShadow lists.
- [ ] **Step 2:** `app_text.dart`: Playfair `logo` (w800 `AppColors.primary`) + Inter `display/title/heading/body/bodyMedium/caption/label`. All colors via `AppColors`.
- [ ] **Step 3:** `app_theme.dart`: M3 light, `colorScheme.primary = primary`, input theme (fill `fieldBg`, r12, hairline `cardBorder`, focus `primary`), elevated button (`primary` fill, white w700, r12, elevation 0).
- [ ] **Step 4:** `flutter analyze lib/theme/` clean. Commit: `feat(theme): design-exact tokens + type scale`.

### Task 1.2: Rebuild `cf_*` widgets (API-stable)
**Files:** rewrite each in `lib/widgets/`: `cf_bottom_nav.dart`, `cf_button.dart`, `cf_input.dart`, `cf_card.dart`, `cf_status_timeline.dart`, `cf_dashed.dart`, `cf_background.dart`, `cf_top_bar.dart`, `cf_scaffold.dart`, `cf_list_row.dart`, `cf_states.dart`, `cf_flag_card.dart`.
- [ ] **Step 1:** For each widget, grep its current call sites to capture the public API (class name + required/optional params) and KEEP it. Rebuild internals to the spec's Widget-kit section using `AppColors`, `AppText`, `CfIcons`.
- [ ] **Step 2:** `cf_bottom_nav.dart`: floating bar r22, `navBarBorder`, nav shadow, 4 tabs using `CfIcons.home/account/orders/settings`, active = `primary` pill + label, idle = icon-only `navIdle`, InkWell + Semantics, ≥44px, safe-area bottom. Keep `CfBottomNav({required int currentIndex, required ValueChanged<int> onTap})`.
- [ ] **Step 3:** Rebuild the remaining widgets (button/input/card/timeline/dashed/background/topbar/scaffold/listrow/states/flagcard) per spec.
- [ ] **Step 4:** `flutter analyze` → clean across the whole project (existing screens still compile against the stable APIs). Run `flutter test` → 9/9. Commit: `feat(widgets): rebuild cf_* kit on design-exact foundation + CfIcons`.

**STAGE 1 GATE:** fresh `ui-ux-pro-max` review of `lib/theme/*` + `lib/widgets/*` vs HTML 16–98 + CFNav. Fix findings.

---

## Stage 2: Onboarding (frames 01–04)

Replace each screen body 1:1 (keep class names). Apply the per-screen checklist.

### Task 2.1: Welcome (01, 591–608) → `welcome_screen.dart`
- [ ] Full-bleed hero, serif CartFly, CTA. `flutter analyze` + `flutter test`. Commit `feat(welcome): 1:1 rebuild frame 01`.
### Task 2.2: Register (02, 609–634) → `register_screen.dart`
- [ ] Gray labelled fields incl. Country + Currency, solid blue button; keep AuthProvider wiring. Commit `feat(auth): 1:1 rebuild register frame 02`.
### Task 2.3: Login (03, 635–660) → `login_screen.dart`
- [ ] Welcome-back, email/password (eye toggle), Register link. Commit `feat(auth): 1:1 rebuild login frame 03`.
### Task 2.4: How it works (04, 661–681) → `how_it_works_screen.dart`
- [ ] Steps verbatim. Commit `feat(info): 1:1 rebuild how-it-works frame 04`.

**STAGE 2 GATE:** fresh `ui-ux-pro-max` review (LTR + RTL). Fix.

---

## Stage 3: Discover (frames 05–12)

### Task 3.1: Home (05, 690–735) → `home_screen.dart`
- [ ] Avatar + greeting, order tracker (`CfStatusTimeline` w/ `CfIcons` per step), "Our services:" + 2×2 service grid using `CfIcons.warehouses/lockers/plans/cartCalc`, calculator card → `Routes.calculator`. Commit `feat(home): 1:1 rebuild frame 05`.
### Task 3.2: Warehouses (06, 736–755) → `warehouses_screen.dart`
- [ ] Grid w/ `wh-*.png` thumbs + flag chips. Commit `feat(warehouses): 1:1 rebuild frame 06`.
### Task 3.3: Country pages (07–11, 756–821) → `country_lockers_screen.dart`
- [ ] Param by `code`; flag chip, `assets/maps/map-*`, copy-address card above map. Commit `feat(lockers): 1:1 rebuild country frames 07-11`.
### Task 3.4: Lockers (12, 822–849) → `lockers_screen.dart`
- [ ] Locker list w/ pin icon. Commit `feat(lockers): 1:1 rebuild frame 12`.

**STAGE 3 GATE:** fresh `ui-ux-pro-max` review. Fix.

---

## Stage 4: Plans + Calculator + plan checkout

### Task 4.1: Our Plans (16, 961–981) → `plans_screen.dart`
- [ ] Accordion list. Commit `feat(plans): 1:1 rebuild frame 16`.
### Task 4.2: Plan details (17–19, 982–1041) → `plan_detail_screen.dart`
- [ ] Description → Features → Subscribe → Price order; copy verbatim. Commit `feat(plans): 1:1 rebuild plan details 17-19`.
### Task 4.3: Shipping Calculator (113–200) → `shipping_calculator_screen.dart`
- [ ] 3-step header, China→Egypt flag chips, 2.5 KG, $12+$8+$3=$23.00, 7–10 Days green card, dashed rows; route already exists. Commit `feat(calculator): 1:1 rebuild shipping calculator`.
### Task 4.4: Plan payment (20, 1042–1096) → `payment_screen.dart` (plan mode)
- [ ] Prime $19.99/mo, method chips, card fields, checkmark Pay button w/ shadow; preserve order-mode. Commit `feat(payment): 1:1 rebuild plan checkout frame 20`.
### Task 4.5: Plan confirmed (21, 1097–1126) → `payment_success_screen.dart` (receipt)
- [ ] Green check, Thank you, dashed receipt rows, Back-to-home. Commit `feat(payment): 1:1 rebuild plan receipt frame 21`.

**STAGE 4 GATE:** fresh `ui-ux-pro-max` review. Fix.

---

## Stage 5: Ship + Order/Track (frames 13–15, 22–25)

### Task 5.1: My address (13, 850–877) → `my_address_screen.dart`
- [ ] Copy-per-field + Copy-full-address (`Clipboard`), warehouse switch, CF-ID note, dashed dividers, ≥44px copy buttons. Commit `feat(address): 1:1 rebuild frame 13`.
### Task 5.2: Declare a package (14, 878–913) → `create_shipment_screen.dart`
- [ ] Pre-alert fields (store, tracking# w/ barcode icon, category chips, value, qty); KEEP existing functional order-create section. Commit `feat(shipments): 1:1 rebuild declare frame 14`.
### Task 5.3: My packages (15, 914–960) → `orders_screen.dart`
- [ ] All/At warehouse/In transit tabs, status pills, dashed consolidation hint, box `CfIcons`; keep `OrdersProvider` binding. Commit `feat(shipments): 1:1 rebuild my-packages frame 15`.
### Task 5.4: Order hub (22, 1127–1178) → `order_detail_screen.dart`
- [ ] Responsive 4-step `CfStatusTimeline` w/ per-step icons, hub rows (no chevron, lowercase "subscription plans"). Commit `feat(shipments): 1:1 rebuild order hub frame 22`.
### Task 5.5: Confirm order (23, 1179–1207) → `confirm_order_screen.dart`
- [ ] 3-step indicator (padded), customer fields from AuthProvider, Next→payment. Commit `feat(shipments): 1:1 rebuild confirm frame 23`.
### Task 5.6: Payment order mode (24, 1208–1238) → `payment_screen.dart`
- [ ] Order-mode fields localized (no hardcoded English), `AppText` titles. Commit `feat(payment): 1:1 rebuild order payment frame 24`.
### Task 5.7: Track (25, 1239–1285) → `track_order_screen.dart`
- [ ] Responsive 3-step stepper, history list, truck/globe `CfIcons`, shipped→step 2. Commit `feat(track): 1:1 rebuild frame 25`.

**STAGE 5 GATE:** fresh `ui-ux-pro-max` review (steppers responsive, RTL). Fix.

---

## Stage 6: Account (frames 26–31)

### Task 6.1: Profile (26, 1286–1309) → `profile_screen.dart`
- [ ] Country flag prefix + expanded currency label; sign-out `signOutBg`. Commit `feat(profile): 1:1 rebuild frame 26`.
### Task 6.2: Settings (27, 1310–1351) → `settings_screen.dart`
- [ ] Rows w/ chevron-in-circle `CfIcons`, wired routes. Commit `feat(settings): 1:1 rebuild frame 27`.
### Task 6.3: Currency (28, 1352–1379) → `currency_screen.dart`
- [ ] Radio rows, idle ring `radioIdle`. Commit `feat(settings): 1:1 rebuild currency frame 28`.
### Task 6.4: Language (29, 1380–1405) → `language_screen.dart`
- [ ] Radio rows. Commit `feat(settings): 1:1 rebuild language frame 29`.
### Task 6.5: About (30, 1406–1422) → `about_screen.dart`
- [ ] Verbatim. Commit `feat(info): 1:1 rebuild about frame 30`.
### Task 6.6: Support (31, 1423–1440) → `support_screen.dart`
- [ ] Verbatim. Commit `feat(support): 1:1 rebuild frame 31`.

**STAGE 6 GATE:** fresh `ui-ux-pro-max` review. Fix.

---

## Stage 7: Final verification

### Task 7.1: Regression
- [ ] `flutter analyze` clean, `flutter test` 9/9, `flutter build web --no-tree-shake-icons` succeeds. Commit fixes.
### Task 7.2: RTL pass
- [ ] Walk every screen in Arabic; fix LTR leaks / mirrored icons / overflow. Commit `fix(rtl): rebuild RTL pass`.
### Task 7.3: Rendered browser comparison (fresh agent)
- [ ] Serve `build/web` as root on a port; fresh agent drives Playwright at phone viewport (402×874), navigates each reachable route, screenshots, compares against each design frame's HTML; reports per-screen MATCH/MINOR/MAJOR + ranked discrepancies. Note auth-gated screens that can't be reached.
- [ ] Triage + fix confirmed MAJOR/MINOR. Re-run the relevant comparison. Commit `fix(rebuild): rendered-comparison corrections`.
### Task 7.4: Finish
- [ ] superpowers:finishing-a-development-branch.

---

## Self-review notes

- **Spec coverage:** icon set→S0; foundation tokens/text/theme/widgets→S1; all 31 frames + calculator→S2–S6; new screens (My address, Calculator)→S5/S4; i18n→per-screen + S7.2; testing (per-stage analyze/test + ui-ux gate, final rendered compare)→stage gates + S7. ✓
- **Compile-safety:** S1 holds `cf_*` public APIs stable so screens compile before they're rebuilt; screens keep class names so the router stays valid. ✓
- **No duplication:** Declare/My-packages/plan-checkout/receipt fold into existing files; only My address + Calculator are net-new. Existing create-shipment order flow preserved. ✓
- **Naming consistency:** `CfIcons` static-method-per-glyph used uniformly; `AppColors`/`AppText` token names match the spec. ✓
