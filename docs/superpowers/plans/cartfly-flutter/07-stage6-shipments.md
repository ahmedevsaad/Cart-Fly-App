# Stage 6 — Shipments (create + track, Firestore)

**Goal:** The core functional loop — create a shipment, persist it to Firestore, list shipments, view details, and track status. Status advances via a demo action (no real logistics backend).

**Prereq:** Stage 5 complete.

**Files:**
- Create: `lib/data/models/order.dart` (+ `OrderStatus` enum)
- Create: `lib/data/repositories/order_repository.dart`
- Create: `lib/state/orders_provider.dart`
- Create: `lib/features/shipments/create_shipment_screen.dart`, `orders_screen.dart`, `order_detail_screen.dart`, `track_order_screen.dart`
- Modify: `lib/app.dart` (add `OrdersProvider`), `lib/router/app_router.dart` (orders routes)
- Tests: `test/models/order_test.dart`, `test/repositories/order_repository_test.dart` (fake Firestore)
- Reference visuals: `html/screens/{order-details,menu-2}.html`

**Add dev dependency** for repository tests:
```bash
flutter pub add --dev fake_cloud_firestore
```

---

### Task 6.1: Order model (TDD)

**Files:** Create `lib/data/models/order.dart`; Test `test/models/order_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cartfly/data/models/order.dart';

void main() {
  test('OrderStatus.next advances and stops at delivered', () {
    expect(OrderStatus.placed.next, OrderStatus.atWarehouse);
    expect(OrderStatus.ready.next, OrderStatus.delivered);
    expect(OrderStatus.delivered.next, OrderStatus.delivered);
  });

  test('Order round-trips through map', () {
    final o = Order(
      id: 'x', title: 'Zara jacket', sourceCountry: 'us',
      deliveryMethod: DeliveryMethod.home, status: OrderStatus.placed,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final m = o.toMap();
    final back = Order.fromMap('x', m);
    expect(back.title, 'Zara jacket');
    expect(back.status, OrderStatus.placed);
    expect(back.deliveryMethod, DeliveryMethod.home);
  });
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Implement**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { placed, atWarehouse, packaging, shipped, ready, delivered }

extension OrderStatusX on OrderStatus {
  OrderStatus get next =>
      this == OrderStatus.delivered ? this : OrderStatus.values[index + 1];
  String get id => name;
  static OrderStatus fromId(String s) =>
      OrderStatus.values.firstWhere((e) => e.name == s, orElse: () => OrderStatus.placed);
}

enum DeliveryMethod { locker, home }

class Order {
  Order({
    required this.id,
    required this.title,
    required this.sourceCountry,   // sa|eg|ae|us|cn
    required this.deliveryMethod,
    this.lockerId,
    this.status = OrderStatus.placed,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String sourceCountry;
  final DeliveryMethod deliveryMethod;
  final String? lockerId;
  final OrderStatus status;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
        'title': title,
        'sourceCountry': sourceCountry,
        'deliveryMethod': deliveryMethod.name,
        'lockerId': lockerId,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory Order.fromMap(String id, Map<String, dynamic> m) => Order(
        id: id,
        title: m['title'] as String? ?? '',
        sourceCountry: m['sourceCountry'] as String? ?? '',
        deliveryMethod: (m['deliveryMethod'] == 'locker')
            ? DeliveryMethod.locker : DeliveryMethod.home,
        lockerId: m['lockerId'] as String?,
        status: OrderStatusX.fromId(m['status'] as String? ?? 'placed'),
        createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );

  Order copyWith({OrderStatus? status}) => Order(
        id: id, title: title, sourceCountry: sourceCountry,
        deliveryMethod: deliveryMethod, lockerId: lockerId,
        status: status ?? this.status, createdAt: createdAt,
      );
}
```

- [ ] **Step 4: Run → passes. Commit.**

### Task 6.2: OrderRepository (TDD with fake_cloud_firestore)

