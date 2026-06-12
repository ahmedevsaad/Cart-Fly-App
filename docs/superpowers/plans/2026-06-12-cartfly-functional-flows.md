# CartFly Functional Flows + Nav Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Make the CartFly journey functional end-to-end (real order create→track, computed calculator, payment-driven state, plan subscribe) and show the floating bottom nav across journey screens, on branch `redesign/cartfly-ui`.

**Architecture:** The backend is already real (Firebase Auth + Firestore; `AuthProvider`, `OrdersProvider`/`OrderRepository`, `PlanProvider`/`UserRepository`). Wire the rebuilt screens to these providers, add a pricing table + app-level OTP (code + bypass) + sample-data seeding, and render the nav on pushed screens via a helper.

**Tech Stack:** Flutter 3.27/Dart 3.6, go_router, Provider, cloud_firestore, firebase_auth, fake_cloud_firestore (tests).

**Key existing APIs (use exactly):**
- `Order(id, title, sourceCountry[sa|eg|ae|us|cn], deliveryMethod[locker|home], lockerId?, status, createdAt)` + `toMap/fromMap/copyWith`; `OrderStatus{placed,atWarehouse,packaging,shipped,ready,delivered}`, `.next`.
- `OrdersProvider.create(Order)`, `.advance(id)`, `.orders`, `.latest`; `OrderRepository.watch/create/advance/getOnce`.
- `PlanProvider.subscribe(String code)` → `UserRepository.setPlan`.
- `AuthProvider`: `register(...)→pendingOtp`, `verifyCode` (NEW), `_onAuthChange`, `state.user`.

---

## Stage 1: Journey bottom nav

### Task 1.1: `cfJourneyNav` helper
**Files:** Create `lib/widgets/cf_journey_nav.dart`; Modify journey screens.
- [ ] **Step 1:** Implement the helper:

```dart
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../router/routes.dart';
import 'cf_bottom_nav.dart';

/// Floating nav for pushed journey screens. Highlights a tab and navigates on tap.
Widget cfJourneyNav(BuildContext context) {
  final loc = GoRouterState.of(context).matchedLocation;
  int index;
  if (loc.startsWith('/orders')) {
    index = 2;
  } else if (loc.startsWith('/profile')) {
    index = 1;
  } else if (loc.startsWith('/settings')) {
    index = 3;
  } else {
    index = 0; // home for warehouses/lockers/plans/calculator/my-address/etc.
  }
  const tabRoutes = [Routes.home, Routes.profile, Routes.orders, Routes.settings];
  return CfBottomNav(
    currentIndex: index,
    onTap: (i) => context.go(tabRoutes[i]),
  );
}
```

- [ ] **Step 2:** In each of these screens, pass `bottomNav: cfJourneyNav(context)` to their `CfScaffold`: `warehouses_screen.dart`, `lockers_screen.dart`, `country_lockers_screen.dart`, `plans_screen.dart`, `plan_detail_screen.dart`, `shipping_calculator_screen.dart`, `my_address_screen.dart`, `order_detail_screen.dart`, `track_order_screen.dart`. (Leave `payment_screen.dart`, `confirm_order_screen.dart`, auth/onboarding without it per their frames.)
- [ ] **Step 3:** `flutter analyze` clean; `flutter test` green. Commit: `feat(nav): floating journey nav on browse screens`.

---

## Stage 2: Auth — code OTP + bypass + seed

### Task 2.1: `verifyCode` + verification gate
**Files:** Modify `lib/features/auth/auth_provider.dart`.
- [ ] **Step 1:** Add near top: `const kOtpBypass = String.fromEnvironment('OTP_BYPASS', defaultValue: '000000');`
- [ ] **Step 2:** Add field `String? _pendingCode;` and a deterministic code in `register(...)` right before `_set(AuthState.pendingOtp(...))`: `_pendingCode = (cred.user!.uid.hashCode.abs() % 900000 + 100000).toString();` (6 digits). Keep the existing `sendEmailVerification()` call (harmless).
- [ ] **Step 3:** Add method:

```dart
Future<bool> verifyCode(String code) async {
  final u = _auth.currentUser;
  if (u == null) return false;
  if (code != kOtpBypass && code != _pendingCode) {
    _fail('errorAuth_invalid-otp');
    return false;
  }
  try {
    await _db.collection('users').doc(u.uid).set(
        {'verified': true}, SetOptions(merge: true));
  } catch (_) {}
  await _onAuthChange(u);
  return true;
}
```

- [ ] **Step 4:** Change the gate in `_onAuthChange`: replace `if (!u.emailVerified) { _set(pendingOtp...); return; }` with a Firestore-flag-aware check:

```dart
if (!u.emailVerified) {
  bool flag = false;
  try {
    final d = await _db.collection('users').doc(u.uid).get();
    flag = d.data()?['verified'] == true;
  } catch (_) {}
  if (!flag) { _set(AuthState.pendingOtp(email: u.email ?? '')); return; }
}
```

