# CartFly Redesign — Design Spec

_Date: 2026-06-12_
_Source: Claude Design handoff bundle `CartFly Redesign.dc.html` (project "graduation"), 2 chat transcripts._

## Purpose

Port the refined CartFly visual system from the Claude Design handoff bundle into
the existing Flutter app. The current Flutter UI mirrors the **old** Figma clone
(light-blue `#86A6EA` buttons, heavy bottom bar, white hard-bordered fields). The
redesign refines that into a calmer, consistent system and adds the journey screens
that were missing. This is a **re-skin + targeted screen additions**, not a rewrite.

Hard constraint from the transcripts: **content is unchanged** — every label,
address, price and paragraph stays exactly as in the source. Real country flags
(China, USA, UAE, Egypt, Saudi) replace emoji boxes. Bilingual EN + AR with RTL is
preserved; new screens ship both ARB locales.

## Scope (confirmed with user)

- **Full app re-skin** across all ~40 screens.
- **Build all new journey screens** (reconciled against existing equivalents — see
  Screen Mapping).
- **Testing:** both per-stage fresh-agent `ui-ux-pro-max` gates AND a final
  multi-agent sweep.

## Design System (extracted from the bundle)

### Color tokens (new → replaces old)

| Token | New value | Old value | Notes |
|---|---|---|---|
| primary | `#2563EB` | `#2563EB` | unchanged; now also the button fill |
| buttonFill | `#2563EB` | `#86A6EA` | solid brand blue |
| navy | `#16335E` | — | new — icon strokes, deep accents |
| pageBg | `#FFFFFF` | `#FFFFFF` | unchanged |
| fieldBg | `#F1F3F5` | `#FFFFFF` | gray fill |
| cardBorder | `#E2E8F0` | — | card/field hairline |
| borderStrong (fields) | removed | `#16447B` | hard blue border dropped |
| text | `#0F172A` | `#000000` | slate-900 |
| muted | `#64748B` | `#64748B` | unchanged |
| mutedLabel | `#475569` | — | field labels |
| mutedDisabled | `#94A3B8` | — | inactive stepper |
| success | `#15803D` | — | delivery/confirm green |
| successBg | `#DCFCE7` | — | green pill bg |
| navIdle | `#7E8AA0` | — | idle bottom-nav icon |
| watermark opacity | ~5% | ~50% | calmer pattern |

### Typography (unchanged — already correct)

- Logo / wordmark: **Playfair Display** 800, `#2563EB`.
- Everything else: **Inter** (UI text, numbers, labels).

### Shape & elevation

- Phone/cards radius: 16–22px. Fields: 11–12px. Pills: 999px.
- Soft shadows: cards `0 1px 3px rgba(15,23,42,0.05)`; elevated `0 18px 44px rgba(15,23,42,0.13)`.
- 8-pt grid alignment for headings, cards, inputs.

### Bottom navigation (headline change)

Floating white bar, `border-radius:22px`, soft shadow, **4 tabs**: Home · Account ·
Orders · Settings. Active tab = solid `#2563EB` pill with icon **+ label**; idle tabs
= icon-only `#7E8AA0`. Source: `CFNav.dc.html`.

## Screen Mapping (redesign → Flutter)

Reconcile, do not duplicate. The Flutter app already has equivalents for several
new redesign screens.

| Redesign screen | Flutter target | Action |
|---|---|---|
| My CartFly address | _none_ | **New** `lib/features/address/my_address_screen.dart` + route |
| Declare a package (pre-alert) | `create_shipment_screen.dart` | Extend: store, tracking#, category chips, est value, qty |
| My packages inbox | `orders_screen.dart` | Reshape to All / At-warehouse / In-transit tabs + status pills |
| Plan payment | `payment_screen.dart` | Restyle to plan-checkout layout (method select, card fields) |
| Plan confirmed / Thank-you | `payment_success_screen.dart` | Restyle to receipt layout |
| Shipping Calculator (3-step) | _none (hub is separate)_ | **New** calculator screen; keep existing order hub too |
| All other journey screens | existing features | Re-skin only (inherit theme + widgets) |

Numbers/content for the calculator are fixed by the source: China→Egypt, 2.5 KG,
$12 shipping + $8 customs + $3 service = **$23.00**, 7–10 days.

## Affected shared widgets

Re-skin propagates through shared widgets, so most screens need no per-screen edits:

- `cf_bottom_nav.dart` — rebuilt floating 4-tab pill nav.
- `cf_button.dart` — solid `#2563EB` fill.
- `cf_input.dart` — `#F1F3F5` fill, label above, soft shadow, no hard border.
- `cf_card.dart` — white, `#E2E8F0` border, 16px radius, soft elevation.
- `cf_background.dart` — watermark opacity → ~5%.
- `cf_status_timeline.dart` — responsive stepper, absolute connectors centered on
  circles, labels wrap without breaking alignment.
- `cf_flag_card.dart` / flag chips — real `country_flags` flags everywhere.
- `cf_top_bar.dart`, `cf_scaffold.dart`, `cf_list_row.dart`, `cf_states.dart` —
  token refresh.

## Architecture & isolation

- **Theme layer** (`lib/theme/app_colors.dart`, `app_text.dart`, `app_theme.dart`)
  is the single source of truth for tokens. Screens reference tokens, never raw hex.
- **Widgets layer** owns visual structure; screens compose widgets. A screen should
  be understandable without reading widget internals.
- **New screens** each own one purpose, pull static content from `lib/data`, and
  route via `lib/router/routes.dart` + `app_router.dart`.
- New routes registered in `routes.dart`; nav-reachable screens wired into the shell
  that hosts `CfBottomNav`.

## Localization

- All new user-facing strings added to both `lib/l10n/app_en.arb` and `app_ar.arb`,
  regenerating `app_localizations*.dart`. No hardcoded English in new screens.
- RTL verified for new screens and the new bottom nav.

## Testing Strategy

- **Per-stage gate:** after each stage, dispatch fresh `ui-ux-pro-max` review agents;
  capture Flutter-web/Playwright screenshots; compare against `html/.refs/` baselines
  and the redesign mockups; fix findings before advancing.
- **Final sweep:** parallel multi-agent review across all screens — visual
  consistency, bottom-nav correctness, RTL, contrast/a11y, content fidelity.
- **Regression:** existing `integration_test/` and widget tests stay green;
  `flutter analyze` clean.

## Stages (each independently shippable)

1. Theme tokens.
2. Shared widgets (incl. new `CfBottomNav`).
3. Auth + onboarding screens.
4. Home / warehouses / country locations / lockers.
5. Plans + Shipping Calculator + plan payment/thank-you.
6. Shipments: Declare-package (create_shipment), My packages (orders), My address (new).
7. Settings / profile / info screens.
8. Final multi-agent sweep + full RTL pass.

## Out of scope

- Backend/Firestore schema changes (Auth + Firestore wiring stays as-is).
- The 🟠 "important" gaps from the transcript not already covered (e.g. manage/cancel
  subscription, order-history list) unless they map to an existing screen.
- The case-study sections of the bundle (UX audit, flow map, customer story) — these
  are presentation artifacts, not app screens.

## Non-obvious risks

- `google_fonts` pinned version may lack a font (the old code already worked around
  "Alan Sans"). Verify Playfair + Inter resolve; fall back without crashing.
- Folding Declare-package into `create_shipment` must not break the existing shipment
  create flow / tests.
- Reshaping `orders` into a tabbed inbox must preserve existing order data binding.