**Files:** Create `lib/data/repositories/order_repository.dart`; Test `test/repositories/order_repository_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cartfly/data/models/order.dart';
import 'package:cartfly/data/repositories/order_repository.dart';

void main() {
  test('create then stream returns the order; advance moves status', () async {
    final db = FakeFirebaseFirestore();
    final repo = OrderRepository(db: db, uid: 'u1');
    final id = await repo.create(Order(
      id: '', title: 'Shoes', sourceCountry: 'us',
      deliveryMethod: DeliveryMethod.home, createdAt: DateTime.utc(2026, 1, 1)));
    final list = await repo.watch().first;
    expect(list.length, 1);
    expect(list.first.title, 'Shoes');

    await repo.advance(id);
    final after = await repo.watch().first;
    expect(after.first.status, OrderStatus.atWarehouse);
  });
}
```

- [ ] **Step 2: Run → fails.**

- [ ] **Step 3: Implement**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart';

class OrderRepository {
  OrderRepository({required FirebaseFirestore db, required this.uid}) : _db = db;
  final FirebaseFirestore _db;
  final String uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(uid).collection('orders');

  Future<String> create(Order o) async {
    final ref = await _col.add(o.toMap());
    return ref.id;
  }

  Stream<List<Order>> watch() => _col
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map((d) => Order.fromMap(d.id, d.data())).toList());

  Future<void> advance(String id) async {
    final doc = await _col.doc(id).get();
    final current = Order.fromMap(id, doc.data()!);
    await _col.doc(id).update({'status': current.status.next.name});
  }

  Future<Order> getOnce(String id) async {
    final doc = await _col.doc(id).get();
    return Order.fromMap(id, doc.data()!);
  }
}
```

- [ ] **Step 4: Run → passes. Commit.**

### Task 6.3: OrdersProvider

**Files:** Create `lib/state/orders_provider.dart`

- [ ] **Step 1: Implement** — holds the live list, exposes create/advance. Constructed with the current uid (from `AuthProvider`).

```dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/models/order.dart';
import '../data/repositories/order_repository.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider({required String uid, FirebaseFirestore? db})
      : _repo = OrderRepository(db: db ?? FirebaseFirestore.instance, uid: uid) {
    _sub = _repo.watch().listen((list) { _orders = list; notifyListeners(); });
  }
  final OrderRepository _repo;
  late final StreamSubscription _sub;
  List<Order> _orders = [];
  List<Order> get orders => _orders;
  Order? get latest => _orders.isEmpty ? null : _orders.first;

  Future<String> create(Order o) => _repo.create(o);
  Future<void> advance(String id) => _repo.advance(id);

  @override
  void dispose() { _sub.cancel(); super.dispose(); }
}
```

- [ ] **Step 2: Wire it AUTHENTICATED-SCOPED, ABOVE go_router's Navigator** (grill-with-docs decision — do NOT create the notifier inside `ChangeNotifierProxyProvider.update`; that anti-pattern causes state loss + double-dispose).

`OrdersProvider` needs a uid that only exists when authenticated. Inject it via `MaterialApp.router`'s `builder:` callback, which wraps **above** go_router's Navigator and is therefore visible to **every route** (shell tabs *and* top-level pushed routes like create-shipment/track). Gate on `uid` and key by `uid` so it's created only when authenticated and recreated/disposed cleanly if the user changes.

Modify `lib/app.dart` — add the `builder:` to `MaterialApp.router`:

```dart
MaterialApp.router(
  // ...existing title/theme/locale/delegates/routerConfig...
  builder: (context, child) {
    final uid = context.watch<AuthProvider>().state.user?.uid;
    if (uid == null) return child!;            // unauthenticated: no order/plan scope
    return MultiProvider(
      key: ValueKey(uid),                      // rebuild ⇒ dispose old, create new on uid change
      providers: [
        ChangeNotifierProvider(create: (_) => OrdersProvider(uid: uid)),
        // PlanProvider added to this same list in Stage 7
      ],
      child: child!,
    );
  },
)
```

Screens read a **non-nullable** `OrdersProvider` via `context.watch<OrdersProvider>()` (it is guaranteed present on authenticated routes). `ChangeNotifierProvider` owns disposal — never dispose it manually.

- [ ] **Step 3: Analyze + commit.**

### Task 6.4: Routes for shipments

**Files:** Modify `lib/router/app_router.dart`

```dart
GoRoute(path: Routes.createShipment, builder: (_, __) => const CreateShipmentScreen()),
GoRoute(path: Routes.orders, builder: (_, __) => const OrdersScreen()),
GoRoute(path: Routes.orderDetail,
    builder: (_, s) => OrderDetailScreen(id: s.pathParameters['id']!)),
