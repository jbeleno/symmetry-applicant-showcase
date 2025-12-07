import '../../../../core/usecase/usecase.dart';
import '../repository/settings_repository.dart';

/// UseCase responsible for persisting the user's theme preference.
class SaveThemeUseCase implements UseCase<void, bool> {
  final SettingsRepository _settingsRepository;

  SaveThemeUseCase(this._settingsRepository);

  @override
  Future<void> call({bool? params}) {
    return _settingsRepository.saveTheme(params!);
  }
}
