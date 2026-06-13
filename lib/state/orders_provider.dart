import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/foundation.dart';
import '../data/models/order.dart';
import '../data/repositories/order_repository.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider({required String uid, FirebaseFirestore? db, bool demo = false})
      : _demo = demo,
        _repo = demo
            ? null
            : OrderRepository(db: db ?? FirebaseFirestore.instance, uid: uid) {
    if (_demo) {
      _orders = [
        Order(
          id: 'demo1',
          title: 'SHEIN dress',
          sourceCountry: 'cn',
          deliveryMethod: DeliveryMethod.home,
          status: OrderStatus.atWarehouse,
          createdAt: DateTime(2026, 6, 10),
          store: 'SHEIN',
          trackingNumber: 'SF1234567890CN',
          category: 'fashion',
          declaredValue: 45,
          quantity: 1,
        ),
        Order(
          id: 'demo2',
          title: 'Anker charger',
          sourceCountry: 'us',
          deliveryMethod: DeliveryMethod.locker,
          status: OrderStatus.shipped,
          createdAt: DateTime(2026, 6, 7),
          store: 'Amazon',
          trackingNumber: '1Z999AA10123456784',
          category: 'electronics',
          declaredValue: 30,
          quantity: 2,
        ),
        Order(
          id: 'demo3',
          title: 'Noon order',
          sourceCountry: 'ae',
          deliveryMethod: DeliveryMethod.home,
          status: OrderStatus.placed,
          createdAt: DateTime(2026, 6, 11),
          store: 'Noon',
          trackingNumber: 'NOON-558210',
          category: 'accessories',
          declaredValue: 60,
          quantity: 1,
        ),
      ];
      // notify on next microtask so listeners registered after construction see data
      Future.microtask(() { if (!_disposed) notifyListeners(); });
    } else {
      _sub = _repo!.watch().listen((list) {
        if (_disposed) return;
        _orders = list;
        notifyListeners();
      });
      _repo.seedSampleIfEmpty().catchError((_) {});
    }
  }

  bool _disposed = false;
  final bool _demo;
  final OrderRepository? _repo;
  StreamSubscription<List<Order>>? _sub;
  List<Order> _orders = [];
  int _demoSeq = 100;
  List<Order> get orders => _orders;
  Order? get latest => _orders.isEmpty ? null : _orders.first;

  Future<String> create(Order o) {
    if (_demo) {
      final id = 'demo${++_demoSeq}';
      final inserted = Order(
        id: id,
        title: o.title,
        sourceCountry: o.sourceCountry,
        deliveryMethod: o.deliveryMethod,
        lockerId: o.lockerId,
        status: o.status,
        createdAt: o.createdAt,
        store: o.store,
        trackingNumber: o.trackingNumber,
        category: o.category,
        declaredValue: o.declaredValue,
        quantity: o.quantity,
      );
      _orders = [inserted, ..._orders];
      notifyListeners();
      return Future.value(id);
    }
    return _repo!.create(o);
  }

  Future<void> advance(String id) {
    if (_demo) {
      final idx = _orders.indexWhere((o) => o.id == id);
      if (idx != -1) {
        _orders = List.of(_orders);
        _orders[idx] = _orders[idx].copyWith(status: _orders[idx].status.next);
        notifyListeners();
      }
      return Future.value();
    }
    return _repo!.advance(id);
  }

  Future<Order> getOnce(String id) {
    if (_demo) {
      final order = _orders.firstWhere(
        (o) => o.id == id,
        orElse: () => throw StateError('Demo order $id not found'),
      );
      return Future.value(order);
    }
    return _repo!.getOnce(id);
  }

  @override
  void dispose() {
    _disposed = true;
    _sub?.cancel();
    super.dispose();
  }
}
