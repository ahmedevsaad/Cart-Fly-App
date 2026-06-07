# Stage 7 — Plans & Simulated Payment

**Goal:** Plan chooser + plan detail → simulated card payment → success/error → set `users/{uid}.plan`.

**Prereq:** Stage 6 complete.

**Files:**
- Create: `lib/data/repositories/user_repository.dart`
- Create: `lib/state/plan_provider.dart`
- Create: `lib/features/plans/plans_screen.dart`, `plan_detail_screen.dart`
- Create: `lib/features/payment/payment_screen.dart`, `payment_success_screen.dart`, `payment_error_screen.dart`
- Create: `lib/data/plans.dart` (static plan content)
- Modify: `lib/app.dart` (PlanProvider), `lib/router/app_router.dart` (plan/payment routes)
- Test: `test/repositories/user_repository_test.dart`
- Reference visuals: `html/screens/{our-plans,plan-prime,our-plans-3,our-plans-7,our-plans-6}.html`

---

### Task 7.1: Static plan data

**Files:** Create `lib/data/plans.dart`

- [ ] **Step 1:** Define the three plans (content lifted from `html/screens/plan-*.html`).

```dart
class Plan {
  const Plan({required this.code, required this.name, required this.price,
      required this.features});
  final String code;          // basic|smart|prime
  final String name;          // Basic cart ...
  final String price;         // "19.99 USD/per month" or "Free"
  final List<String> features;
}

const plans = <Plan>[
  Plan(code: 'basic', name: 'Basic cart', price: 'Free', features: [
    'Standard shipping rates', 'Basic support',
  ]),
  Plan(code: 'smart', name: 'Smart cart', price: '9.99 USD/per month', features: [
    'Discounted shipping', 'Cart cost calculator', 'Priority support',
  ]),
  Plan(code: 'prime', name: 'Prime cart', price: '19.99 USD/per month', features: [
    'Higher discount rates', 'Discounts on liquid products',
    'Smart calculator service',
  ]),
];
```

- [ ] **Step 2: Commit.**

### Task 7.2: UserRepository (TDD)

**Files:** Create `lib/data/repositories/user_repository.dart`; Test `test/repositories/user_repository_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cartfly/data/repositories/user_repository.dart';

void main() {
  test('setPlan and setCurrency write user fields', () async {
    final db = FakeFirebaseFirestore();
    await db.collection('users').doc('u1').set({'name': 'A'});
    final repo = UserRepository(db: db, uid: 'u1');
    await repo.setPlan('prime');
    await repo.setCurrency('SAR');
    final doc = await db.collection('users').doc('u1').get();
    expect(doc.data()!['plan'], 'prime');
    expect(doc.data()!['currency'], 'SAR');
  });
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Implement**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserRepository {
  UserRepository({required FirebaseFirestore db, required this.uid}) : _db = db;
  final FirebaseFirestore _db;
  final String uid;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _db.collection('users').doc(uid);

  Future<AppUser> getProfile() async {
    final d = await _doc.get();
    return AppUser.fromMap(uid, d.data() ?? {});
  }

  Future<void> updateProfile({String? name, String? phone, String? country}) =>
      _doc.update({
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (country != null) 'country': country,
      });

  Future<void> setPlan(String plan) => _doc.update({'plan': plan});
  Future<void> setCurrency(String currency) => _doc.update({'currency': currency});
}
```

- [ ] **Step 4: Run → passes. Commit.**

### Task 7.3: PlanProvider

**Files:** Create `lib/state/plan_provider.dart`

- [ ] **Step 1:** Holds current plan (read from `AuthProvider.state.user`), exposes `subscribe(code)` → `UserRepository.setPlan` then refreshes the auth profile (call a new `AuthProvider.refreshProfile()` — add it: re-run `_onAuthChange(currentUser)`).

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/repositories/user_repository.dart';

class PlanProvider extends ChangeNotifier {
  PlanProvider({required this.uid, FirebaseFirestore? db})
      : _repo = UserRepository(db: db ?? FirebaseFirestore.instance, uid: uid);
  final String uid;
  final UserRepository _repo;