- [ ] **Step 5:** Test `verifyCode` with `fake_cloud_firestore` + a fake/mock `FirebaseAuth` if feasible; otherwise a unit test of the bypass-code comparison logic. `flutter analyze` clean. Commit: `feat(auth): code-based OTP verification with bypass code`.

### Task 2.2: Verify screen — code entry
**Files:** Modify `lib/features/auth/verify_screen.dart`.
- [ ] **Step 1:** Render a 6-digit code input; "Verify" calls `context.read<AuthProvider>().verifyCode(code)`; on true → router redirect carries the user to home; on false show an error. Add a visible hint line: "Demo code: 000000". Add new ARB keys `verifyCodeHint`, `verifyCodeLabel`, `verifyButton`, `errorAuth_invalid-otp` to BOTH ARB + regenerate (reuse existing verify keys if present).
- [ ] **Step 2:** `flutter analyze` clean; `flutter test` green. Commit: `feat(auth): verify screen code entry + demo hint`.

### Task 2.3: Seed sample orders
**Files:** Modify `lib/data/repositories/order_repository.dart`, and call site (e.g. `OrdersProvider` or post-verify).
- [ ] **Step 1:** Add to `OrderRepository`:

```dart
Future<void> seedSampleIfEmpty() async {
  final snap = await _col.limit(1).get();
  if (snap.docs.isNotEmpty) return;
  final now = DateTime.now();
  final samples = [
    Order(id: '', title: 'SHEIN dress', sourceCountry: 'cn',
        deliveryMethod: DeliveryMethod.home, status: OrderStatus.atWarehouse,
        createdAt: now.subtract(const Duration(days: 2))),
    Order(id: '', title: 'Anker charger', sourceCountry: 'us',
        deliveryMethod: DeliveryMethod.locker, status: OrderStatus.shipped,
        createdAt: now.subtract(const Duration(days: 5))),
    Order(id: '', title: 'Noon order', sourceCountry: 'ae',
        deliveryMethod: DeliveryMethod.home, status: OrderStatus.placed,
        createdAt: now.subtract(const Duration(days: 1))),
  ];
  for (final o in samples) { await _col.add(o.toMap()); }
}
```

- [ ] **Step 2:** Call `seedSampleIfEmpty()` once after a user becomes authenticated (e.g. in `OrdersProvider` constructor after first watch tick, guarded; or from `AuthProvider._onAuthChange` after `signedIn`). Make it fire-and-forget and idempotent (the emptiness check guards it).
- [ ] **Step 3:** `flutter analyze` clean; `flutter test` green. Commit: `feat(orders): seed sample packages for new users`.

---

## Stage 3: Shipping calculator pricing

### Task 3.1: Pricing table
**Files:** Create `lib/data/pricing.dart`; Test `test/data/pricing_test.dart`.
- [ ] **Step 1:** Implement:

```dart
class CalcResult {
  CalcResult(this.shipping, this.customs, this.service, this.minDays, this.maxDays);
  final double shipping, customs, service;
  double get total => shipping + customs + service;
  final int minDays, maxDays;
}

const _perKg = <String, double>{ // from->to keyed 'cn-eg' etc.; fallback default
  'cn-eg': 4.8, 'us-eg': 6.0, 'ae-eg': 3.0, 'sa-eg': 2.4, 'cn-sa': 4.0,
};
const _customsPct = <String, double>{
  'electronics': 0.10, 'fashion': 0.05, 'accessories': 0.04, 'other': 0.06,
};

CalcResult estimate({
  required String from, required String to, required double weightKg,
  required String category, double value = 80,
}) {
  final rate = _perKg['$from-$to'] ?? 4.8;
  final shipping = double.parse((rate * weightKg).clamp(5, 999).toStringAsFixed(2));
  final customs = double.parse(((_customsPct[category] ?? 0.06) * value).toStringAsFixed(2));
  const service = 3.0;
  return CalcResult(shipping, customs, service, 7, 10);
}
```
(Tune `cn-eg` rate so 2.5 KG → $12.00: 4.8×2.5=12.00 ✓; electronics customs 0.10×80=$8.00 ✓; service $3 → $23 total, matching the design example.)

- [ ] **Step 2:** Test: `estimate(from:'cn',to:'eg',weightKg:2.5,category:'electronics',value:80)` → shipping 12.0, customs 8.0, service 3.0, total 23.0. Run `flutter test test/data/pricing_test.dart` PASS.
- [ ] **Step 3:** Commit: `feat(pricing): shipping cost estimate table`.

### Task 3.2: Wire calculator
**Files:** Modify `lib/features/calculator/shipping_calculator_screen.dart`.
- [ ] **Step 1:** Make From/To/weight/category editable (default China/Egypt/2.5/electronics). On change, call `estimate(...)`; render the breakdown rows and total from `CalcResult` (formatted `$X.XX`), delivery `${minDays} – ${maxDays} Days`. Keep the design layout/styling.
- [ ] **Step 2:** `flutter analyze` clean; `flutter test` green. Commit: `feat(calculator): compute live cost from inputs`.

