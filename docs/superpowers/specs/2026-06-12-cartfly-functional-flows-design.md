# CartFly Functional Flows + Nav — Design Spec

_Date: 2026-06-12_
_Branch: `redesign/cartfly-ui`. Builds on the clean-room UI rebuild._

## Purpose

Make the CartFly journey actually work end-to-end (real order creation, calculator,
payment-driven state, plan subscription) and show the floating bottom nav across the
main journey screens. The backend is already real: Firebase Auth + Firestore are
configured (live keys), `AuthProvider` uses real `FirebaseAuth`, and
`OrderRepository`/`OrdersProvider` read/write real Firestore. The gap is (a) some
screens are mock (calculator hardcodes $23, payment doesn't mutate state, plan
selection may not persist), (b) the bottom nav only renders on the 4 shell screens,
and (c) email verification is link-based; the user wants a code with a bypass.

## Scope (confirmed with user)

- Bottom nav: **floating nav on all main journey screens** (keep current routing).
- Make functional **end-to-end**: order create→track, shipping calculator, payment→state,
  plan subscribe + profile.
- Auth: **real Firebase + seed sample data**; email verification by **CODE not link**,
  with a **bypass code** (`000000`, overridable via `--dart-define=OTP_BYPASS`), shown as
  a hint on the verify screen.
- Order status progression: explicit **"Advance status"** demo affordance (uses
  `OrderRepository.advance()`), not real-time auto-advance.
- Same branch `redesign/cartfly-ui`.

## 1. Bottom nav across journey

- New helper `lib/widgets/cf_journey_nav.dart`: `CfBottomNav cfJourneyNav(BuildContext)`
  derives the active tab index from the current route (`GoRouterState.of(context)`),
  and its `onTap` does `context.go(<tabRoute>)` for Home/Account(Profile)/Orders/Settings.
- Wire it via `CfScaffold(bottomNav: cfJourneyNav(context))` on the browse/journey
  screens: warehouses, lockers, country lockers, plans, plan detail, calculator,
  my-address, order hub (order_detail), track. Modal step screens (payment, confirm)
  keep their back-flow per their frame.
- Active-tab mapping for non-tab routes: warehouses/lockers/country/plans/plan-detail/
  calculator/my-address → Home tab highlighted; order hub/track → Orders tab.

## 2. Auth: code OTP + bypass + seed

- `AuthProvider`:
  - Add `String? _pendingCode`. On `register(...)`, after `createUserWithEmailAndPassword`
    and the Firestore user doc write, generate a 6-digit code (deterministic, no
    `Math.random` constraints — derive from uid hash or a fixed demo code), store it,
    set `pendingOtp`. Do NOT require `sendEmailVerification` to gate (may still call it
    harmlessly).
  - Add `Future<bool> verifyCode(String code)`: passes if `code == _pendingCode` OR
    `code == kOtpBypass` (`const kOtpBypass = String.fromEnvironment('OTP_BYPASS',
    defaultValue: '000000')`). On success, write `users/{uid}.verified = true` and load
    profile → `signedIn`.
  - Change `_onAuthChange`: treat the user as verified when
    `u.emailVerified == true` **OR** Firestore `users/{uid}.verified == true`; else
    `pendingOtp`.
- `verify_screen.dart`: 6-digit code input (the existing scaffold), a visible hint that
  the demo/bypass code is `000000`, "Verify" → `verifyCode`, error on mismatch, a
  "resend"/back affordance.
- **Seed**: new helper `OrderRepository.seedSampleIfEmpty()` (or a provider method) that,
  on first authenticated load when the orders collection is empty, writes 2–3 sample
  orders (varied statuses: at-warehouse, in-transit, declared) so My Packages/Track are
  populated. Idempotent (guarded by emptiness + a `seeded` flag on the user doc).

## 3. Order create → track (real)

