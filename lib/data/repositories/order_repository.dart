import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order.dart';

class OrderRepository {
  OrderRepository({required FirebaseFirestore db, required this.uid})
      : _db = db;
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

  Future<void> seedSampleIfEmpty() async {
    final snap = await _col.limit(1).get();
    if (snap.docs.isNotEmpty) return;
    final now = DateTime.now();
    final samples = [
      Order(id: '', title: 'SHEIN dress', sourceCountry: 'cn', deliveryMethod: DeliveryMethod.home, status: OrderStatus.atWarehouse, createdAt: now.subtract(const Duration(days: 2))),
      Order(id: '', title: 'Anker charger', sourceCountry: 'us', deliveryMethod: DeliveryMethod.locker, status: OrderStatus.shipped, createdAt: now.subtract(const Duration(days: 5))),
      Order(id: '', title: 'Noon order', sourceCountry: 'ae', deliveryMethod: DeliveryMethod.home, status: OrderStatus.placed, createdAt: now.subtract(const Duration(days: 1))),
    ];
    for (final o in samples) { await _col.add(o.toMap()); }
  }
}