---

## Stage 4: Order create → track

### Task 4.1: Extend Order with declare metadata (optional fields)
**Files:** Modify `lib/data/models/order.dart`.
- [ ] **Step 1:** Add optional fields `store`, `trackingNumber`, `category`, `declaredValue` (double?), `quantity` (int?) to the constructor (all optional), include them in `toMap` (only when non-null) and read in `fromMap`; thread through `copyWith`. Keep existing required fields/behavior so current callers + tests don't break.
- [ ] **Step 2:** `flutter analyze` clean; `flutter test` green. Commit: `feat(model): order declare metadata fields`.

### Task 4.2: Create shipment writes a real order
**Files:** Modify `lib/features/shipments/create_shipment_screen.dart`.
- [ ] **Step 1:** On submit, build `Order(id:'', title: store-or-item, sourceCountry: selectedCode, deliveryMethod: selected, status: OrderStatus.placed, createdAt: DateTime.now(), store:, trackingNumber:, category:, declaredValue:, quantity:)` → `final id = await context.read<OrdersProvider>().create(order);` → `context.go(Routes.trackOrder.replaceFirst(':id', id))` (or order detail). Keep validation; guard against empty required fields.
- [ ] **Step 2:** `flutter analyze` clean; `flutter test` green. Commit: `feat(shipments): declare creates a real Firestore order`.

### Task 4.3: Order hub + track read real order + advance
**Files:** Modify `lib/features/shipments/order_detail_screen.dart`, `track_order_screen.dart`.
- [ ] **Step 1:** Both take an order `id`. Load the real order (`OrderRepository.getOnce(id)` via a provider, or find in `OrdersProvider.orders`). Drive the stepper from the real `OrderStatus`. Add an "Advance status" button (demo) → `context.read<OrdersProvider>().advance(id)` then refresh; hide it once `delivered`.
- [ ] **Step 2:** `flutter analyze` clean; `flutter test` green. Commit: `feat(track): real order status + advance`.

---

## Stage 5: Payment → state + plan subscribe + profile

### Task 5.1: Payment mutates state
**Files:** Modify `lib/features/payment/payment_screen.dart`.
- [ ] **Step 1:** Parse `forItem`: if it starts with `plan_`, plan mode → on Pay: `await context.read<PlanProvider>().subscribe(code)` → `context.go('${Routes.paymentSuccess}?plan=$code')`. If it starts with `order_` (or an id is provided), order mode → on Pay: `await context.read<OrdersProvider>().advance(orderId)` (mock-process) → `context.go(Routes.paymentSuccess)`. Card fields stay mock/display.
- [ ] **Step 2:** Ensure callers pass the right `for=` value: plan checkout from `plan_detail`/plans → `/payment?for=plan_<code>`; order checkout from confirm → `/payment?for=order_<id>`.
- [ ] **Step 3:** `flutter analyze` clean; `flutter test` green. Commit: `feat(payment): mock-process mutates plan/order state`.

### Task 5.2: Profile shows real user + plan
**Files:** Modify `lib/features/profile/profile_screen.dart`; ensure `PlanProvider` exposes current plan (add a `String? plan` loaded from `UserRepository.getProfile`/`AppUser.plan` if present).
- [ ] **Step 1:** Read `context.watch<AuthProvider>().state.user` for name/email/country/currency; read the active plan (from `AppUser.plan` or `PlanProvider`). Render them (expanded currency label per existing). Keep sign-out.
- [ ] **Step 2:** `flutter analyze` clean; `flutter test` green. Commit: `feat(profile): show real user + active plan`.

---

## Stage 6: Verify

### Task 6.1: Regression + rendered + real-auth walkthrough
- [ ] `flutter analyze` clean; `flutter test` green; `flutter build web --no-tree-shake-icons --dart-define=DEBUG_BYPASS_AUTH=true` succeeds.
- [ ] Fresh-agent rendered browser walkthrough (bypass build): nav shows on journey screens; calculator recomputes on input; order create → appears in packages → track advances; plan pay → profile shows plan.
- [ ] Real-auth path sanity (where Firebase reachable): register → code `000000` → seeded packages visible → create order → pay → advance → subscribe plan → profile shows plan.
- [ ] Fix findings. Commit. Then superpowers:finishing-a-development-branch.

---

## Self-review notes
- **Spec coverage:** nav→S1; OTP code+bypass+gate+seed→S2; calculator pricing→S3; order create→track+advance→S4; payment→state + plan + profile→S5; verify→S6. ✓
- **Real APIs used:** `OrdersProvider.create/advance`, `PlanProvider.subscribe`, `OrderStatus.next`, `AuthProvider` — names match the code. ✓
- **Calc default matches design:** cn-eg 4.8×2.5=12.0, electronics 0.10×80=8.0, service 3.0 → 23.0. ✓
- **No-break:** Order new fields optional; `_onAuthChange` keeps `emailVerified==true` valid (OR flag); seed idempotent. ✓
