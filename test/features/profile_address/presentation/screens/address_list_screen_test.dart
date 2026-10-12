import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sports_store_mobile/features/profile_address/domain/entities/address_entity.dart';
import 'package:sports_store_mobile/features/profile_address/presentation/bloc/address_bloc.dart';
import 'package:sports_store_mobile/features/profile_address/presentation/bloc/address_state.dart';
import 'package:sports_store_mobile/features/profile_address/presentation/screens/address_list_screen.dart';

class MockAddressBloc extends Mock implements AddressBloc {}

void main() {
  late MockAddressBloc mockAddressBloc;

  setUp(() {
    mockAddressBloc = MockAddressBloc();
  });

  const testAddress = AddressEntity(
    id: 'ADDR_01',
    receiverName: 'Nguyễn Văn Hùng',
    phoneNumber: '0901234567',
    province: 'Hồ Chí Minh',
    district: 'Quận 1',
    ward: 'Phường Bến Nghé',
    streetAddress: 'Số 123 Lê Lợi',
    isDefault: true,
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AddressBloc>.value(
        value: mockAddressBloc,
        child: const AddressListScreen(provinces: []),
      ),
    );
  }

  testWidgets('Hiển thị danh sách địa chỉ với badge MẶC ĐỊNH và tên người nhận', (tester) async {
    when(() => mockAddressBloc.state).thenReturn(const AddressLoaded([testAddress]));
    when(() => mockAddressBloc.stream).thenAnswer((_) => Stream.value(const AddressLoaded([testAddress])));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('SỔ ĐỊA CHỈ NHẬN HÀNG'), findsOneWidget);
    expect(find.text('Nguyễn Văn Hùng'), findsOneWidget);
    expect(find.text('MẶC ĐỊNH'), findsOneWidget);
    expect(find.text('THÊM ĐỊA CHỈ MỚI'), findsOneWidget);
  });
}
