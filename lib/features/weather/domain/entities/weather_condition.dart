import 'package:flutter/material.dart';

enum WeatherCondition {
  clear,
  partlyCloudy,
  cloudy,
  fog,
  drizzle,
  rain,
  freezingRain,
  showers,
  snow,
  snowGrains,
  thunderstorm,
  thunderstormWithHail;

  String get label => switch (this) {
        clear => 'Clear',
        partlyCloudy => 'Partly cloudy',
        cloudy => 'Cloudy',
        fog => 'Fog',
        drizzle => 'Drizzle',
        rain => 'Rain',
        freezingRain => 'Freezing rain',
        showers => 'Showers',
        snow => 'Snow',
        snowGrains => 'Snow grains',
        thunderstorm => 'Thunderstorm',
        thunderstormWithHail => 'Thunderstorm with hail',
      };

  IconData get icon => switch (this) {
        clear => Icons.wb_sunny_rounded,
        partlyCloudy => Icons.wb_cloudy_rounded,
        cloudy => Icons.cloud_rounded,
        fog => Icons.foggy,
        drizzle => Icons.water_drop_rounded,
        rain => Icons.umbrella_rounded,
        freezingRain => Icons.ac_unit_rounded,
        showers => Icons.shower_rounded,
        snow => Icons.snowing,
        snowGrains => Icons.cloudy_snowing,
        thunderstorm => Icons.thunderstorm_rounded,
        thunderstormWithHail => Icons.thunderstorm_rounded,
      };

  IconData iconForTime({required bool isDay}) {
    if (this != clear && this != partlyCloudy) return icon;
    if (isDay) return icon;
    return switch (this) {
      clear => Icons.nightlight_round,
      partlyCloudy => Icons.nights_stay_rounded,
      _ => icon,
    };
  }

  static WeatherCondition fromWmoCode(int code) {
    return switch (code) {
      0 => clear,
      1 => partlyCloudy,
      2 => partlyCloudy,
      3 => cloudy,
      45 => fog,
      48 => fog,
      51 => drizzle,
      53 => drizzle,
      55 => drizzle,
      56 => freezingRain,
      57 => freezingRain,
      61 => rain,
      63 => rain,
      65 => rain,
      66 => freezingRain,
      67 => freezingRain,
      71 => snow,
      73 => snow,
      75 => snow,
      77 => snowGrains,
      80 => showers,
      81 => showers,
      82 => showers,
      85 => snow,
      86 => snow,
      95 => thunderstorm,
      96 => thunderstormWithHail,
      99 => thunderstormWithHail,
      _ => clear,
    };
  }
}
