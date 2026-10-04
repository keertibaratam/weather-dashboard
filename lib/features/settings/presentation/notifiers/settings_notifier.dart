import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/features/settings/data/providers.dart';
import 'package:weatherly/features/settings/domain/entities/temperature_unit.dart';
import 'package:weatherly/features/settings/domain/entities/theme_mode_app.dart';

class SettingsState {
  final TemperatureUnit unit;
  final ThemeModeApp theme;
  const SettingsState({required this.unit, required this.theme});
  SettingsState copyWith({TemperatureUnit? unit, ThemeModeApp? theme}) =>
      SettingsState(unit: unit ?? this.unit, theme: theme ?? this.theme);
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    Future.microtask(_load);
    return const SettingsState(
      unit: TemperatureUnit.celsius,
      theme: ThemeModeApp.system,
    );
  }

  Future<void> _load() async {
    final repo = ref.read(settingsRepositoryProvider);
    state = SettingsState(
      unit: await repo.getTemperatureUnit(),
      theme: await repo.getThemeMode(),
    );
  }

  Future<void> setUnit(TemperatureUnit u) async {
    state = state.copyWith(unit: u);
    await ref.read(settingsRepositoryProvider).setTemperatureUnit(u);
  }

  Future<void> setTheme(ThemeModeApp t) async {
    state = state.copyWith(theme: t);
    await ref.read(settingsRepositoryProvider).setThemeMode(t);
  }
}

final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
