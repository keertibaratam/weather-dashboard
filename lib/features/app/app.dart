import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/constants/app_constants.dart';
import 'package:weatherly/core/routing/app_router.dart';
import 'package:weatherly/core/routing/app_routes.dart';
import 'package:weatherly/core/theme/app_theme.dart';
import 'package:weatherly/features/settings/presentation/notifiers/settings_notifier.dart';

class WeatherlyApp extends ConsumerWidget {
  const WeatherlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsNotifierProvider.select((s) => s.theme));
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode.toMaterial(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}