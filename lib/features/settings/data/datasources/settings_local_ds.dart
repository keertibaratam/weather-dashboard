import 'package:weatherly/core/constants/app_constants.dart';
import 'package:weatherly/core/storage/shared_prefs_service.dart';
import 'package:weatherly/features/settings/domain/entities/temperature_unit.dart';
import 'package:weatherly/features/settings/domain/entities/theme_mode_app.dart';

class SettingsLocalDatasource {
  final SharedPrefsService _sp;
  SettingsLocalDatasource(this._sp);

  TemperatureUnit getTemperatureUnit() {
    final v = _sp.getString(AppConstants.spTemperatureUnitKey);
    if (v == null) return TemperatureUnit.celsius;
    return TemperatureUnit.fromJson(v);
  }

  Future<void> setTemperatureUnit(TemperatureUnit u) =>
      _sp.setString(AppConstants.spTemperatureUnitKey, u.toJson());

  ThemeModeApp getThemeMode() {
    final v = _sp.getString(AppConstants.spThemeModeKey);
    if (v == null) return ThemeModeApp.system;
    return ThemeModeApp.fromJson(v);
  }

  Future<void> setThemeMode(ThemeModeApp m) =>
      _sp.setString(AppConstants.spThemeModeKey, m.toJson());
}
