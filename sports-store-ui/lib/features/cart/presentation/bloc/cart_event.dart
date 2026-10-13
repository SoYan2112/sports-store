import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final CartItemEntity item;
  const AddToCartEvent(this.item);
  @override
  List<Object?> get props => [item];
}

class UpdateQuantityEvent extends CartEvent {
  final String itemId;
  final int newQuantity;
  const UpdateQuantityEvent(this.itemId, this.newQuantity);
  @override
  List<Object?> get props => [itemId, newQuantity];
}

class RemoveFromCartEvent extends CartEvent {
  final String itemId;
  const RemoveFromCartEvent(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

class ClearCartEvent extends CartEvent {}
