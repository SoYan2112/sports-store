import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(const OrderInitial()) {
    on<FetchOrdersEvent>(_onFetchOrders);
    on<FilterOrdersByStatusEvent>(_onFilterOrders);
    on<CancelOrderEvent>(_onCancelOrder);
  }

  Future<void> _onFetchOrders(
    FetchOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    try {
      final orders = await orderRepository.getOrderHistory();
      final currentStatus = state is OrderLoaded
          ? (state as OrderLoaded).currentStatus
          : OrderStatus.all;
      final filtered = _filter(orders, currentStatus);
      emit(OrderLoaded(
        allOrders: orders,
        filteredOrders: filtered,
        currentStatus: currentStatus,
      ));
    } catch (e) {
      emit(OrderError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onFilterOrders(
    FilterOrdersByStatusEvent event,
    Emitter<OrderState> emit,
  ) {
    if (state is OrderLoaded) {
      final currentState = state as OrderLoaded;
      final filtered = _filter(currentState.allOrders, event.status);
      emit(currentState.copyWith(
        filteredOrders: filtered,
        currentStatus: event.status,
        clearSuccessMessage: true,
      ));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    final currentStatus = state is OrderLoaded
        ? (state as OrderLoaded).currentStatus
        : OrderStatus.all;

    emit(const OrderLoading());
    try {
      await orderRepository.cancelOrder(event.orderId);
      final orders = await orderRepository.getOrderHistory();
      final filtered = _filter(orders, currentStatus);
      emit(OrderLoaded(
        allOrders: orders,
        filteredOrders: filtered,
        currentStatus: currentStatus,
        successMessage: 'Hủy đơn hàng ${event.orderId} thành công!',
      ));
    } catch (e) {
      emit(OrderError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  List<OrderEntity> _filter(List<OrderEntity> orders, OrderStatus status) {
    if (status == OrderStatus.all) {
      return orders;
    }
    return orders.where((order) => order.status == status).toList();
  }
}

