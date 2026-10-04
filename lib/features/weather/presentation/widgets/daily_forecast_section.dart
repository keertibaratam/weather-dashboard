import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/features/weather/domain/entities/weather.dart';
import 'package:weatherly/features/weather/presentation/widgets/dashboard_section_header.dart';
import 'package:weatherly/features/weather/presentation/widgets/temperature_text.dart';

/// Vertical list of the 7-day forecast.
class DailyForecastSection extends StatelessWidget {
  final List<DailyWeather> days;

  const DailyForecastSection({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionHeader(
          title: '7-Day Forecast',
          icon: Icons.calendar_month_rounded,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                for (var i = 0; i < days.length; i++) ...[
                  _DailyRow(day: days[i]),
                  if (i != days.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyRow extends StatelessWidget {
  final DailyWeather day;

  const _DailyRow({required this.day});

  String _dayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == today.add(const Duration(days: 1))) return 'Tomorrow';
    return DateFormat('EEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(_dayLabel(day.date), style: theme.textTheme.labelLarge),
          ),
          Icon(day.condition.icon, size: 22, color: scheme.primary),
          const SizedBox(width: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.water_drop_rounded,
                size: 14,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 2),
              Text(
                '${day.precipitationProbabilityMaxPercent}%',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const Spacer(),
          TemperatureText(
            celsius: day.minTempCelsius,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text('–', style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          ),
          TemperatureText(
            celsius: day.maxTempCelsius,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}