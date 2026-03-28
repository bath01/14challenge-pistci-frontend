import 'package:pistci/features/zones/data/datasources/mock_zone_datasource.dart';
import 'package:pistci/features/zones/domain/entities/zone_entity.dart';
import 'package:pistci/features/zones/domain/repositories/zone_repository.dart';

/// Implémentation locale avec données mock
class MockZoneRepository implements ZoneRepository {
  final List<ZoneEntity> _zones = List.from(MockZoneDatasource.zones);

  @override
  Future<List<ZoneEntity>> getAllZones() async => _zones;

  @override
  Future<void> createZone(ZoneEntity zone) async {
    _zones.add(zone);
  }

  @override
  Future<void> updateZone(ZoneEntity zone) async {
    final index = _zones.indexWhere((z) => z.id == zone.id);
    if (index != -1) _zones[index] = zone;
  }

  @override
  Future<void> deleteZone(String id) async {
    _zones.removeWhere((z) => z.id == id);
  }
}
