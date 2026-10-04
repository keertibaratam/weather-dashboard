import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weatherly/features/favorites/presentation/notifiers/favorites_notifier.dart';
import 'package:weatherly/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:weatherly/features/weather/domain/entities/weather.dart';
import 'package:weatherly/features/weather/presentation/widgets/temperature_text.dart';

/// Hero card showing the selected location + current conditions.
class CurrentWeatherHeader extends ConsumerWidget {
  final Weather weather;

  const CurrentWeatherHeader({super.key, required this.weather});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final current = weather.current;
    final unit = ref.watch(settingsNotifierProvider.select((s) => s.unit));
    final isFavorite = ref.watch(
      favoritesNotifierProvider.select((f) => f.any((x) => x.id == weather.location.id)),
    );
    final location = weather.location;
    final today = weather.daily.isNotEmpty ? weather.daily.first : null;

    final secondaryLine = [
      if (location.region?.isNotEmpty == true) location.region,
      if (location.country?.isNotEmpty == true) location.country,
    ].join(', ');

    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.surfaceContainerHigh.withValues(alpha: 0.65),
              scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location name + cache indicator.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_outlined, size: 20, color: scheme.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(location.name, style: theme.textTheme.headlineSmall),
                      if (secondaryLine.isNotEmpty)
                        Text(
                          secondaryLine,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isFavorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => ref
                      .read(favoritesNotifierProvider.notifier)
                      .toggle(location),
                  icon: Icon(
                    isFavorite
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: isFavorite ? Colors.amber : scheme.onSurfaceVariant,
                  ),
                ),
                if (weather.isFromCache) const _CachedDataChip(),
              ],
            ),
            const SizedBox(height: 20),
            // Condition icon + big temperature.
            Row(
              children: [
                Icon(
                  current.condition.iconForTime(isDay: current.isDay),
                  size: 88,
                  color: scheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: TemperatureText(
                      celsius: current.temperatureCelsius,
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(current.condition.label, style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Wrap(
              spacing: 14,
              runSpacing: 4,
              children: [
                Text(
                  'Feels like ${TempText.format(current.feelsLikeCelsius, unit)}',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                if (today != null) ...[
                  Text(
                    'H: ${TempText.format(today.maxTempCelsius, unit)}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  Text(
                    'L: ${TempText.format(today.minTempCelsius, unit)}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 14, color: scheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  'Updated ${DateFormat('h:mm a').format(weather.fetchedAt)}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
/// Small pill shown when the current data was served from the offline cache.
class _CachedDataChip extends StatelessWidget {
  const _CachedDataChip();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.offline_pin_rounded, size: 14, color: scheme.onTertiaryContainer),
          const SizedBox(width: 4),
          Text(
            'Cached',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: scheme.onTertiaryContainer),
          ),
        ],
      ),
    );
  }
}