import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { placed, atWarehouse, packaging, shipped, ready, delivered }

extension OrderStatusX on OrderStatus {
  OrderStatus get next =>
      this == OrderStatus.delivered ? this : OrderStatus.values[index + 1];
  String get id => name;
  static OrderStatus fromId(String s) =>
      OrderStatus.values.firstWhere((e) => e.name == s,
          orElse: () => OrderStatus.placed);
}

enum DeliveryMethod { locker, home }

class Order {
  Order({
    required this.id,
    required this.title,
    required this.sourceCountry,
    required this.deliveryMethod,
    this.lockerId,
    this.status = OrderStatus.placed,
    required this.createdAt,
    this.store,
    this.trackingNumber,
    this.category,
    this.declaredValue,
    this.quantity,
  });

  final String id;
  final String title;
  final String sourceCountry; // sa|eg|ae|us|cn
  final DeliveryMethod deliveryMethod;
  final String? lockerId;
  final OrderStatus status;
  final DateTime createdAt;
  final String? store;
  final String? trackingNumber;
  final String? category;
  final double? declaredValue;
  final int? quantity;

  Map<String, dynamic> toMap() => {
        'title': title,
        'sourceCountry': sourceCountry,
        'deliveryMethod': deliveryMethod.name,
        'lockerId': lockerId,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
        if (store != null) 'store': store,
        if (trackingNumber != null) 'trackingNumber': trackingNumber,
        if (category != null) 'category': category,
        if (declaredValue != null) 'declaredValue': declaredValue,
        if (quantity != null) 'quantity': quantity,
      };

  factory Order.fromMap(String id, Map<String, dynamic> m) => Order(
        id: id,
        title: m['title'] as String? ?? '',
        sourceCountry: m['sourceCountry'] as String? ?? '',
        deliveryMethod: (m['deliveryMethod'] == 'locker')
            ? DeliveryMethod.locker
            : DeliveryMethod.home,
        lockerId: m['lockerId'] as String?,
        status: OrderStatusX.fromId(m['status'] as String? ?? 'placed'),
        createdAt:
            (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        store: m['store'] as String?,
        trackingNumber: m['trackingNumber'] as String?,
        category: m['category'] as String?,
        declaredValue: (m['declaredValue'] as num?)?.toDouble(),
        quantity: (m['quantity'] as num?)?.toInt(),
      );

  Order copyWith({
    OrderStatus? status,
    String? store,
    String? trackingNumber,
    String? category,
    double? declaredValue,
    int? quantity,
  }) =>
      Order(
        id: id,
        title: title,
        sourceCountry: sourceCountry,
        deliveryMethod: deliveryMethod,
        lockerId: lockerId,
        status: status ?? this.status,
        createdAt: createdAt,
        store: store ?? this.store,
        trackingNumber: trackingNumber ?? this.trackingNumber,
        category: category ?? this.category,
        declaredValue: declaredValue ?? this.declaredValue,
        quantity: quantity ?? this.quantity,
      );
}
