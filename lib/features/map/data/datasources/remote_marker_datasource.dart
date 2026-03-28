import 'package:dio/dio.dart';
import 'package:pistci/features/map/domain/entities/map_marker.dart';

/// Datasource distant — appelle GET /places et convertit en MapMarker
class RemoteMarkerDatasource {
  final Dio _dio;

  RemoteMarkerDatasource(this._dio);

  /// Récupère les lieux depuis l'API et les convertit en MapMarker
  Future<List<MapMarker>> fetchPlaces() async {
    final response = await _dio.get('/places');
    final List<dynamic> data = response.data is List ? response.data : [];

    return data.map((json) => _fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Convertit un objet JSON de l'API en MapMarker
  MapMarker _fromJson(Map<String, dynamic> json) {
    return MapMarker(
      id: 'api_${json['id']}',
      title: json['name'] ?? '',
      description: _buildDescription(json),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      category: _mapCategory(json['category'] as String? ?? ''),
    );
  }

  /// Construit une description riche à partir de city + region + description
  String _buildDescription(Map<String, dynamic> json) {
    final desc = json['description'] as String? ?? '';
    final city = json['city'] as String? ?? '';
    final region = json['region'] as String? ?? '';

    final parts = <String>[];
    if (desc.isNotEmpty) parts.add(desc);
    if (city.isNotEmpty && region.isNotEmpty) {
      parts.add('$city, $region');
    } else if (city.isNotEmpty) {
      parts.add(city);
    }

    return parts.join(' — ');
  }

  /// Mappe les catégories textuelles de l'API vers l'enum MarkerCategory
  MarkerCategory _mapCategory(String apiCategory) {
    final lower = apiCategory.toLowerCase();

    if (lower.contains('monument') || lower.contains('religieux')) {
      return MarkerCategory.monument;
    }
    if (lower.contains('parc') || lower.contains('naturel') || lower.contains('lac')) {
      return MarkerCategory.loisir;
    }
    if (lower.contains('culturel') || lower.contains('historique')) {
      return MarkerCategory.monument;
    }
    if (lower.contains('mus')) {
      return MarkerCategory.education;
    }
    if (lower.contains('march') || lower.contains('commerce')) {
      return MarkerCategory.commerce;
    }
    if (lower.contains('transport') || lower.contains('gare') || lower.contains('port')) {
      return MarkerCategory.transport;
    }
    if (lower.contains('hotel') || lower.contains('hebergement')) {
      return MarkerCategory.hotel;
    }
    if (lower.contains('hopital') || lower.contains('urgence') || lower.contains('pharmacie')) {
      return MarkerCategory.urgence;
    }

    return MarkerCategory.custom;
  }
}
