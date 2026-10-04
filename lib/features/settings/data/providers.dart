import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/providers.dart';
import 'package:weatherly/features/settings/data/datasources/settings_local_ds.dart';
import 'package:weatherly/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:weatherly/features/settings/domain/repositories/settings_repository.dart';

final settingsLocalDatasourceProvider = Provider<SettingsLocalDatasource>((ref) {
  return SettingsLocalDatasource(ref.watch(sharedPrefsServiceProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsLocalDatasourceProvider));
});
