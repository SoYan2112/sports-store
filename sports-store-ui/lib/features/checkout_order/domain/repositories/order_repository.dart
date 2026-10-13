import '../entities/order_entity.dart';

abstract class OrderRepository {
  /// Lấy danh sách lịch sử đơn hàng của người dùng hiện tại
  Future<List<OrderEntity>> getOrderHistory();

  /// Hủy đơn hàng (khi đơn còn ở trạng thái chờ xác nhận)
  Future<void> cancelOrder(String orderId);
}

