import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cartfly/data/models/order.dart';
import 'package:cartfly/data/repositories/order_repository.dart';

void main() {
  test('create then stream returns the order; advance moves status', () async {
    final db = FakeFirebaseFirestore();
    final repo = OrderRepository(db: db, uid: 'u1');
    final id = await repo.create(Order(
        id: '',
        title: 'Shoes',
        sourceCountry: 'us',
        deliveryMethod: DeliveryMethod.home,
        createdAt: DateTime.utc(2026, 1, 1)));
    final list = await repo.watch().first;
    expect(list.length, 1);
    expect(list.first.title, 'Shoes');

    await repo.advance(id);
    final after = await repo.watch().first;
    expect(after.first.status, OrderStatus.atWarehouse);
  });
}
