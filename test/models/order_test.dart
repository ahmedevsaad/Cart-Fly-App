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
      id: 'x',
      title: 'Zara jacket',
      sourceCountry: 'us',
      deliveryMethod: DeliveryMethod.home,
      status: OrderStatus.placed,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final m = o.toMap();
    final back = Order.fromMap('x', m);
    expect(back.title, 'Zara jacket');
    expect(back.status, OrderStatus.placed);
    expect(back.deliveryMethod, DeliveryMethod.home);
  });
}
