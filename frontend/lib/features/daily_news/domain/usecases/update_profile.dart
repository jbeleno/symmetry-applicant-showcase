import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/profile.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/profile_repository.dart';

/// UseCase responsible for updating the user's profile information.
class UpdateProfileUseCase implements UseCase<void, ProfileEntity> {
  final ProfileRepository _profileRepository;

  UpdateProfileUseCase(this._profileRepository);

  @override
  Future<void> call({ProfileEntity? params}) {
    return _profileRepository.updateProfile(params!);
  }
}
