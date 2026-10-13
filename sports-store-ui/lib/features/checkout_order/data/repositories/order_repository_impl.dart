import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  // Bộ dữ liệu mẫu đơn hàng thể thao chuẩn phong cách Adidas Việt Nam
  final List<OrderEntity> _orders = [
    OrderEntity(
      id: 'AD-VN-883921',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      status: OrderStatus.pending,
      shippingAddress: 'Tòa nhà Bitexco, Số 2 Hải Triều, P. Bến Nghé, Quận 1, TP. Hồ Chí Minh',
      paymentMethod: 'COD (Thanh toán khi nhận hàng)',
      totalAmount: 4900000,
      recipientName: 'Nguyễn Văn Thể Thao',
      recipientPhone: '0912 345 678',
      items: const [
        OrderItemEntity(
          id: 'ITEM_01',
          productId: 'P1',
          name: 'ULTRABOOST LIGHT 23',
          price: 4900000,
          imageUrl: 'https://assets.adidas.com/images/w_600,f_auto,q_auto/a225e6f3d82d4fb4bc00af6b0147fc5e_9366/Ultraboost_Light_Running_Shoes_White_HQ6351_01_standard.jpg',
          size: '42',
          quantity: 1,
        ),
      ],
    ),
    OrderEntity(
      id: 'AD-VN-772910',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      status: OrderStatus.shipping,
      shippingAddress: 'Số 18 Tam Trinh, Phường Mai Động, Quận Hoàng Mai, Hà Nội',
      paymentMethod: 'VNPAY QR',
      totalAmount: 5400000,
      recipientName: 'Trần Minh Đức',
      recipientPhone: '0988 765 432',
      trackingNumber: 'VNPOST-882910293',
      items: const [
        OrderItemEntity(
          id: 'ITEM_02',
          productId: 'P2',
          name: 'SAMBA OG CLASSIC',
          price: 2700000,
          imageUrl: 'https://assets.adidas.com/images/w_600,f_auto,q_auto/4e894c2b76dd4c8e9013aafc016047af_9366/Giay_Samba_OG_trang_B75806_01_00_standard.jpg',
          size: '41',
          quantity: 2,
        ),
      ],
    ),
    OrderEntity(
      id: 'AD-VN-661298',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: OrderStatus.delivered,
      shippingAddress: 'Số 45 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng',
      paymentMethod: 'VNPAY QR',
      totalAmount: 9200000,
      recipientName: 'Lê Hoàng Long',
      recipientPhone: '0905 123 987',
      trackingNumber: 'GHN-661298341VN',
      items: const [
        OrderItemEntity(
          id: 'ITEM_03',
          productId: 'P3',
          name: 'PREDATOR ELITE FG',
          price: 6500000,
          imageUrl: 'https://assets.adidas.com/images/w_600,f_auto,q_auto/9d115469ad104f4c82c6b052011b1c67_9366/Giay_Predator_Elite_Firm_Ground_den_IF8867_01_standard.jpg',
          size: '42.5',
          quantity: 1,
        ),
        OrderItemEntity(
          id: 'ITEM_04',
          productId: 'P2',
          name: 'SAMBA OG CLASSIC',
          price: 2700000,
          imageUrl: 'https://assets.adidas.com/images/w_600,f_auto,q_auto/4e894c2b76dd4c8e9013aafc016047af_9366/Giay_Samba_OG_trang_B75806_01_00_standard.jpg',
          size: '40',
          quantity: 1,
        ),
      ],
    ),
    OrderEntity(
      id: 'AD-VN-550119',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      status: OrderStatus.cancelled,
      shippingAddress: 'Số 10 Võ Văn Kiệt, Quận 5, TP. Hồ Chí Minh',
      paymentMethod: 'COD (Thanh toán khi nhận hàng)',
      totalAmount: 2700000,
      recipientName: 'Nguyễn Văn Thể Thao',
      recipientPhone: '0912 345 678',
      items: const [
        OrderItemEntity(
          id: 'ITEM_05',
          productId: 'P2',
          name: 'SAMBA OG CLASSIC',
          price: 2700000,
          imageUrl: 'https://assets.adidas.com/images/w_600,f_auto,q_auto/4e894c2b76dd4c8e9013aafc016047af_9366/Giay_Samba_OG_trang_B75806_01_00_standard.jpg',
          size: '43',
          quantity: 1,
        ),
      ],
    ),
  ];

  @override
  Future<List<OrderEntity>> getOrderHistory() async {
    // Giả lập độ trễ mạng API
    await Future.delayed(const Duration(milliseconds: 400));
    return List<OrderEntity>.from(_orders);
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      if (_orders[index].status != OrderStatus.pending) {
        throw Exception('Chỉ có thể hủy đơn hàng khi đang ở trạng thái Chờ xác nhận');
      }
      _orders[index] = _orders[index].copyWith(status: OrderStatus.cancelled);
    } else {
      throw Exception('Không tìm thấy đơn hàng mã $orderId');
    }
  }
}
