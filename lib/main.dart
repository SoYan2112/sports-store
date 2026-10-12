import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/product/presentation/screens/home_screen.dart';
import 'features/profile_address/data/datasources/profile_local_datasource.dart';
import 'features/profile_address/data/repositories/profile_repository_impl.dart';
import 'features/profile_address/data/repositories/address_repository_impl.dart';
import 'features/profile_address/domain/usecases/get_profile_usecase.dart';
import 'features/profile_address/domain/usecases/update_profile_usecase.dart';
import 'features/profile_address/domain/usecases/get_addresses_usecase.dart';
import 'features/profile_address/domain/usecases/add_address_usecase.dart';
import 'features/profile_address/domain/usecases/update_address_usecase.dart';
import 'features/profile_address/domain/usecases/delete_address_usecase.dart';
import 'features/profile_address/domain/usecases/set_default_address_usecase.dart';
import 'features/profile_address/presentation/bloc/profile_bloc.dart';
import 'features/profile_address/presentation/bloc/profile_event.dart';
import 'features/profile_address/presentation/bloc/address_bloc.dart';
import 'features/profile_address/presentation/bloc/address_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final authRepository = AuthRepositoryImpl(
    sharedPreferences: sharedPreferences,
  );

  final profileLocalDataSource = ProfileLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );
  final profileRepository = ProfileRepositoryImpl(
    localDataSource: profileLocalDataSource,
  );
  final addressRepository = AddressRepositoryImpl(
    localDataSource: profileLocalDataSource,
  );

  runApp(SportsStoreApp(
    authRepository: authRepository,
    profileRepository: profileRepository,
    addressRepository: addressRepository,
  ));
}

class SportsStoreApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ProfileRepositoryImpl profileRepository;
  final AddressRepositoryImpl addressRepository;

  const SportsStoreApp({
    super.key,
    required this.authRepository,
    required this.profileRepository,
    required this.addressRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
              AuthBloc(authRepository: authRepository)
                ..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<CartBloc>(create: (_) => CartBloc()),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            getProfileUseCase: GetProfileUseCase(profileRepository),
            updateProfileUseCase: UpdateProfileUseCase(profileRepository),
          )..add(LoadProfileEvent()),
        ),
        BlocProvider<AddressBloc>(
          create: (_) => AddressBloc(
            getAddressesUseCase: GetAddressesUseCase(addressRepository),
            addAddressUseCase: AddAddressUseCase(addressRepository),
            updateAddressUseCase: UpdateAddressUseCase(addressRepository),
            deleteAddressUseCase: DeleteAddressUseCase(addressRepository),
            setDefaultAddressUseCase: SetDefaultAddressUseCase(addressRepository),
          )..add(LoadAddressesEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Sports Store',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
