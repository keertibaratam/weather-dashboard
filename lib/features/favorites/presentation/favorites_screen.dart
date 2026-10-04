import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/features/favorites/presentation/notifiers/favorites_notifier.dart';
import 'package:weatherly/features/weather/presentation/notifiers/weather_notifier.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const Center(
              child: Text('No favorites yet — tap the ★ on the dashboard to save a place.'),
            )
          : ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (_, _) =>
                  const Divider(indent: 16, endIndent: 16),
              itemBuilder: (context, i) {
                final loc = favorites[i].location;
                final sub = [
                  if (loc.region?.isNotEmpty == true) loc.region,
                  if (loc.country?.isNotEmpty == true) loc.country,
                ].join(', ');
                return ListTile(
                  leading: const Icon(Icons.star_rounded, color: Colors.amber),
                  title: Text(loc.name),
                  subtitle: sub.isEmpty ? null : Text(sub),
                  trailing: IconButton(
                    tooltip: 'Remove favorite',
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () =>
                        ref.read(favoritesNotifierProvider.notifier).remove(loc.id),
                  ),
                  onTap: () {
                    ref.read(selectedLocationProvider.notifier).set(loc);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
    );
  }
}