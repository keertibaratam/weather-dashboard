import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherly/core/constants/app_constants.dart';
import 'package:weatherly/features/location/data/providers.dart';
import 'package:weatherly/features/location/domain/entities/location.dart';

typedef SearchResultsState = AsyncValue<List<LocationEntity>>;

class LocationSearchNotifier extends AutoDisposeAsyncNotifier<List<LocationEntity>> {
  Timer? _timer;
  String _lastQuery = '';

  @override
  FutureOr<List<LocationEntity>> build() {
    ref.onDispose(() => _timer?.cancel());
    return const <LocationEntity>[];
  }

  void query(String q) {
    _timer?.cancel();
    _timer = Timer(AppConstants.searchDebounce, () => _run(q.trim()));
  }

  Future<void> _run(String q) async {
    if (q == _lastQuery) return;
    _lastQuery = q;
    state = const AsyncValue.loading();
    final repo = ref.read(locationRepositoryProvider);
    final (list, failure) = await repo.searchLocations(q);
    if (q != _lastQuery) return;
    if (failure != null && list.isEmpty) {
      state = AsyncValue.error(failure, StackTrace.current);
    } else {
      state = AsyncValue.data(list);
    }
  }

  void reset() {
    _timer?.cancel();
    _lastQuery = '';
    state = const AsyncValue.data(<LocationEntity>[]);
  }
}

final locationSearchProvider = AutoDisposeAsyncNotifierProvider<LocationSearchNotifier, List<LocationEntity>>(
  LocationSearchNotifier.new,
);
