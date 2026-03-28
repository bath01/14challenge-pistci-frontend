import 'package:pistci/features/map/data/datasources/mock_marker_datasource.dart';
import 'package:pistci/features/map/domain/entities/map_marker.dart';
import 'package:pistci/features/map/domain/repositories/marker_repository.dart';

/// Implémentation locale avec données mock
class MockMarkerRepository implements MarkerRepository {
  final List<MapMarker> _markers = List.from(MockMarkerDatasource.markers);

  @override
  Future<List<MapMarker>> getAllMarkers() async => _markers;

  @override
  Future<MapMarker?> getMarkerById(String id) async {
    return _markers.where((m) => m.id == id).firstOrNull;
  }

  @override
  Future<List<MapMarker>> getMarkersByCategory(MarkerCategory category) async {
    return _markers.where((m) => m.category == category).toList();
  }

  @override
  Future<void> createMarker(MapMarker marker) async {
    _markers.add(marker);
  }

  @override
  Future<void> updateMarker(MapMarker marker) async {
    final index = _markers.indexWhere((m) => m.id == marker.id);
    if (index != -1) _markers[index] = marker;
  }

  @override
  Future<void> deleteMarker(String id) async {
    _markers.removeWhere((m) => m.id == id);
  }
}
