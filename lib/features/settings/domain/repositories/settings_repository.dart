import '../entities/temperature_unit.dart';
import '../entities/theme_mode_app.dart';

abstract class SettingsRepository {
  Future<TemperatureUnit> getTemperatureUnit();
  Future<void> setTemperatureUnit(TemperatureUnit unit);

  Future<ThemeModeApp> getThemeMode();
  Future<void> setThemeMode(ThemeModeApp mode);
}
