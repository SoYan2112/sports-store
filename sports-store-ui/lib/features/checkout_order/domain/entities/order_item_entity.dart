import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final String size;
  final int quantity;

  const OrderItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.size,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, productId, name, price, imageUrl, size, quantity];
}

