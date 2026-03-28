import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pistci/features/zones/data/repositories/mock_zone_repository.dart';
import 'package:pistci/features/zones/domain/entities/zone_entity.dart';
import 'package:pistci/features/zones/domain/repositories/zone_repository.dart';

/// Repository des zones
final zoneRepositoryProvider = Provider<ZoneRepository>(
  (_) => MockZoneRepository(),
);

/// Liste de toutes les zones
final zonesProvider = FutureProvider<List<ZoneEntity>>((ref) async {
  final repo = ref.watch(zoneRepositoryProvider);
  return repo.getAllZones();
});

/// Afficher/masquer les zones sur la carte
final showZonesProvider = StateProvider<bool>((ref) => true);

/// Filtre par type de zone (null = toutes)
final selectedZoneTypeFilter = StateProvider<ZoneType?>((ref) => null);

/// Filtre spécial "Mes zones" (zones non officielles)
final showOnlyMyZonesProvider = StateProvider<bool>((ref) => false);

/// Zones filtrées selon le type sélectionné
final filteredZonesProvider = Provider<AsyncValue<List<ZoneEntity>>>((ref) {
  final zonesAsync = ref.watch(zonesProvider);
  final typeFilter = ref.watch(selectedZoneTypeFilter);
  final onlyMine = ref.watch(showOnlyMyZonesProvider);

  return zonesAsync.whenData((zones) {
    var filtered = zones.toList();
    if (onlyMine) {
      filtered = filtered.where((z) => !z.isOfficial).toList();
    } else if (typeFilter != null) {
      filtered = filtered.where((z) => z.type == typeFilter).toList();
    }
    return filtered;
  });
});
