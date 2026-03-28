import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pistci/features/routes/data/repositories/mock_route_repository.dart';
import 'package:pistci/features/routes/domain/entities/route_entity.dart';
import 'package:pistci/features/routes/domain/repositories/route_repository.dart';

/// Repository des itinéraires
final routeRepositoryProvider = Provider<RouteRepository>(
  (_) => MockRouteRepository(),
);

/// Liste des itinéraires populaires
final routesProvider = FutureProvider<List<RouteEntity>>((ref) async {
  final repo = ref.watch(routeRepositoryProvider);
  return repo.getAllRoutes();
});

/// Itinéraire sélectionné
final selectedRouteProvider = StateProvider<RouteEntity?>((ref) => null);

/// Mode de transport sélectionné pour le formulaire
final routeModeProvider = StateProvider<TransportMode>((ref) => TransportMode.car);

/// Texte du point de départ
final routeOriginTextProvider = StateProvider<String>((ref) => '');

/// Texte de la destination
final routeDestinationTextProvider = StateProvider<String>((ref) => '');

/// Résultat du calcul d'itinéraire (null = pas encore calculé)
final calculatedRouteProvider = StateProvider<RouteEntity?>((ref) => null);

/// Indique si un calcul est en cours
final isCalculatingRouteProvider = StateProvider<bool>((ref) => false);
