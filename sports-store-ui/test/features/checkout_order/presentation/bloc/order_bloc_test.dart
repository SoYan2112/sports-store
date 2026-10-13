import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sports_store_mobile/features/checkout_order/domain/entities/order_entity.dart';
import 'package:sports_store_mobile/features/checkout_order/domain/entities/order_item_entity.dart';
import 'package:sports_store_mobile/features/checkout_order/domain/entities/order_status.dart';
import 'package:sports_store_mobile/features/checkout_order/domain/repositories/order_repository.dart';
import 'package:sports_store_mobile/features/checkout_order/presentation/bloc/order_bloc.dart';
import 'package:sports_store_mobile/features/checkout_order/presentation/bloc/order_event.dart';
import 'package:sports_store_mobile/features/checkout_order/presentation/bloc/order_state.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late MockOrderRepository mockOrderRepository;
  late OrderBloc orderBloc;

  final testOrders = [
    OrderEntity(
      id: 'AD-VN-001',
      items: const [
        OrderItemEntity(
          id: 'I1',
          productId: 'P1',
          name: 'ULTRABOOST LIGHT 23',
          price: 4900000,
          imageUrl: 'https://example.com/shoe.jpg',
          size: '42',
          quantity: 1,
        ),
      ],
      totalAmount: 4900000,
      status: OrderStatus.pending,
      createdAt: DateTime(2026, 10, 12, 10, 0),
      shippingAddress: 'Quận 1, TP. HCM',
      paymentMethod: 'COD',
    ),
    OrderEntity(
      id: 'AD-VN-002',
      items: const [
        OrderItemEntity(
          id: 'I2',
          productId: 'P2',
          name: 'SAMBA OG CLASSIC',
          price: 2700000,
          imageUrl: 'https://example.com/samba.jpg',
          size: '41',
          quantity: 1,
        ),
      ],
      totalAmount: 2700000,
      status: OrderStatus.delivered,
      createdAt: DateTime(2026, 10, 10, 14, 0),
      shippingAddress: 'Hoàng Mai, Hà Nội',
      paymentMethod: 'VNPAY',
    ),
  ];

  setUp(() {
    mockOrderRepository = MockOrderRepository();
    orderBloc = OrderBloc(orderRepository: mockOrderRepository);
  });

  tearDown(() {
    orderBloc.close();
  });

  group('OrderBloc Unit Test (TSK-16 - Lịch sử đơn hàng)', () {
    test('Trạng thái khởi tạo ban đầu là OrderInitial', () {
      expect(orderBloc.state, const OrderInitial());
    });

    blocTest<OrderBloc, OrderState>(
      'FetchOrdersEvent phát ra [OrderLoading, OrderLoaded] khi lấy danh sách thành công',
      build: () {
        when(() => mockOrderRepository.getOrderHistory())
            .thenAnswer((_) async => testOrders);
        return orderBloc;
      },
      act: (bloc) => bloc.add(const FetchOrdersEvent()),
      expect: () => [
        const OrderLoading(),
        OrderLoaded(
          allOrders: testOrders,
          filteredOrders: testOrders,
          currentStatus: OrderStatus.all,
        ),
      ],
      verify: (_) {
        verify(() => mockOrderRepository.getOrderHistory()).called(1);
      },
    );

    blocTest<OrderBloc, OrderState>(
      'FetchOrdersEvent phát ra [OrderLoading, OrderError] khi API gặp lỗi',
      build: () {
        when(() => mockOrderRepository.getOrderHistory())
            .thenThrow(Exception('Không thể kết nối máy chủ'));
        return orderBloc;
      },
      act: (bloc) => bloc.add(const FetchOrdersEvent()),
      expect: () => [
        const OrderLoading(),
        const OrderError('Không thể kết nối máy chủ'),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'FilterOrdersByStatusEvent lọc chính xác đơn hàng theo trạng thái đã chọn',
      build: () => orderBloc,
      seed: () => OrderLoaded(
        allOrders: testOrders,
        filteredOrders: testOrders,
        currentStatus: OrderStatus.all,
      ),
      act: (bloc) => bloc.add(const FilterOrdersByStatusEvent(OrderStatus.delivered)),
      expect: () => [
        OrderLoaded(
          allOrders: testOrders,
          filteredOrders: [testOrders[1]], // Chỉ đơn AD-VN-002 có trạng thái delivered
          currentStatus: OrderStatus.delivered,
        ),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'CancelOrderEvent hủy đơn hàng thành công và cập nhật lại danh sách',
      build: () {
        when(() => mockOrderRepository.cancelOrder('AD-VN-001'))
            .thenAnswer((_) async => Future.value());
        when(() => mockOrderRepository.getOrderHistory())
            .thenAnswer((_) async => [
                  testOrders[0].copyWith(status: OrderStatus.cancelled),
                  testOrders[1],
                ]);
        return orderBloc;
      },
      seed: () => OrderLoaded(
        allOrders: testOrders,
        filteredOrders: testOrders,
        currentStatus: OrderStatus.all,
      ),
      act: (bloc) => bloc.add(const CancelOrderEvent('AD-VN-001')),
      expect: () => [
        const OrderLoading(),
        OrderLoaded(
          allOrders: [
            testOrders[0].copyWith(status: OrderStatus.cancelled),
            testOrders[1],
          ],
          filteredOrders: [
            testOrders[0].copyWith(status: OrderStatus.cancelled),
            testOrders[1],
          ],
          currentStatus: OrderStatus.all,
          successMessage: 'Hủy đơn hàng AD-VN-001 thành công!',
        ),
      ],
      verify: (_) {
        verify(() => mockOrderRepository.cancelOrder('AD-VN-001')).called(1);
        verify(() => mockOrderRepository.getOrderHistory()).called(1);
      },
    );
  });
}

