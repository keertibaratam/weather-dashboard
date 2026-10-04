import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/features/weather/domain/entities/weather.dart';
import 'package:weatherly/features/weather/presentation/widgets/dashboard_section_header.dart';
import 'package:weatherly/features/weather/presentation/widgets/temperature_text.dart';

/// Horizontally scrollable strip of the next hours of the forecast.
class HourlyForecastSection extends StatelessWidget {
  final List<HourlyWeather> hours;

  const HourlyForecastSection({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    if (hours.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionHeader(
          title: 'Next 24 Hours',
          icon: Icons.schedule_rounded,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: SizedBox(
              height: 124,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: hours.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) => _HourTile(hour: hours[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HourTile extends StatelessWidget {
  final HourlyWeather hour;

  const _HourTile({required this.hour});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isNow = hour.isSameHourAsNow;
    // Approximate day/night from the hour so clear/partly-cloudy icons flip.
    final isDay = hour.time.hour >= 6 && hour.time.hour < 18;

    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isNow ? 'Now' : DateFormat('h a').format(hour.time),
            style: theme.textTheme.labelMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          Icon(
            hour.condition.iconForTime(isDay: isDay),
            size: 24,
            color: scheme.primary,
          ),
          TemperatureText(
            celsius: hour.temperatureCelsius,
            style: theme.textTheme.titleSmall,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop_rounded, size: 12, color: scheme.primary),
              const SizedBox(width: 2),
              Text(
                '${hour.precipitationProbabilityPercent}%',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}