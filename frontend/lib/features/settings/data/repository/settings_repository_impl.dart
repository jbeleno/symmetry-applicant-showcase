import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repository/settings_repository.dart';

/// Implementation of [SettingsRepository] using [SharedPreferences].
/// Stores simple key-value pairs for app configuration.
class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepositoryImpl(this._prefs);

  @override
  Future<bool> getTheme() async {
    return _prefs.getBool('is_dark_mode') ?? true;
  }

  @override
  Future<void> saveTheme(bool isDark) async {
    await _prefs.setBool('is_dark_mode', isDark);
  }
}
