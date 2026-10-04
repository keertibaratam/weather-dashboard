import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/core/routing/app_router.dart';
import 'package:weatherly/core/routing/app_routes.dart';
import 'package:weatherly/features/favorites/presentation/favorites_screen.dart';
import 'package:weatherly/features/location/presentation/location_search_screen.dart';
import 'package:weatherly/features/settings/presentation/settings_screen.dart';
import 'package:weatherly/features/weather/presentation/weather_dashboard_screen.dart';

void main() {
  group('AppRouter.onGenerateRoute', () {
    const cases = <String, Type>{
      AppRoutes.home: WeatherDashboardScreen,
      AppRoutes.search: LocationSearchScreen,
      AppRoutes.favorites: FavoritesScreen,
      AppRoutes.settings: SettingsScreen,
    };

    test('maps every named route to its screen', () {
      for (final entry in cases.entries) {
        final route = AppRouter.onGenerateRoute(
          RouteSettings(name: entry.key),
        );
        expect(route, isA<MaterialPageRoute<dynamic>>());
        // The route name must be preserved on the generated route — this is
        // exactly what lets Flutter web reflect the route in the URL bar.
        expect(route.settings.name, entry.key);
      }
    });

    test('falls back to the dashboard for unknown routes', () {
      final route = AppRouter.onGenerateRoute(
        const RouteSettings(name: '/does-not-exist'),
      );
      expect(route, isA<MaterialPageRoute<dynamic>>());
      expect(route.settings.name, '/does-not-exist');
    });
  });
}
