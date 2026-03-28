import 'package:latlong2/latlong.dart';

/// Valeurs par défaut pour la carte et l'application
class AppDefaults {
  AppDefaults._();

  // Centre par défaut : Abidjan, Côte d'Ivoire
  static final LatLng defaultCenter = LatLng(5.3167, -4.0333);
  static const double defaultZoom = 12.0;
  static const double minZoom = 1.0;
  static const double maxZoom = 20.0;

  // Clustering
  static const int clusterRadius = 80;

  // Tile providers par type de carte
  static const Map<String, String> tileUrls = {
    'standard': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    'satellite': 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    'terrain': 'https://tile.opentopomap.org/{z}/{x}/{y}.png',
  };

  static const String osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
}
