import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:pistci/features/routes/data/datasources/mock_route_datasource.dart';
import 'package:pistci/features/routes/domain/entities/route_entity.dart';
import 'package:pistci/features/routes/domain/repositories/route_repository.dart';

/// Repository avec calcul d'itinéraire dynamique via OSRM (gratuit)
class MockRouteRepository implements RouteRepository {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  List<RouteEntity>? _cachedPopularRoutes;

  @override
  Future<List<RouteEntity>> getAllRoutes() async {
    if (_cachedPopularRoutes != null) return _cachedPopularRoutes!;

    final baseRoutes = MockRouteDatasource.routes;
    final updated = <RouteEntity>[];

    for (final route in baseRoutes) {
      try {
        final profile = _osrmProfile(route.mode);
        final url = 'https://router.project-osrm.org/route/v1/$profile/'
            '${route.originCoords.longitude},${route.originCoords.latitude};'
            '${route.destinationCoords.longitude},${route.destinationCoords.latitude}'
            '?overview=false';

        final response = await _dio.get(url);
        final data = response.data as Map<String, dynamic>;
        final routes = data['routes'] as List<dynamic>?;

        if (routes != null && routes.isNotEmpty) {
          final r = routes[0] as Map<String, dynamic>;
          updated.add(route.copyWith(
            distance: (r['distance'] as num).toDouble(),
            duration: _adjustDuration((r['duration'] as num).toInt(), route.mode),
          ));
          continue;
        }
      } catch (_) {
        // OSRM échoué, garder les valeurs mock
      }
      updated.add(route);
    }

    _cachedPopularRoutes = updated;
    return _cachedPopularRoutes!;
  }

  @override
  Future<RouteEntity> calculateRoute({
    required String origin,
    required String destination,
    required TransportMode mode,
  }) async {
    // Géocoder les noms de lieux en coordonnées via Nominatim
    final originCoords = await _geocode(origin);
    final destCoords = await _geocode(destination);

    if (originCoords == null || destCoords == null) {
      return _fallbackRoute(origin, destination, mode, originCoords, destCoords);
    }

    try {
      // Appeler OSRM pour le calcul de route réel
      final profile = _osrmProfile(mode);
      final url = 'https://router.project-osrm.org/route/v1/$profile/'
          '${originCoords.longitude},${originCoords.latitude};'
          '${destCoords.longitude},${destCoords.latitude}'
          '?overview=false';

      final response = await _dio.get(url);
      final data = response.data as Map<String, dynamic>;
      final routes = data['routes'] as List<dynamic>?;

      if (routes != null && routes.isNotEmpty) {
        final route = routes[0] as Map<String, dynamic>;
        final distance = (route['distance'] as num).toDouble();
        final duration = (route['duration'] as num).toInt();

        // Ajuster la durée selon le mode de transport local
        final adjustedDuration = _adjustDuration(duration, mode);

        return RouteEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: '$origin → $destination',
          origin: origin,
          destination: destination,
          originCoords: originCoords,
          destinationCoords: destCoords,
          mode: mode,
          distance: distance,
          duration: adjustedDuration,
        );
      }
    } catch (_) {
      // Fallback si OSRM échoue
    }

    return _fallbackRoute(origin, destination, mode, originCoords, destCoords);
  }

  /// Géocode un nom de lieu en coordonnées via Nominatim (CI en priorité)
  Future<LatLng?> _geocode(String place) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': '$place, Cote d\'Ivoire',
          'format': 'json',
          'limit': '1',
        },
        options: Options(headers: {'User-Agent': 'PistCI/1.0'}),
      );

      final results = response.data as List<dynamic>;
      if (results.isNotEmpty) {
        final first = results[0] as Map<String, dynamic>;
        return LatLng(
          double.parse(first['lat'] as String),
          double.parse(first['lon'] as String),
        );
      }
    } catch (_) {
      // Géocodage échoué
    }
    return null;
  }

  /// Profil OSRM selon le mode (OSRM supporte car, bike, foot)
  String _osrmProfile(TransportMode mode) {
    switch (mode) {
      case TransportMode.car:
      case TransportMode.gbaka:
      case TransportMode.woroWoro:
        return 'driving';
      case TransportMode.bike:
        return 'cycling';
      case TransportMode.walk:
        return 'foot';
      case TransportMode.bateauBus:
        return 'driving'; // Approximation par route
    }
  }

  /// Ajuste la durée selon le mode de transport local
  int _adjustDuration(int drivingDuration, TransportMode mode) {
    switch (mode) {
      case TransportMode.car:
        return drivingDuration;
      case TransportMode.gbaka:
        return (drivingDuration * 1.5).round(); // Plus lent, arrêts fréquents
      case TransportMode.woroWoro:
        return (drivingDuration * 1.3).round(); // Légèrement plus lent
      case TransportMode.bateauBus:
        return (drivingDuration * 0.8).round(); // Pas d'embouteillage
      case TransportMode.bike:
      case TransportMode.walk:
        return drivingDuration; // OSRM calcule déjà correctement
    }
  }

  /// Route de fallback si les APIs ne répondent pas
  RouteEntity _fallbackRoute(
    String origin,
    String destination,
    TransportMode mode,
    LatLng? originCoords,
    LatLng? destCoords,
  ) {
    // Calcul approximatif par distance à vol d'oiseau
    double distance = 5000;
    if (originCoords != null && destCoords != null) {
      const calc = Distance();
      distance = calc.as(LengthUnit.Meter, originCoords, destCoords);
    }

    // Estimation de durée basée sur la vitesse moyenne
    final speedKmh = switch (mode) {
      TransportMode.car => 40.0,
      TransportMode.gbaka => 25.0,
      TransportMode.woroWoro => 30.0,
      TransportMode.bateauBus => 20.0,
      TransportMode.bike => 15.0,
      TransportMode.walk => 5.0,
    };
    final durationSeconds = ((distance / 1000) / speedKmh * 3600).round();

    return RouteEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '$origin → $destination',
      origin: origin,
      destination: destination,
      originCoords: originCoords ?? MockRouteDatasource.routes.first.originCoords,
      destinationCoords: destCoords ?? MockRouteDatasource.routes.first.destinationCoords,
      mode: mode,
      distance: distance,
      duration: durationSeconds,
    );
  }
}
