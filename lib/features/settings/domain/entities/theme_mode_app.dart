import 'package:flutter/material.dart' show ThemeMode;

enum ThemeModeApp {
  system,
  light,
  dark;

  String get label => switch (this) {
        system => 'System default',
        light => 'Light',
        dark => 'Dark',
      };

  ThemeMode toMaterial() => switch (this) {
        ThemeModeApp.light => ThemeMode.light,
        ThemeModeApp.dark => ThemeMode.dark,
        ThemeModeApp.system => ThemeMode.system,
      };

  static ThemeModeApp fromJson(String value) {
    return switch (value) {
      'light' => light,
      'dark' => dark,
      _ => system,
    };
  }

  String toJson() => name;
}
