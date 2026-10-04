import 'package:flutter/material.dart';
import 'package:weatherly/core/routing/app_routes.dart';
import 'package:weatherly/features/favorites/presentation/favorites_screen.dart';
import 'package:weatherly/features/location/presentation/location_search_screen.dart';
import 'package:weatherly/features/settings/presentation/settings_screen.dart';
import 'package:weatherly/features/weather/presentation/weather_dashboard_screen.dart';

/// Maps named routes to their screens.
///
/// Passing the original [RouteSettings] through to the [MaterialPageRoute]
/// keeps the route name attached to the entry, which is what lets Flutter web
/// reflect navigation in the URL bar (e.g. `/favorites`).
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      AppRoutes.search => const LocationSearchScreen(),
      AppRoutes.favorites => const FavoritesScreen(),
      AppRoutes.settings => const SettingsScreen(),
      _ => const WeatherDashboardScreen(),
    };
    return MaterialPageRoute<dynamic>(
      builder: (_) => page,
      settings: settings,
    );
  }
}
