import 'package:weatherly/features/settings/domain/entities/temperature_unit.dart';
import 'package:weatherly/features/settings/domain/entities/theme_mode_app.dart';
import 'package:weatherly/features/settings/domain/repositories/settings_repository.dart';
import '../datasources/settings_local_ds.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDatasource _ds;
  SettingsRepositoryImpl(this._ds);

  @override
  Future<TemperatureUnit> getTemperatureUnit() async => _ds.getTemperatureUnit();

  @override
  Future<void> setTemperatureUnit(TemperatureUnit unit) => _ds.setTemperatureUnit(unit);

  @override
  Future<ThemeModeApp> getThemeMode() async => _ds.getThemeMode();

  @override
  Future<void> setThemeMode(ThemeModeApp mode) => _ds.setThemeMode(mode);
}
