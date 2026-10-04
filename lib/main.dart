import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import the url_strategy sub-library, NOT flutter_web_plugins.dart. The main
// entry point pulls in dart:ui_web which breaks native (Android/iOS) builds.
// This sub-library conditionally exports a web-only implementation and a
// no-op implementation for native platforms, so it is safe everywhere.
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:weatherly/core/providers.dart';
import 'package:weatherly/core/storage/hive_service.dart';
import 'package:weatherly/core/storage/shared_prefs_service.dart';
import 'package:weatherly/features/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Use the URL pathname (e.g. /favorites) instead of the default hash
  // strategy (#/favorites) so navigation shows up in the browser URL bar.
  // No-op on native platforms.
  usePathUrlStrategy();
  final prefs = SharedPrefsService();
  final hive = HiveService();
  await Future.wait([prefs.init(), hive.init()]);
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(prefs),
        hiveServiceProvider.overrideWithValue(hive),
      ],
      child: const WeatherlyApp(),
    ),
  );
}
