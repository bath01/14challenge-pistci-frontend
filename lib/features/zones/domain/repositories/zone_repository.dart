import 'package:pistci/features/zones/domain/entities/zone_entity.dart';

/// Contrat pour l'accès aux données des zones
abstract class ZoneRepository {
  Future<List<ZoneEntity>> getAllZones();
  Future<void> createZone(ZoneEntity zone);
  Future<void> updateZone(ZoneEntity zone);
  Future<void> deleteZone(String id);
}
