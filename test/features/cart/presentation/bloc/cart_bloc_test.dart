import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:sports_store_mobile/features/cart/domain/entities/cart_item_entity.dart';
import 'package:sports_store_mobile/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sports_store_mobile/features/cart/presentation/bloc/cart_event.dart';
import 'package:sports_store_mobile/features/cart/presentation/bloc/cart_state.dart';

void main() {
  group('CartBloc Unit Test (Sprint 2 - Cart & Tổng tiền VNĐ)', () {
    late CartBloc cartBloc;

    setUp(() {
      cartBloc = CartBloc();
    });

    tearDown(() {
      cartBloc.close();
    });

    test('Trạng thái khởi tạo giỏ hàng rỗng và tổng tiền bằng 0', () {
      expect(cartBloc.state, const CartState(items: []));
      expect(cartBloc.state.totalAmount, 0);
    });

    const testItem = CartItemEntity(
      id: 'P1_42',
      productId: 'P1',
      name: 'ULTRABOOST LIGHT 23',
      price: 4900000,
      imageUrl: 'https://example.com/shoe.jpg',
      size: '42',
      quantity: 1,
    );

    blocTest<CartBloc, CartState>(
      'Thêm 1 sản phẩm vào giỏ thì tổng tiền tính đúng bằng giá sản phẩm',
      build: () => cartBloc,
      act: (bloc) => bloc.add(const AddToCartEvent(testItem)),
      expect: () => [
        const CartState(items: [testItem]),
      ],
      verify: (bloc) {
        expect(bloc.state.totalAmount, 4900000);
        expect(bloc.state.totalItemCount, 1);
      },
    );

    blocTest<CartBloc, CartState>(
      'Thêm cùng một sản phẩm cùng size thì tăng số lượng lên 2 và nhân đôi tổng tiền',
      build: () => cartBloc,
      seed: () => const CartState(items: [testItem]),
      act: (bloc) => bloc.add(const AddToCartEvent(testItem)),
      verify: (bloc) {
        expect(bloc.state.items.first.quantity, 2);
        expect(bloc.state.totalAmount, 9800000); // 4.900.000 x 2
      },
    );

    blocTest<CartBloc, CartState>(
      'Xóa sản phẩm khỏi giỏ hàng thì giỏ hàng rỗng và tổng tiền về 0',
      build: () => cartBloc,
      seed: () => const CartState(items: [testItem]),
      act: (bloc) => bloc.add(const RemoveFromCartEvent('P1_42')),
      expect: () => [
        const CartState(items: []),
      ],
      verify: (bloc) {
        expect(bloc.state.totalAmount, 0);
      },
    );
  });
}
