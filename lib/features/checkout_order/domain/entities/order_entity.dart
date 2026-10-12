import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';
import 'order_status.dart';

class OrderEntity extends Equatable {
  final String id;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final String shippingAddress;
  final String paymentMethod;
  final String recipientName;
  final String recipientPhone;
  final String? trackingNumber;
  final double shippingFee;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
    required this.paymentMethod,
    this.recipientName = 'Nguyễn Văn Thể Thao',
    this.recipientPhone = '0912 345 678',
    this.trackingNumber,
    this.shippingFee = 0.0,
  });

  OrderEntity copyWith({
    String? id,
    List<OrderItemEntity>? items,
    double? totalAmount,
    OrderStatus? status,
    DateTime? createdAt,
    String? shippingAddress,
    String? paymentMethod,
    String? recipientName,
    String? recipientPhone,
    String? trackingNumber,
    double? shippingFee,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      shippingFee: shippingFee ?? this.shippingFee,
    );
  }

  @override
  List<Object?> get props => [
        id,
        items,
        totalAmount,
        status,
        createdAt,
        shippingAddress,
        paymentMethod,
        recipientName,
        recipientPhone,
        trackingNumber,
        shippingFee,
      ];
}
