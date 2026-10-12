import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderLoaded extends OrderState {
  final List<OrderEntity> allOrders;
  final List<OrderEntity> filteredOrders;
  final OrderStatus currentStatus;
  final String? successMessage;

  const OrderLoaded({
    required this.allOrders,
    required this.filteredOrders,
    this.currentStatus = OrderStatus.all,
    this.successMessage,
  });

  OrderLoaded copyWith({
    List<OrderEntity>? allOrders,
    List<OrderEntity>? filteredOrders,
    OrderStatus? currentStatus,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return OrderLoaded(
      allOrders: allOrders ?? this.allOrders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      currentStatus: currentStatus ?? this.currentStatus,
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [allOrders, filteredOrders, currentStatus, successMessage];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

