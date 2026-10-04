class AppConstants {
  AppConstants._();

  static const String appName = 'Weatherly';

  static const String openMeteoForecastBaseUrl =
      'https://api.open-meteo.com/v1';

  static const String openMeteoGeocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 10);

  static const Duration searchDebounce = Duration(milliseconds: 350);

  static const int maxSearchResults = 10;

  static const double defaultLatitude = 40.7128;
  static const double defaultLongitude = -74.0060;
  static const String defaultCityName = 'New York';
  static const String defaultRegion = 'NY';
  static const String defaultCountry = 'United States';

  static const String weatherHiveBoxName = 'weather_cache';
  static const String favoritesHiveBoxName = 'favorites';

  static const String spThemeModeKey = 'theme_mode';
  static const String spTemperatureUnitKey = 'temperature_unit';
  static const String spFavoritesKey = 'favorites_v2';
  static const String spSelectedLocationKey = 'selected_location';

  static const List<String> forecastCurrentParams = [
    'temperature_2m',
    'relative_humidity_2m',
    'apparent_temperature',
    'precipitation',
    'weather_code',
    'wind_speed_10m',
    'wind_direction_10m',
  ];

  static const List<String> forecastHourlyParams = [
    'temperature_2m',
    'precipitation_probability',
    'weather_code',
    'apparent_temperature',
  ];

  static const List<String> forecastDailyParams = [
    'weather_code',
    'temperature_2m_max',
    'temperature_2m_min',
    'sunrise',
    'sunset',
    'precipitation_probability_max',
  ];
}
