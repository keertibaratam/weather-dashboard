import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/features/settings/domain/entities/temperature_unit.dart';
import 'package:weatherly/features/settings/domain/entities/theme_mode_app.dart';
import 'package:weatherly/features/settings/presentation/notifiers/settings_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Units', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<TemperatureUnit>(
            segments: const [
              ButtonSegment(value: TemperatureUnit.celsius, label: Text('°C')),
              ButtonSegment(value: TemperatureUnit.fahrenheit, label: Text('°F')),
            ],
            selected: {settings.unit},
            onSelectionChanged: (s) => notifier.setUnit(s.first),
          ),
          const SizedBox(height: 28),
          Text('Theme', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ThemeModeApp>(
            segments: const [
              ButtonSegment(
                value: ThemeModeApp.system,
                icon: Icon(Icons.brightness_auto_rounded),
                label: Text('System'),
              ),
              ButtonSegment(
                value: ThemeModeApp.light,
                icon: Icon(Icons.light_mode_rounded),
                label: Text('Light'),
              ),
              ButtonSegment(
                value: ThemeModeApp.dark,
                icon: Icon(Icons.dark_mode_rounded),
                label: Text('Dark'),
              ),
            ],
            selected: {settings.theme},
            onSelectionChanged: (selection) => notifier.setTheme(selection.first),
          ),
        ],
      ),
    );
  }
}