import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/profile.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/profile_repository.dart';

/// UseCase responsible for retrieving the current user's profile.
class GetProfileUseCase implements UseCase<ProfileEntity, void> {
  final ProfileRepository _profileRepository;

  GetProfileUseCase(this._profileRepository);

  @override
  Future<ProfileEntity> call({void params}) {
    return _profileRepository.getProfile();
  }
}
