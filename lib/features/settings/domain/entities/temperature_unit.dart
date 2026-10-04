enum TemperatureUnit {
  celsius,
  fahrenheit;

  String get label => switch (this) {
        celsius => 'Celsius',
        fahrenheit => 'Fahrenheit',
      };

  String get symbol => switch (this) {
        celsius => '°C',
        fahrenheit => '°F',
      };

  static TemperatureUnit fromJson(String value) {
    return switch (value) {
      'fahrenheit' => fahrenheit,
      _ => celsius,
    };
  }

  String toJson() => name;

  static double convert(double valueCelsius, TemperatureUnit to) {
    if (to == TemperatureUnit.celsius) return valueCelsius;
    return valueCelsius * 9.0 / 5.0 + 32.0;
  }
}
