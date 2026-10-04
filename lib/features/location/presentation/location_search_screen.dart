import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/error/failures.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';
import 'package:weatherly/features/location/presentation/notifiers/location_search_notifier.dart';
import 'package:weatherly/features/weather/presentation/notifiers/weather_notifier.dart';

class LocationSearchScreen extends ConsumerWidget {
  const LocationSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(locationSearchProvider);

    void select(LocationEntity loc) {
      ref.read(selectedLocationProvider.notifier).set(loc);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Search location')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'City name',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (q) =>
                  ref.read(locationSearchProvider.notifier).query(q),
            ),
          ),
          Expanded(
            child: results.when(
              data: (list) => list.isEmpty
                  ? const Center(child: Text('Type to search for a city'))
                  : ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, _) =>
                          const Divider(indent: 16, endIndent: 16),
                      itemBuilder: (context, i) {
                        final loc = list[i];
                        final sub = [
                          if (loc.region?.isNotEmpty == true) loc.region,
                          if (loc.country?.isNotEmpty == true) loc.country,
                        ].join(', ');
                        return ListTile(
                          leading: const Icon(Icons.location_city_rounded),
                          title: Text(loc.name),
                          subtitle: sub.isEmpty ? null : Text(sub),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => select(loc),
                        );
                      },
                    ),
              error: (error, _) => Center(
                child: Text(switch (error) {
                  Failure(:final message) => message,
                  _ => 'Something went wrong. Try again.',
                }),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}