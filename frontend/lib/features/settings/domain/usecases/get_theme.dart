import '../../../../core/usecase/usecase.dart';
import '../repository/settings_repository.dart';

/// UseCase responsible for retrieving the saved theme preference.
class GetThemeUseCase implements UseCase<bool, void> {
  final SettingsRepository _settingsRepository;

  GetThemeUseCase(this._settingsRepository);

  @override
  Future<bool> call({void params}) {
    return _settingsRepository.getTheme();
  }
}
