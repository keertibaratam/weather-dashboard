import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/core/error/failures.dart';
import 'package:weatherly/core/routing/app_router.dart';
import 'package:weatherly/core/routing/app_routes.dart';
import 'package:weatherly/core/theme/app_theme.dart';
import 'package:weatherly/features/favorites/domain/entities/favorite_location.dart';
import 'package:weatherly/features/favorites/presentation/notifiers/favorites_notifier.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';
import 'package:weatherly/features/settings/domain/entities/temperature_unit.dart';
import 'package:weatherly/features/settings/domain/entities/theme_mode_app.dart';
import 'package:weatherly/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:weatherly/features/settings/presentation/settings_screen.dart';
import 'package:weatherly/features/weather/domain/entities/weather.dart';
import 'package:weatherly/features/weather/domain/entities/weather_condition.dart';
import 'package:weatherly/features/weather/presentation/notifiers/weather_notifier.dart';
import 'package:weatherly/features/weather/presentation/weather_dashboard_screen.dart';

Weather _sampleWeather({bool fromCache = false}) {
  final now = DateTime.now();
  // Anchor hourly data to the current hour so the current-hour tile is not
  // dropped by [Weather.next24Hours]'s "not before now" filter.
  final hourAnchor = DateTime(now.year, now.month, now.day, now.hour);
  const location = LocationEntity(
    id: 'amsterdam',
    name: 'Amsterdam',
    region: 'NH',
    country: 'Netherlands',
    latitude: 52.3702,
    longitude: 4.8952,
  );
  final hourly = List.generate(24, (i) {
    final t = hourAnchor.add(Duration(hours: i));
    return HourlyWeather(
      time: t,
      temperatureCelsius: 10 + (i % 6).toDouble(),
      feelsLikeCelsius: 9 + (i % 5).toDouble(),
      condition: i % 4 == 0 ? WeatherCondition.cloudy : WeatherCondition.rain,
      weatherCode: i % 4 == 0 ? 3 : 61,
      precipitationProbabilityPercent: 10 + (i % 3) * 20,
    );
  });
  final today = DateTime(now.year, now.month, now.day);
  final daily = List.generate(7, (i) {
    final d = today.add(Duration(days: i));
    return DailyWeather(
      date: d,
      condition: WeatherCondition.rain,
      weatherCode: 61,
      maxTempCelsius: 16 + i.toDouble(),
      minTempCelsius: 8 + i.toDouble(),
      sunrise: DateTime(d.year, d.month, d.day, 6, 0),
      sunset: DateTime(d.year, d.month, d.day, 20, 0),
      precipitationProbabilityMaxPercent: 40 + i * 5,
    );
  });
  return Weather(
    location: location,
    current: CurrentWeather(
      temperatureCelsius: 12.0,
      feelsLikeCelsius: 11.5,
      humidityPercent: 67,
      condition: WeatherCondition.rain,
      weatherCode: 61,
      windSpeedKmh: 14.3,
      windDirectionDegrees: 210,
      precipitationMm: 0.4,
      time: now,
      isDay: true,
    ),
    hourly: hourly,
    daily: daily,
    timezone: 'Europe/Amsterdam',
    fetchedAt: now,
    isFromCache: fromCache,
  );
}

class _FakeWeatherNotifier extends WeatherNotifier {
  final Weather weather;
  _FakeWeatherNotifier({required this.weather});

  @override
  Future<WeatherFetchResult?> build() async => WeatherFetchResult(weather);

  @override
  Future<void> refresh() async {
    state = await AsyncValue.guard(() async => WeatherFetchResult(weather));
  }
}

class _FailingWeatherNotifier extends WeatherNotifier {
  @override
  Future<WeatherFetchResult?> build() async {
    throw const NetworkFailure();
  }
}

class _LoadingWeatherNotifier extends WeatherNotifier {
  @override
  Future<WeatherFetchResult?> build() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    return null;
  }
}

class _FakeSettingsNotifier extends SettingsNotifier {
  @override
  SettingsState build() =>
      const SettingsState(unit: TemperatureUnit.celsius, theme: ThemeModeApp.system);
}

class _FakeFavoritesNotifier extends FavoritesNotifier {
  @override
  List<FavoriteLocation> build() => const <FavoriteLocation>[];
}

Widget _buildApp(WeatherNotifier notifier) {
  return ProviderScope(
    overrides: [
      weatherNotifierProvider.overrideWith(() => notifier),
      settingsNotifierProvider.overrideWith(_FakeSettingsNotifier.new),
      favoritesNotifierProvider.overrideWith(_FakeFavoritesNotifier.new),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    ),
  );
}
void main() {
  testWidgets('renders current, hourly, daily and details sections',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _buildApp(_FakeWeatherNotifier(weather: _sampleWeather())),
    );
    await tester.pumpAndSettle();

    // Current weather header.
    expect(find.text('Amsterdam'), findsOneWidget);
    expect(find.text('NH, Netherlands'), findsOneWidget);
    expect(find.text('Rain'), findsOneWidget);
    expect(find.textContaining('Feels like'), findsWidgets);
    expect(find.text('12°C'), findsWidgets);

    // Hourly forecast.
    expect(find.text('Next 24 Hours'), findsOneWidget);
    expect(find.text('Now'), findsOneWidget);

    // Daily forecast.
    expect(find.text('7-Day Forecast'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Tomorrow'), findsOneWidget);

    // Details metrics.
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Humidity'), findsOneWidget);
    expect(find.text('67%'), findsOneWidget);
    expect(find.text('Wind'), findsOneWidget);
    expect(find.text('14 km/h SW'), findsOneWidget);
    expect(find.text('Sunrise'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
    expect(find.text('6:00 AM'), findsOneWidget);
    expect(find.text('8:00 PM'), findsOneWidget);
  });

  testWidgets('renders error view with retry button when fetching fails',
      (tester) async {
    await tester.pumpWidget(_buildApp(_FailingWeatherNotifier()));
    await tester.pumpAndSettle();

    expect(find.text('Couldn\'t load weather'), findsOneWidget);
    expect(find.text('No internet connection'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
  });

  testWidgets('shows a loading indicator while fetching', (tester) async {
    await tester.pumpWidget(_buildApp(_LoadingWeatherNotifier()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Fetching the forecast…'), findsOneWidget);

    // Let the delayed future complete, then the empty state appears.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    expect(find.text('No location selected'), findsOneWidget);
  });

  testWidgets('refresh button re-triggers data load', (tester) async {
    await tester.pumpWidget(
      _buildApp(_FakeWeatherNotifier(weather: _sampleWeather(fromCache: true))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cached'), findsOneWidget);

    await tester.tap(find.byTooltip('Refresh'));
    await tester.pumpAndSettle();

    // Data is still rendered after a refresh cycle.
    expect(find.text('Amsterdam'), findsOneWidget);
    expect(find.text('Rain'), findsOneWidget);
  });

  testWidgets('opens the settings screen via its named route', (tester) async {
    await tester.pumpWidget(
      _buildApp(_FakeWeatherNotifier(weather: _sampleWeather())),
    );
    await tester.pumpAndSettle();

    expect(find.byType(WeatherDashboardScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Settings'), findsWidgets);
  });
}