GoRoute(path: Routes.trackOrder,
    builder: (_, s) => TrackOrderScreen(id: s.pathParameters['id']!)),
```

### Task 6.5: Create-shipment screen (NEW)

**Files:** `lib/features/shipments/create_shipment_screen.dart`

- [ ] **Step 1:** Form: `CfInput('Item / title')`, a country dropdown (warehouse codes → display names from `data/warehouses.dart`), a delivery-method toggle (`Locker` / `Home`), and if `Locker` a locker dropdown (from `data/lockers.dart` for the chosen country). `CfButton('Create')`:

```dart
final id = await context.read<OrdersProvider>().create(Order(
  id: '', title: _title.text.trim(), sourceCountry: _country,
  deliveryMethod: _method, lockerId: _method == DeliveryMethod.locker ? _lockerId : null,
  status: OrderStatus.placed, createdAt: DateTime.now()));
if (context.mounted) context.pushReplacement('/orders/$id/track');
```
Guard: `OrdersProvider` is non-null here (user is authenticated to reach this route).

- [ ] **Step 2: Analyze + commit.**

### Task 6.6: Orders list + detail

**Files:** `orders_screen.dart`, `order_detail_screen.dart`

- [ ] **Step 1: OrdersScreen** — `context.watch<OrdersProvider>()` (non-nullable on authenticated routes); empty list → `CfEmptyState('No shipments yet')`; else a list of `CfCard`s (`title` + status label) → tap → `/orders/{id}`.
- [ ] **Step 2: OrderDetailScreen** — find the order in `provider.orders` by id; show title, source country, delivery method, status; `CfButton('Track')` → `/orders/{id}/track`.
- [ ] **Step 3: Analyze + commit.**

### Task 6.7: Track-order screen

**Files:** `track_order_screen.dart`

- [ ] **Step 1:** "Track your order" title + `CfStatusTimeline` with the 6 step labels and `activeIndex: order.status.index`. A demo `CfButton('Advance status')` → `context.read<OrdersProvider>().advance(id)` (the stream updates the timeline live). Reference `html/screens/menu-2.html`.

- [ ] **Step 2: Run all tests** — `flutter test` → PASS. **Analyze.**
- [ ] **Step 3: Manual** — create a shipment → see it in the orders list and on Home's order strip → open Track → tap Advance → timeline progresses; reopen the app (hot restart) → the shipment persists (Firestore).
- [ ] **Step 4: Commit** — `git commit -m "feat(stage6): shipments create/list/track (Firestore)"`.

### Task 6.8: Firestore security rules (documented)

**Files:** Create `firestore.rules` at repo root.

- [ ] **Step 1: Write owner-only rules**

```
rules_version = '2';
service cloud.firestore {
  match /databases/{db}/documents {
    match /users/{uid} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
      match /orders/{orderId} {
        allow read, write: if request.auth != null && request.auth.uid == uid;
      }
    }
  }
}
```

- [ ] **Step 2:** Deploy via Firebase console or `firebase deploy --only firestore:rules` (document the manual step; CLI optional for a university project). Commit the rules file.

---

## Stage exit check
- `flutter test` → all model + repository tests pass.
- Create shipment persists to Firestore and appears in the list + Home strip.
- Track timeline reflects status and advances live via the demo button.
- Security rules restrict orders to their owner.
