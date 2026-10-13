import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await getProfileUseCase();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Không thể tải thông tin cá nhân: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final previousState = state;
    if (previousState is ProfileLoaded) {
      emit(ProfileUpdating(previousState.profile));
    } else {
      emit(ProfileLoading());
    }

    try {
      final updated = await updateProfileUseCase(event.profile);
      emit(ProfileUpdatedSuccess(updated));
      emit(ProfileLoaded(updated));
    } catch (e) {
      emit(ProfileError('Cập nhật thông tin thất bại: ${e.toString()}'));
      if (previousState is ProfileLoaded) {
        emit(ProfileLoaded(previousState.profile));
      }
    }
  }
}
