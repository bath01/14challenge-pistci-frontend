import 'package:pistci/features/map/domain/entities/map_marker.dart';

/// Contrat pour l'accès aux données des markers
abstract class MarkerRepository {
  Future<List<MapMarker>> getAllMarkers();
  Future<MapMarker?> getMarkerById(String id);
  Future<List<MapMarker>> getMarkersByCategory(MarkerCategory category);
  Future<void> createMarker(MapMarker marker);
  Future<void> updateMarker(MapMarker marker);
  Future<void> deleteMarker(String id);
}
