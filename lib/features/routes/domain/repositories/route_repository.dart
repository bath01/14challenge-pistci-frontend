import 'package:pistci/features/routes/domain/entities/route_entity.dart';

/// Contrat pour l'accès aux données des itinéraires
abstract class RouteRepository {
  Future<List<RouteEntity>> getAllRoutes();
  Future<RouteEntity> calculateRoute({
    required String origin,
    required String destination,
    required TransportMode mode,
  });
}
