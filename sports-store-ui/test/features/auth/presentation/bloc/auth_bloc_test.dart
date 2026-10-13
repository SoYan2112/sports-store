import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sports_store_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:sports_store_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:sports_store_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sports_store_mobile/features/auth/presentation/bloc/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthBloc Unit Test (TSK-06)', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authBloc = AuthBloc(authRepository: mockAuthRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    const testUser = UserEntity(
      id: 'USR_001',
      fullName: 'Nguyễn Văn Thể Thao',
      email: 'user@sportsstore.vn',
      phoneNumber: '0912345678',
      role: 'USER',
      token: 'jwt_mock_token_2026',
    );

    test('Trạng thái khởi tạo của AuthBloc là AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emit [AuthLoading, Authenticated] khi đăng nhập thành công',
      build: () {
        when(() => mockAuthRepository.login(
              emailOrPhone: 'user@sportsstore.vn',
              password: 'password123',
            )).thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginEvent(
        emailOrPhone: 'user@sportsstore.vn',
        password: 'password123',
      )),
      expect: () => [
        isA<AuthLoading>(),
        const Authenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emit [AuthLoading, AuthError] khi đăng nhập thất bại',
      build: () {
        when(() => mockAuthRepository.login(
              emailOrPhone: 'user@sportsstore.vn',
              password: 'wrongpassword',
            )).thenThrow(Exception('Sai mật khẩu'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginEvent(
        emailOrPhone: 'user@sportsstore.vn',
        password: 'wrongpassword',
      )),
      expect: () => [
        isA<AuthLoading>(),
        const AuthError('Sai mật khẩu'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emit [Unauthenticated] khi đăng xuất',
      build: () {
        when(() => mockAuthRepository.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [
        isA<Unauthenticated>(),
      ],
    );
  });
}
