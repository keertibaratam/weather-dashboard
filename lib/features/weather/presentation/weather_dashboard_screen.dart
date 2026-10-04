import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/core/constants/app_constants.dart';
import 'package:weatherly/core/error/failures.dart';
import 'package:weatherly/core/routing/app_routes.dart';
import 'package:weatherly/features/weather/domain/entities/weather.dart';
import 'package:weatherly/features/weather/presentation/notifiers/weather_notifier.dart';
import 'package:weatherly/features/weather/presentation/widgets/current_weather_header.dart';
import 'package:weatherly/features/weather/presentation/widgets/daily_forecast_section.dart';
import 'package:weatherly/features/weather/presentation/widgets/hourly_forecast_section.dart';
import 'package:weatherly/features/weather/presentation/widgets/weather_metrics_section.dart';
import 'package:weatherly/features/weather/presentation/widgets/weather_state_views.dart';

/// Main page: current weather + hourly + daily + detail metrics.
class WeatherDashboardScreen extends ConsumerWidget {
  const WeatherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherValue = ref.watch(weatherNotifierProvider);
    Future<void> refresh() =>
        ref.read(weatherNotifierProvider.notifier).refresh();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.search),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: 'Favorites',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.favorites),
            icon: const Icon(Icons.star_border_rounded),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_rounded),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: weatherValue.when(
        data: (result) {
          if (result == null) return const NoLocationView();
          return _DashboardContent(
            weather: result.weather,
            staleReason: result.staleReason,
            onRefresh: refresh,
          );
        },
        error: (error, _) => WeatherErrorView(error: error, onRetry: refresh),
        loading: () => const WeatherLoadingView(),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final Weather weather;
  final Object? staleReason;
  final Future<void> Function() onRefresh;

  const _DashboardContent({
    required this.weather,
    required this.staleReason,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          if (staleReason != null) ...[
            _OfflineNoticeBanner(
              message: staleReason is Failure
                  ? (staleReason as Failure).message
                  : 'Unable to reach the network.',
              lastUpdated: weather.fetchedAt,
            ),
            const SizedBox(height: 12),
          ],
          CurrentWeatherHeader(weather: weather),
          const SizedBox(height: 24),
          HourlyForecastSection(hours: weather.next24Hours),
          const SizedBox(height: 24),
          DailyForecastSection(days: weather.daily),
          const SizedBox(height: 24),
          WeatherMetricsSection(weather: weather),
        ],
      ),
    );
  }
}
/// Shown above the forecast when data was served from the offline cache.
class _OfflineNoticeBanner extends StatelessWidget {
  final String message;
  final DateTime lastUpdated;

  const _OfflineNoticeBanner({
    required this.message,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, size: 20, color: scheme.onTertiaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline — showing cached data',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: scheme.onTertiaryContainer),
                ),
                const SizedBox(height: 2),
                Text(
                  '$message · Last updated ${DateFormat('h:mm a').format(lastUpdated)}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: scheme.onTertiaryContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}