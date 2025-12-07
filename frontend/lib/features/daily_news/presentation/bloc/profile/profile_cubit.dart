import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_profile.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/update_profile.dart';
import 'profile_state.dart';

/// Manages the state of the user profile.
/// Handles loading and updating profile information using UseCases.
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit(this._getProfileUseCase, this._updateProfileUseCase)
      : super(const ProfileState());

  Future<void> loadProfile() async {
    final profile = await _getProfileUseCase();
    emit(ProfileState(
      name: profile.name,
      age: profile.age,
      gender: profile.gender,
      imagePath: profile.imagePath,
    ));
  }

  Future<void> updateProfile({
    String? name,
    String? age,
    String? gender,
    String? imagePath,
  }) async {
    final currentProfile = await _getProfileUseCase();
    final newProfile = currentProfile.copyWith(
      name: name,
      age: age,
      gender: gender,
      imagePath: imagePath,
    );

    await _updateProfileUseCase(params: newProfile);

    emit(state.copyWith(
      name: name,
      age: age,
      gender: gender,
      imagePath: imagePath,
    ));
  }
}
