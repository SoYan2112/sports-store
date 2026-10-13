import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;
  final bool isLoading;

  const CartState({
    this.items = const [],
    this.isLoading = false,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItemEntity>? items,
    bool? isLoading,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [items, isLoading];
}
