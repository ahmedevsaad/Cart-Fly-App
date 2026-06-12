# CartFly Clean-Room UI Rebuild — Design Spec

_Date: 2026-06-12_
_Supersedes the visual approach of `2026-06-12-cartfly-redesign-design.md` (re-skin). Source of
truth unchanged: the Claude Design handoff bundle `CartFly Redesign.dc.html` + `CFNav.dc.html`._

## Purpose

Rebuild the entire CartFly **visual layer** from zero as a strict 1:1 port of the design frames,
replacing the incremental re-skin. Motivation: the fresh-agent sweep found the re-skin relied on
Material-icon approximations and accumulated drift. A clean-room rebuild fixes fidelity at the root
— a design-exact foundation + a real extracted SVG icon set + per-frame pixel ports.

Hard constraint (unchanged): content verbatim, real country flags, bilingual EN + AR with RTL.

## Scope (confirmed with user)

- **Delete & rebuild the whole UI layer**: `lib/theme/*`, `lib/widgets/*`, every `lib/features/**/*_screen.dart`.
- **Keep untouched** (the app's logic/data): `lib/router/*`, `lib/state/*`, `lib/data/*`,
  `lib/l10n/*`, `lib/features/auth/auth_provider.dart`, repositories, `main.dart`, `app.dart`,
  Firebase config.
- **Rebuild on the current branch** `redesign/cartfly-ui` (keep the 13 re-skin commits as history;
  delete + recreate the visual files on top).
- **Strict 1:1 fidelity** per design frame (exact colors/spacing/icons; custom SVGs, not Material
  approximations).

## Compile-safety principle (critical)

The rebuilt `cf_*` widgets MUST preserve the same **public class names and constructor signatures**
the router and screens already use (`CfScaffold`, `CfTopBar`, `CfButton`, `CfInput`, `CfCard`,
`CfListRow`, `CfBottomNav`, `CfStatusTimeline`, `CfBackground`, `CfFlagCard`, `CfStates`).
Rebuilt screens keep their existing **class names + constructor signatures** so the router stays
valid. This lets the foundation be replaced first while the app still compiles, then screens swap
group-by-group with `flutter analyze` green at every commit. Internals, visuals, and icons are
rebuilt from zero; only the public API surface is held stable.

## Foundation

### Icon set (the key new asset)
Extract the exact SVG path bodies from `CartFly Redesign.dc.html` and `CFNav.dc.html` into a typed
icon kit `lib/widgets/icons/cf_icons.dart` rendered via `flutter_svg` `SvgPicture.string` (or
`CustomPainter`), color-templated. Cover at minimum: nav (home, account, orders, settings), home
service cards (warehouses, lockers, plans, cart-calculator), stepper per-step (bag, box, truck,
check), barcode, paypal/apple/card, copy, chevrons (right/back/up), location pin, globe-with-pin,
star, plus/add, sign-out. No `Icons.*` Material stand-ins for design-specified glyphs.

### Tokens (`lib/theme/app_colors.dart`)
Design-exact, complete from the start: primary `#2563EB`, navy `#16335E`, text `#0F172A`, fieldBg
`#F1F3F5`, cardBorder `#E2E8F0`, navBarBorder `#EAEFF5`, muted `#64748B`, mutedLabel `#475569`,
mutedDisabled `#94A3B8`, success `#15803D`/successBg `#DCFCE7`, navIdle `#7E8AA0`, chipBlue
`#CFE0FB`, teal `#0D9488`/tealDark `#0F766E`/tealBg `#F0FDFA`, planPrime `#7C3AED`/planPrimeBg
`#F5F0FF`/planPrimeBorder `#E4D5FF`, planFree `#16A34A`, radioIdle `#CBD5E1`, tagBg `#E3E8EE`,
calcCardBg `#EAF1FE`/calcDivider `#C5D6F3`, deliveryBg `#ECFBF0`/deliveryIconBg `#D2F1DC`, warn*
(`#FFFBEB`/`#FCEFC7`/`#E0A800`/`#92740C`), status amber/blue + bg, signOutBg `#FA5D5F`,
dashedDivider `#D5DCE3`. Radii: field 12, card 16, nav 22, pill 999. Shadows: soft
`0 1px 3px rgba(15,23,42,.05)`, nav `0 8px 26px rgba(15,23,42,.13)`.

### Typography (`lib/theme/app_text.dart`)
Playfair Display 800 (logo, `#2563EB`) + Inter (everything). Scale matched to frames.

### Widget kit (`lib/widgets/`)
Rebuilt internals against tokens + icon set, API-stable:
- `cf_bottom_nav.dart` — floating white bar r22, navBarBorder, soft shadow, 4 tabs
  (Home·Account·Orders·Settings), active = solid `#2563EB` pill w/ SVG icon + label, idle = SVG
  icon-only `#7E8AA0`; InkWell ripple + Semantics; ≥44px targets; safe-area bottom.
- `cf_button.dart` — solid `#2563EB`, white Inter w700; true `CfOutlineButton` variant.
- `cf_input.dart` — label (Inter w700 13 `#475569`) + gray field r12, hairline `#E2E8F0`, optional
  password toggle, no harsh border.
- `cf_card.dart` — white, `#E2E8F0` border, r16, soft shadow.
- `cf_status_timeline.dart` — responsive (Expanded steps, connectors centered on circles, labels
  wrap), per-step SVG icons, active `#CFE0FB`/idle white-bordered states.
- `cf_dashed.dart` — `CfDashedDivider` + `CfDashedBorderPainter`.
- `cf_background.dart` (≤5% watermark, ColoredBox short-circuit), `cf_top_bar.dart`,
  `cf_scaffold.dart`, `cf_list_row.dart`, `cf_states.dart`, `cf_flag_card.dart` (real
  `country_flags`).

## Screen ports (31 frames + calculator)

Each screen is a strict 1:1 port. Frame → HTML lines → Flutter file mapping is the same table as
`docs/superpowers/plans/2026-06-12-cartfly-redesign.md` (reuse it). New/kept-net-new screens: My
address (`features/address/`), Shipping Calculator (`features/calculator/`). Declare/My-packages/
plan-checkout/receipt fold into create_shipment / orders / payment / payment_success as before. The
existing functional create-shipment order flow is preserved (not deleted).

Per-screen rules: read the exact frame HTML line range first; tokens + cf_* widgets + cf_icons only
(no raw hex except flag paints; no `Icons.*` for design glyphs; no inline fontFamily); content
verbatim; new strings to BOTH ARB files (most already exist from the re-skin — reuse); LTR + RTL via
`EdgeInsetsDirectional`; ≥44px tap targets + Semantics on interactive elements.

## Testing

- Per stage: `flutter analyze` clean, `flutter test` 9/9 green; fresh `ui-ux-pro-max` code-review gate.
- Final: `flutter build web` passes; a **rendered** browser comparison (Playwright phone-viewport
  screenshots of the live app vs each design frame); RTL pass.

## Stages (each green + committed)

0. Extract SVG icon set → `lib/widgets/icons/cf_icons.dart`.
1. Foundation: theme (colors/text/theme) + rebuilt `cf_*` widgets (API-stable) + nav + dashed.
2. Onboarding: Welcome, Register, Login, How-it-works.
3. Discover: Home, Warehouses, 5 country pages, Lockers.
4. Plans + Shipping Calculator + plan payment + plan confirmed.
5. Ship (My address, Declare, My packages) + Order/Track (Order hub, Confirm, Payment, Track).
6. Account: Profile, Settings, Currency, Language, About, Support.
7. Final: rendered browser comparison + RTL pass + finish branch.

## Out of scope

- Backend/Firestore, router structure, providers, data models, l10n string content (kept).
- Re-deriving content (reuse the ARB keys already added during the re-skin).

## Non-obvious risks

- Holding `cf_*` public APIs stable is mandatory; changing a signature breaks the router and every
  consumer mid-rebuild. If a screen genuinely needs a new widget param, add it as optional with a
  default.
- `flutter_svg` rendering of templated SVG strings must be verified early (Stage 0) before screens
  depend on the icon kit.
- The l10n generated files (`app_localizations*.dart`) are kept; if a screen needs a new key, add to
  ARB and regenerate — do not hand-break them.
