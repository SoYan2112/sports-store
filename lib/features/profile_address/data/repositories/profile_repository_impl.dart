import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<UserProfileEntity> getProfile() async {
    return await localDataSource.getProfile();
  }

  @override
  Future<UserProfileEntity> updateProfile(UserProfileEntity profile) async {
    final model = UserProfileModel.fromEntity(profile);
    return await localDataSource.saveProfile(model);
  }
}
