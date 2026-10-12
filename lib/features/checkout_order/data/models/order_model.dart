import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import 'order_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
    required super.shippingAddress,
    required super.paymentMethod,
    super.recipientName,
    super.recipientPhone,
    super.trackingNumber,
    super.shippingFee,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.fromString(json['status'] as String? ?? 'pending'),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      shippingAddress: json['shippingAddress'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? 'COD',
      recipientName: json['recipientName'] as String? ?? 'Nguyễn Văn Thể Thao',
      recipientPhone: json['recipientPhone'] as String? ?? '0912 345 678',
      trackingNumber: json['trackingNumber'] as String?,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) {
        if (item is OrderItemModel) {
          return item.toJson();
        }
        return {
          'id': item.id,
          'productId': item.productId,
          'name': item.name,
          'price': item.price,
          'imageUrl': item.imageUrl,
          'size': item.size,
          'quantity': item.quantity,
        };
      }).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'trackingNumber': trackingNumber,
      'shippingFee': shippingFee,
    };
  }
}
