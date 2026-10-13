import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sports_store_mobile/features/profile_address/domain/entities/user_profile_entity.dart';
import 'package:sports_store_mobile/features/profile_address/domain/usecases/get_profile_usecase.dart';
import 'package:sports_store_mobile/features/profile_address/domain/usecases/update_profile_usecase.dart';
import 'package:sports_store_mobile/features/profile_address/presentation/bloc/profile_bloc.dart';
import 'package:sports_store_mobile/features/profile_address/presentation/bloc/profile_event.dart';
import 'package:sports_store_mobile/features/profile_address/presentation/bloc/profile_state.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}
class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

void main() {
  group('ProfileBloc Unit Test (TSK-12 & TSK-13)', () {
    late ProfileBloc profileBloc;
    late MockGetProfileUseCase mockGetProfileUseCase;
    late MockUpdateProfileUseCase mockUpdateProfileUseCase;

    setUp(() {
      mockGetProfileUseCase = MockGetProfileUseCase();
      mockUpdateProfileUseCase = MockUpdateProfileUseCase();
      profileBloc = ProfileBloc(
        getProfileUseCase: mockGetProfileUseCase,
        updateProfileUseCase: mockUpdateProfileUseCase,
      );
    });

    tearDown(() {
      profileBloc.close();
    });

    const testProfile = UserProfileEntity(
      id: 'USR_01',
      fullName: 'Nguyễn Văn Hùng',
      email: 'hung@sports.vn',
      phoneNumber: '0901234567',
      gender: 'Nam',
    );

    test('Trạng thái ban đầu là ProfileInitial', () {
      expect(profileBloc.state, equals(ProfileInitial()));
    });

    blocTest<ProfileBloc, ProfileState>(
      'emit [ProfileLoading, ProfileLoaded] khi tải thông tin hồ sơ thành công',
      build: () {
        when(() => mockGetProfileUseCase()).thenAnswer((_) async => testProfile);
        return profileBloc;
      },
      act: (bloc) => bloc.add(LoadProfileEvent()),
      expect: () => [
        isA<ProfileLoading>(),
        const ProfileLoaded(testProfile),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emit [ProfileLoading, ProfileUpdatedSuccess, ProfileLoaded] khi cập nhật hồ sơ thành công',
      build: () {
        when(() => mockUpdateProfileUseCase(testProfile)).thenAnswer((_) async => testProfile);
        return profileBloc;
      },
      act: (bloc) => bloc.add(const UpdateProfileEvent(testProfile)),
      expect: () => [
        isA<ProfileLoading>(),
        const ProfileUpdatedSuccess(testProfile),
        const ProfileLoaded(testProfile),
      ],
    );
  });
}
