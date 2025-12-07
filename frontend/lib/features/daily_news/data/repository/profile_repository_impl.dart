import 'package:news_app_clean_architecture/features/daily_news/domain/entities/profile.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [ProfileRepository] using [SharedPreferences].
/// Stores user profile data locally on the device.
class ProfileRepositoryImpl implements ProfileRepository {
  final SharedPreferences _prefs;

  ProfileRepositoryImpl(this._prefs);

  @override
  Future<ProfileEntity> getProfile() async {
    final name = _prefs.getString('profile_name') ?? '';
    final age = _prefs.getString('profile_age') ?? '';
    final gender = _prefs.getString('profile_gender') ?? '';
    final imagePath = _prefs.getString('profile_image');

    return ProfileEntity(
      name: name,
      age: age,
      gender: gender,
      imagePath: imagePath,
    );
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    if (profile.name.isNotEmpty) {
      await _prefs.setString('profile_name', profile.name);
    }
    if (profile.age.isNotEmpty) {
      await _prefs.setString('profile_age', profile.age);
    }
    if (profile.gender.isNotEmpty) {
      await _prefs.setString('profile_gender', profile.gender);
    }
    if (profile.imagePath != null) {
      await _prefs.setString('profile_image', profile.imagePath!);
    }
  }
}
