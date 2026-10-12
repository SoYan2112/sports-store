import 'package:equatable/equatable.dart';
import '../../domain/entities/order_status.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrdersEvent extends OrderEvent {
  const FetchOrdersEvent();
}

class FilterOrdersByStatusEvent extends OrderEvent {
  final OrderStatus status;

  const FilterOrdersByStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class CancelOrderEvent extends OrderEvent {
  final String orderId;

  const CancelOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

