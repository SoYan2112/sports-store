import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (item) => item.productId == event.item.productId && item.size == event.item.size,
    );

    if (existingIndex >= 0) {
      final existing = currentItems[existingIndex];
      currentItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + event.item.quantity,
      );
    } else {
      currentItems.add(event.item);
    }

    emit(state.copyWith(items: currentItems));
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) {
    if (event.newQuantity <= 0) {
      add(RemoveFromCartEvent(event.itemId));
      return;
    }

    final currentItems = state.items.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(quantity: event.newQuantity);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: currentItems));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final currentItems = state.items.where((item) => item.id != event.itemId).toList();
    emit(state.copyWith(items: currentItems));
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
