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
}
