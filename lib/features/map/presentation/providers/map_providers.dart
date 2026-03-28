import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:pistci/core/network/api_client.dart';
import 'package:pistci/features/map/data/datasources/remote_marker_datasource.dart';
import 'package:pistci/features/map/data/repositories/remote_marker_repository.dart';
import 'package:pistci/features/map/domain/entities/map_marker.dart';
import 'package:pistci/features/map/domain/entities/map_state.dart';
import 'package:pistci/features/map/domain/repositories/marker_repository.dart';

/// Repository des markers — API distante avec fallback mock
final markerRepositoryProvider = Provider<MarkerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RemoteMarkerRepository(RemoteMarkerDatasource(dio));
});

/// Liste de tous les markers
final markersProvider = FutureProvider<List<MapMarker>>((ref) async {
  final repo = ref.watch(markerRepositoryProvider);
  return repo.getAllMarkers();
});

/// Catégorie sélectionnée (null = toutes)
final selectedCategoryProvider = StateProvider<MarkerCategory?>((ref) => null);

/// Markers filtrés par catégorie
final filteredMarkersProvider = Provider<AsyncValue<List<MapMarker>>>((ref) {
  final markersAsync = ref.watch(markersProvider);
  final category = ref.watch(selectedCategoryProvider);

  return markersAsync.whenData((markers) {
    if (category == null) return markers;
    return markers.where((m) => m.category == category).toList();
  });
});

/// Marker sélectionné
final selectedMarkerProvider = StateProvider<MapMarker?>((ref) => null);

/// Etat de la vue carte
final mapViewStateProvider = StateNotifierProvider<MapViewStateNotifier, MapViewState>(
  (ref) => MapViewStateNotifier(),
);

/// Notifier pour gérer l'état de la carte
class MapViewStateNotifier extends StateNotifier<MapViewState> {
  MapViewStateNotifier() : super(MapViewState.initial());

  void setMapType(MapType type) {
    state = state.copyWith(mapType: type);
  }

  void setZoom(double zoom) {
    state = state.copyWith(zoom: zoom);
  }

  void zoomIn() {
    if (state.zoom < 20) state = state.copyWith(zoom: state.zoom + 1);
  }

  void zoomOut() {
    if (state.zoom > 1) state = state.copyWith(zoom: state.zoom - 1);
  }

  void toggleTracking() {
    state = state.copyWith(isTracking: !state.isTracking);
  }

  void moveTo(LatLng center, {double? zoom}) {
    state = state.copyWith(center: center, zoom: zoom);
  }
}
