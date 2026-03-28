import 'package:pistci/features/map/data/datasources/mock_marker_datasource.dart';
import 'package:pistci/features/map/data/datasources/remote_marker_datasource.dart';
import 'package:pistci/features/map/domain/entities/map_marker.dart';
import 'package:pistci/features/map/domain/repositories/marker_repository.dart';

/// Repository qui combine l'API distante + les données mock locales.
/// En cas d'erreur réseau, retourne les données mock en fallback.
class RemoteMarkerRepository implements MarkerRepository {
  final RemoteMarkerDatasource _remoteDatasource;

  /// Cache local des markers (API + mock fusionnés)
  List<MapMarker>? _cachedMarkers;

  RemoteMarkerRepository(this._remoteDatasource);

  @override
  Future<List<MapMarker>> getAllMarkers() async {
    if (_cachedMarkers != null) return _cachedMarkers!;

    try {
      // Récupérer les données de l'API
      final remoteMarkers = await _remoteDatasource.fetchPlaces();
      // Fusionner avec les données mock locales (urgences, services, etc.)
      final localMarkers = MockMarkerDatasource.markers;
      _cachedMarkers = [...remoteMarkers, ...localMarkers];
    } catch (_) {
      // Fallback : données mock uniquement
      _cachedMarkers = List.from(MockMarkerDatasource.markers);
    }

    return _cachedMarkers!;
  }

  @override
  Future<MapMarker?> getMarkerById(String id) async {
    final markers = await getAllMarkers();
    return markers.where((m) => m.id == id).firstOrNull;
  }

  @override
  Future<List<MapMarker>> getMarkersByCategory(MarkerCategory category) async {
    final markers = await getAllMarkers();
    return markers.where((m) => m.category == category).toList();
  }

  @override
  Future<void> createMarker(MapMarker marker) async {
    _cachedMarkers ??= [];
    _cachedMarkers!.add(marker);
  }

  @override
  Future<void> updateMarker(MapMarker marker) async {
    if (_cachedMarkers == null) return;
    final index = _cachedMarkers!.indexWhere((m) => m.id == marker.id);
    if (index != -1) _cachedMarkers![index] = marker;
  }

  @override
  Future<void> deleteMarker(String id) async {
    _cachedMarkers?.removeWhere((m) => m.id == id);
  }
}
