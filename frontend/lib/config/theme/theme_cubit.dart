import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/settings/domain/usecases/get_theme.dart';
import '../../features/settings/domain/usecases/save_theme.dart';
import 'app_themes.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final GetThemeUseCase _getThemeUseCase;
  final SaveThemeUseCase _saveThemeUseCase;

  ThemeCubit(this._getThemeUseCase, this._saveThemeUseCase)
      : super(darkTheme()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDark = await _getThemeUseCase();
    emit(isDark ? darkTheme() : theme());
  }

  Future<void> toggleTheme() async {
    final isDark = state.brightness == Brightness.dark;
    await _saveThemeUseCase(params: !isDark);
    emit(!isDark ? darkTheme() : theme());
  }
}
