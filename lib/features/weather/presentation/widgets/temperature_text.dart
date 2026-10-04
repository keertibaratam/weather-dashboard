import 'package:flutter/material.dart';
import 'package:weatherly/features/settings/domain/entities/temperature_unit.dart';
import 'package:weatherly/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract final class TempText {
  static String format(double celsius, TemperatureUnit unit, [int decimals = 0]) {
    final v = TemperatureUnit.convert(celsius, unit);
    final s = v.toStringAsFixed(decimals);
    return '${s == '-0' ? '0' : s}${unit.symbol}';
  }
}

class TemperatureText extends ConsumerWidget {
  final double celsius;
  final TextStyle? style;
  final int decimals;
  const TemperatureText({
    super.key,
    required this.celsius,
    this.style,
    this.decimals = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unit = ref.watch(settingsNotifierProvider.select((s) => s.unit));
    return Text(TempText.format(celsius, unit, decimals), style: style);
  }
}
