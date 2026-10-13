import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_store_mobile/core/theme/app_theme.dart';
import 'package:sports_store_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sports_store_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:sports_store_mobile/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sports_store_mobile/features/cart/presentation/bloc/cart_state.dart';
import 'package:sports_store_mobile/features/product/presentation/screens/home_screen.dart';
import 'package:sports_store_mobile/features/product/presentation/screens/product_search_screen.dart';
import 'package:sports_store_mobile/features/product/presentation/widgets/category_filter_chips.dart';
import 'package:sports_store_mobile/features/product/presentation/widgets/compact_product_card.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}
class MockCartBloc extends Mock implements CartBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockCartBloc mockCartBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockCartBloc = MockCartBloc();

    when(() => mockAuthBloc.state).thenReturn(Unauthenticated());
    when(() => mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockCartBloc.state).thenReturn(const CartState(items: []));
    when(() => mockCartBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildTestWidget(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: mockAuthBloc),
        BlocProvider<CartBloc>.value(value: mockCartBloc),
      ],
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: child,
      ),
    );
  }

  testWidgets('HomeScreen hiển thị danh mục thể thao và danh sách sản phẩm card', (tester) async {
    await tester.pumpWidget(buildTestWidget(const HomeScreen()));
    await tester.pump();

    // Kiểm tra title app bar
    expect(find.text('ADIDAS VIỆT NAM'), findsOneWidget);

    // Kiểm tra các chip danh mục
    expect(find.byType(CategoryFilterChips), findsOneWidget);
    expect(find.text('TẤT CẢ'), findsOneWidget);
    expect(find.text('RUNNING'), findsWidgets);

    // Kiểm tra các card sản phẩm compact
    expect(find.byType(CompactProductCard), findsWidgets);
  });

  testWidgets('ProductSearchScreen hiển thị thanh tìm kiếm và lịch sử tìm kiếm gần đây', (tester) async {
    await tester.pumpWidget(buildTestWidget(const ProductSearchScreen()));
    await tester.pump();

    expect(find.text('TÌM KIẾM SẢN PHẨM'), findsOneWidget);
    expect(find.text('TÌM KIẾM GẦN ĐÂY'), findsOneWidget);
    expect(find.text('Ultraboost'), findsOneWidget);
  });
}
