import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/foundation.dart';
import '../data/models/order.dart';
import '../data/repositories/order_repository.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider({required String uid, FirebaseFirestore? db})
      : _repo = OrderRepository(
            db: db ?? FirebaseFirestore.instance, uid: uid) {
    _sub = _repo.watch().listen((list) {
      _orders = list;
      notifyListeners();
    });
    _repo.seedSampleIfEmpty().catchError((_) {});
  }
  final OrderRepository _repo;
  late final StreamSubscription<List<Order>> _sub;
  List<Order> _orders = [];
  List<Order> get orders => _orders;
  Order? get latest => _orders.isEmpty ? null : _orders.first;

  Future<String> create(Order o) => _repo.create(o);
  Future<void> advance(String id) => _repo.advance(id);
  Future<Order> getOnce(String id) => _repo.getOnce(id);

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
