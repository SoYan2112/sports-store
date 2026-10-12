import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sports_store_mobile/features/profile_address/domain/entities/address_entity.dart';
import 'package:sports_store_mobile/features/profile_address/domain/usecases/get_addresses_usecase.dart';
import 'package:sports_store_mobile/features/profile_address/domain/usecases/add_address_usecase.dart';
import 'package:sports_store_mobile/features/profile_address/domain/usecases/update_address_usecase.dart';
import 'package:sports_store_mobile/features/profile_address/domain/usecases/delete_address_usecase.dart';
import 'package:sports_store_mobile/features/profile_address/domain/usecases/set_default_address_usecase.dart';
import 'package:sports_store_mobile/features/profile_address/presentation/bloc/address_bloc.dart';
import 'package:sports_store_mobile/features/profile_address/presentation/bloc/address_event.dart';
import 'package:sports_store_mobile/features/profile_address/presentation/bloc/address_state.dart';

class MockGetAddressesUseCase extends Mock implements GetAddressesUseCase {}
class MockAddAddressUseCase extends Mock implements AddAddressUseCase {}
class MockUpdateAddressUseCase extends Mock implements UpdateAddressUseCase {}
class MockDeleteAddressUseCase extends Mock implements DeleteAddressUseCase {}
class MockSetDefaultAddressUseCase extends Mock implements SetDefaultAddressUseCase {}

void main() {
  group('AddressBloc Unit Test (TSK-12 & TSK-13)', () {
    late AddressBloc addressBloc;
    late MockGetAddressesUseCase mockGetAddressesUseCase;
    late MockAddAddressUseCase mockAddAddressUseCase;
    late MockUpdateAddressUseCase mockUpdateAddressUseCase;
    late MockDeleteAddressUseCase mockDeleteAddressUseCase;
    late MockSetDefaultAddressUseCase mockSetDefaultAddressUseCase;

    setUp(() {
      mockGetAddressesUseCase = MockGetAddressesUseCase();
      mockAddAddressUseCase = MockAddAddressUseCase();
      mockUpdateAddressUseCase = MockUpdateAddressUseCase();
      mockDeleteAddressUseCase = MockDeleteAddressUseCase();
      mockSetDefaultAddressUseCase = MockSetDefaultAddressUseCase();

      addressBloc = AddressBloc(
        getAddressesUseCase: mockGetAddressesUseCase,
        addAddressUseCase: mockAddAddressUseCase,
        updateAddressUseCase: mockUpdateAddressUseCase,
        deleteAddressUseCase: mockDeleteAddressUseCase,
        setDefaultAddressUseCase: mockSetDefaultAddressUseCase,
      );
    });

    tearDown(() {
      addressBloc.close();
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

    test('Trạng thái ban đầu là AddressInitial', () {
      expect(addressBloc.state, equals(AddressInitial()));
    });

    blocTest<AddressBloc, AddressState>(
      'emit [AddressLoading, AddressLoaded] khi lấy danh sách địa chỉ thành công',
      build: () {
        when(() => mockGetAddressesUseCase()).thenAnswer((_) async => [testAddress]);
        return addressBloc;
      },
      act: (bloc) => bloc.add(LoadAddressesEvent()),
      expect: () => [
        isA<AddressLoading>(),
        const AddressLoaded([testAddress]),
      ],
    );

    blocTest<AddressBloc, AddressState>(
      'emit [AddressActionSuccess, AddressLoaded] khi đặt địa chỉ mặc định',
      build: () {
        when(() => mockSetDefaultAddressUseCase('ADDR_01')).thenAnswer((_) async {});
        when(() => mockGetAddressesUseCase()).thenAnswer((_) async => [testAddress]);
        return addressBloc;
      },
      act: (bloc) => bloc.add(const SetDefaultAddressEvent('ADDR_01')),
      expect: () => [
        const AddressActionSuccess(
          message: 'Đã đặt làm địa chỉ mặc định!',
          addresses: [testAddress],
        ),
        const AddressLoaded([testAddress]),
      ],
    );
  });
}
