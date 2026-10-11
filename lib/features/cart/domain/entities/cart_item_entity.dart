import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final String size;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.size,
    required this.quantity,
  });

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      id: id,
      productId: productId,
      name: name,
      price: price,
      imageUrl: imageUrl,
      size: size,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, productId, name, price, imageUrl, size, quantity];
}
