/// Abstract definition of the Settings Repository.
/// Defines the contract for accessing and modifying application settings.
abstract class SettingsRepository {
  Future<bool> getTheme();
  Future<void> saveTheme(bool isDark);
}
