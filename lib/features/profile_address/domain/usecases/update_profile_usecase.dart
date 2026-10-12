import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<UserProfileEntity> call(UserProfileEntity profile) async {
    return await repository.updateProfile(profile);
  }
}
