import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/features/weather/domain/entities/weather.dart';
import 'package:weatherly/features/weather/presentation/widgets/dashboard_section_header.dart';
import 'package:weatherly/features/weather/presentation/widgets/temperature_text.dart';

/// Grid of secondary metrics: feels like, humidity, wind, precipitation,
/// sunrise and sunset.
class WeatherMetricsSection extends StatelessWidget {
  final Weather weather;

  const WeatherMetricsSection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = weather.current;
    final windKmh = current.windSpeedKmh.toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionHeader(
          title: 'Details',
          icon: Icons.insights_rounded,
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.4,
          children: [
            _MetricTile(
              icon: Icons.thermostat_rounded,
              label: 'Feels like',
              value: TemperatureText(
                celsius: current.feelsLikeCelsius,
                style: theme.textTheme.titleMedium,
              ),
            ),
            _MetricTile(
              icon: Icons.water_drop_outlined,
              label: 'Humidity',
              value: Text(
                '${current.humidityPercent}%',
                style: theme.textTheme.titleMedium,
              ),
            ),
            _MetricTile(
              icon: Icons.air_rounded,
              label: 'Wind',
              value: Text(
                '$windKmh km/h ${current.windDirectionLabel}',
                style: theme.textTheme.titleMedium,
              ),
            ),
            _MetricTile(
              icon: Icons.umbrella_rounded,
              label: 'Precipitation',
              value: Text(
                '${current.precipitationMm.toStringAsFixed(1)} mm',
                style: theme.textTheme.titleMedium,
              ),
            ),
            _MetricTile(
              icon: Icons.wb_twilight_rounded,
              label: 'Sunrise',
              value: Text(
                DateFormat('h:mm a').format(weather.sunrise),
                style: theme.textTheme.titleMedium,
              ),
            ),
            _MetricTile(
              icon: Icons.nights_stay_rounded,
              label: 'Sunset',
              value: Text(
                DateFormat('h:mm a').format(weather.sunset),
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget value;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}