/// Named routes used across the app.
///
/// Flutter web syncs the browser URL with the current screen **by route name**.
/// Pushing anonymous `MaterialPageRoute`s never updates the URL bar, so every
/// screen must be reachable through one of these named routes.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
}
