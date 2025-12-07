import 'package:news_app_clean_architecture/features/daily_news/domain/entities/profile.dart';

/// Repository interface for managing user profile data.
abstract class ProfileRepository {
  /// Retrieves the current user's profile.
  Future<ProfileEntity> getProfile();

  /// Updates the user's profile with new information.
  Future<void> updateProfile(ProfileEntity profile);
}