- `create_shipment_screen.dart`: collect store/merchant, tracking#, category, est value,
  qty, source country from the form fields → build `Order(...)` (match the `Order` model
  in `lib/data/models/order.dart`) → `context.read<OrdersProvider>().create(order)` →
  navigate to the created order's track/hub route. Preserve validation.
- `orders_screen.dart` (My Packages): already streams `OrdersProvider.orders`; ensure
  bucketing maps real `OrderStatus`.
- `order_detail_screen.dart` (hub) + `track_order_screen.dart`: load the real order by
  id (`OrderRepository.getOnce` / stream), render real status in the stepper. Add an
  "Advance status" button (demo) → `OrdersProvider.advance(id)` → UI reflects the new
  status.

## 4. Shipping calculator (real pricing)

- New `lib/data/pricing.dart`:
  - `double shippingCost(String fromCode, String toCode, double weightKg)` — per-kg rate
    by country pair (table) × weight, min floor.
  - `double customsFee(String category, double declaredValue)` — % by category.
  - `const serviceFee = 3.0` (or table).
  - `CalcResult estimate({from, to, weightKg, category, value})` → breakdown + total +
    delivery-days range.
- `shipping_calculator_screen.dart`: inputs (From/To country, weight, category, optional
  value) are editable; recompute the breakdown live; the design's China→Egypt/2.5 KG/$23
  becomes the default example produced by the table.

## 5. Payment → state

- `payment_screen.dart` "Pay":
  - **Order mode** (`for=order_<id>` or an order id param): mock-process, then
    `OrdersProvider.advance(id)` (or set a paid flag) → `/payment/success`.
  - **Plan mode** (`for=plan_<code>`): mock-process, then `PlanProvider.setPlan(code)`
    (persists to Firestore user doc via `user_repository.setPlan`) →
    `/payment/success?plan=<code>`.
- No real payment gateway; the card fields are display/mock. State mutation is real.

## 6. Plan subscribe + profile

- `PlanProvider.setPlan(code)` persists to the user profile (existing
  `user_repository.setPlan`); expose active plan.
- `profile_screen.dart`: read the real `AuthProvider.state.user` (name/email/country/
  currency) and the active plan from `PlanProvider`; show them. Sign-out works.

## Testing

- Per stage: `flutter analyze` clean, `flutter test` green (extend tests for pricing +
  `verifyCode` bypass + order-create where practical with `fake_cloud_firestore`).
- Final: `flutter build web --dart-define=DEBUG_BYPASS_AUTH=true` + rendered browser
  walkthrough; also a real-auth path check (register → code `000000` → seeded packages →
  create order → pay → track advance → subscribe plan → profile shows plan).

## Stages

1. Bottom nav across journey (`cf_journey_nav` + wire screens).
2. Auth: code OTP + bypass (`verifyCode`, `_onAuthChange`, verify screen) + seed.
3. Shipping calculator pricing (`pricing.dart` + screen).
4. Order create → track (create_shipment → order, hub/track real + advance).
5. Payment → state + plan subscribe + profile (payment mutations, PlanProvider, profile).
6. Verify: analyze/test + rendered walkthrough (bypass build) + real-auth flow check.

## Out of scope

- Real payment gateway / real email delivery (mock/bypass only).
- Real-time automatic status progression (explicit advance button instead).
- Backend schema changes beyond the `verified`/`seeded` user flags and the orders the app
  already writes.

## Non-obvious risks

- Changing `_onAuthChange` verification gate must not lock out existing real users; treat
  `emailVerified==true` as always-valid, add the Firestore flag as an OR.
- `Math.random`/`DateTime.now` constraints exist in workflow scripts but NOT in app code;
  the OTP code may use a fixed/derived value to stay deterministic and demo-friendly.
- Seeding must be idempotent (guard with emptiness + `seeded` flag) to avoid duplicate
  sample orders on every login.
- The calculator default must still reproduce the design example (China→Egypt 2.5 KG →
  $12+$8+$3=$23) so visual fidelity holds; tune the rate table to match.