  Future<void> subscribe(String code) async {
    await _repo.setPlan(code);
    notifyListeners();
  }
}
```

- [ ] **Step 2:** Add `Future<void> refreshProfile()` to `AuthProvider` (`lib/features/auth/auth_provider.dart`):

```dart
Future<void> refreshProfile() async {
  final u = _auth.currentUser;
  if (u != null) await _onAuthChange(u);
}
```

- [ ] **Step 3:** Wire `PlanProvider` into the **same authenticated-scoped `MultiProvider`** inside `MaterialApp.router`'s `builder:` (added for `OrdersProvider` in Stage 6, Task 6.3) — add one line to that providers list:

```dart
        ChangeNotifierProvider(create: (_) => PlanProvider(uid: uid)),
```
Screens read `context.read<PlanProvider>()` (non-nullable on authenticated routes). Do NOT reintroduce the proxy-create-in-update pattern. Analyze + commit.

### Task 7.4: Plan routes

**Files:** Modify `lib/router/app_router.dart`

```dart
GoRoute(path: Routes.plans, builder: (_, __) => const PlansScreen()),
GoRoute(path: Routes.planDetail,
    builder: (_, s) => PlanDetailScreen(code: s.pathParameters['code']!)),
GoRoute(path: Routes.payment,
    builder: (_, s) => PaymentScreen(forItem: s.uri.queryParameters['for'] ?? '')),
GoRoute(path: Routes.paymentSuccess, builder: (_, __) => const PaymentSuccessScreen()),
GoRoute(path: Routes.paymentError, builder: (_, __) => const PaymentErrorScreen()),
```

### Task 7.5: Plans chooser + detail

**Files:** `plans_screen.dart`, `plan_detail_screen.dart`

- [ ] **Step 1: PlansScreen** — "Our Plans" + a `CfCard` list of `plans` (Basic/Smart/Prime) → tap → `/plans/{code}`. (Mirrors `html/screens/our-plans.html`.)
- [ ] **Step 2: PlanDetailScreen** — show the selected plan's features + price. `CfButton('Subscribe now')`:
  - If `plan.price == 'Free'` (basic): call `context.read<PlanProvider>().subscribe('basic')` then `context.go(Routes.paymentSuccess)`.
  - Else → `context.push('${Routes.payment}?for=plan_${plan.code}')`.
- [ ] **Step 3: Analyze + commit.**

### Task 7.6: Simulated payment

**Files:** `payment_screen.dart`, `payment_success_screen.dart`, `payment_error_screen.dart`

- [ ] **Step 1: PaymentScreen** — card form: `CfInput('Card holder name')`, `CfInput('Card number')`, `CfInput('CVV')`. **No card data is stored.** `CfButton('Confirm')`:
  - Parse `forItem` (`plan_<code>`). Basic validation: all fields non-empty and card number length ≥ 12. If invalid → `context.go(Routes.paymentError)`.
  - On valid: if it's a plan, `await context.read<PlanProvider>().subscribe(code)` then `await context.read<AuthProvider>().refreshProfile()`; → `context.go(Routes.paymentSuccess)`.

```dart
final forItem = widget.forItem;            // e.g. "plan_prime"
if (!_valid()) { context.go(Routes.paymentError); return; }
if (forItem.startsWith('plan_')) {
  final code = forItem.substring('plan_'.length);
  await context.read<PlanProvider>().subscribe(code);
  await context.read<AuthProvider>().refreshProfile();
}
if (context.mounted) context.go(Routes.paymentSuccess);
```

- [ ] **Step 2: PaymentSuccessScreen** — "Payment Successful" + `CfButton('Done')` → `context.go(Routes.home)`. (Mirrors `html/screens/our-plans-7.html`.)
- [ ] **Step 3: PaymentErrorScreen** — "Payment Error" + `CfButton('Try again')` → `context.pop()` (back to the card form). (Mirrors `our-plans-6.html`.)
- [ ] **Step 4: Run tests** (`flutter test` → PASS) + **Analyze**.
- [ ] **Step 5: Manual** — Subscribe to Prime → card form → Confirm → Success → Home; check `users/{uid}.plan == 'prime'` in Firestore console; Profile shows the plan (Stage 8 wires display).
- [ ] **Step 6: Commit** — `git commit -m "feat(stage7): plans + simulated payment + subscription"`.

---

## Stage exit check
- `flutter test` → user_repository tests pass.
- Subscribing to a paid plan runs the card form → success → sets `user.plan` in Firestore.
- Invalid card → error screen → retry returns to the form.
- Basic (free) plan subscribes without the payment form.
