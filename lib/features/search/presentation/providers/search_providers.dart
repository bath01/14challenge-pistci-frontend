import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pistci/features/map/domain/entities/map_marker.dart';
import 'package:pistci/features/map/presentation/providers/map_providers.dart';

/// Texte de recherche
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Résultats filtrés à partir des markers existants
final searchResultsProvider = Provider<List<MapMarker>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  if (query.length < 2) return [];

  final markersAsync = ref.watch(markersProvider);
  return markersAsync.maybeWhen(
    data: (markers) => markers
        .where((m) =>
            m.title.toLowerCase().contains(query) ||
            m.description.toLowerCase().contains(query))
        .toList(),
    orElse: () => [],
  );
});
