import 'package:pistci/features/map/domain/entities/map_marker.dart';

/// Données fictives de lieux ivoiriens enrichies
class MockMarkerDatasource {
  static final List<MapMarker> markers = [
    // === QUARTIERS ===
    const MapMarker(
      id: '1', title: 'Plateau', description: "Centre administratif d'Abidjan",
      latitude: 5.3197, longitude: -4.0167, category: MarkerCategory.quartier,
    ),

    // === MONUMENTS ===
    const MapMarker(
      id: '2', title: 'Cathedrale Saint-Paul', description: 'Cathedrale emblematique du Plateau',
      latitude: 5.3220, longitude: -4.0195, category: MarkerCategory.monument,
    ),
    const MapMarker(
      id: '7', title: 'Basilique Notre-Dame de la Paix',
      description: 'Yamoussoukro - Plus grande basilique du monde',
      latitude: 6.8128, longitude: -5.2897, category: MarkerCategory.monument,
    ),

    // === COMMERCES ===
    const MapMarker(
      id: '3', title: "Marche d'Adjame", description: "Plus grand marche d'Abidjan",
      latitude: 5.3450, longitude: -4.0280, category: MarkerCategory.commerce,
    ),
    const MapMarker(
      id: '12', title: 'Marche de Treichville', description: 'Grand marche populaire',
      latitude: 5.2990, longitude: -4.0060, category: MarkerCategory.commerce,
    ),

    // === TRANSPORTS ===
    const MapMarker(
      id: '4', title: 'Aeroport FHB',
      description: 'Aeroport international Felix Houphouet-Boigny',
      latitude: 5.2614, longitude: -3.9262, category: MarkerCategory.transport,
    ),
    const MapMarker(
      id: '8', title: 'Pont HKB', description: 'Pont Henri Konan Bedie reliant Marcory a Cocody',
      latitude: 5.3110, longitude: -3.9850, category: MarkerCategory.transport,
    ),
    const MapMarker(
      id: '10', title: 'Gare de Treichville', description: 'Gare routiere principale',
      latitude: 5.3050, longitude: -4.0100, category: MarkerCategory.transport,
    ),
    const MapMarker(
      id: '20', title: 'Gare Gbaka Adjame', description: 'Terminus des Gbaka vers Yopougon et Abobo',
      latitude: 5.3430, longitude: -4.0250, category: MarkerCategory.transport,
    ),
    const MapMarker(
      id: '21', title: 'Gare Bateau-bus Plateau',
      description: 'Embarcadere lagunaire du Plateau vers Abobo-Doume',
      latitude: 5.3150, longitude: -4.0120, category: MarkerCategory.transport,
    ),

    // === HOTELS ===
    const MapMarker(
      id: '5', title: 'Hotel Ivoire', description: 'Hotel historique de Cocody',
      latitude: 5.3310, longitude: -3.9780, category: MarkerCategory.hotel,
    ),

    // === EDUCATION ===
    const MapMarker(
      id: '6', title: 'Universite FHB',
      description: 'Universite Felix Houphouet-Boigny de Cocody',
      latitude: 5.3445, longitude: -3.9880, category: MarkerCategory.education,
    ),

    // === LOISIRS ===
    const MapMarker(
      id: '9', title: "Zoo d'Abidjan", description: 'Parc zoologique national',
      latitude: 5.3350, longitude: -3.9700, category: MarkerCategory.loisir,
    ),
    const MapMarker(
      id: '11', title: 'Plage de Bassam', description: 'Station balneaire historique',
      latitude: 5.1950, longitude: -3.7400, category: MarkerCategory.loisir,
    ),

    // === URGENCES ===
    const MapMarker(
      id: '30', title: 'CHU de Cocody', description: 'Centre Hospitalier Universitaire',
      latitude: 5.3400, longitude: -3.9830, category: MarkerCategory.urgence,
      phone: '22 44 91 00', isOpen24h: true,
    ),
    const MapMarker(
      id: '31', title: 'CHU de Treichville', description: 'Urgences et maternite',
      latitude: 5.3010, longitude: -4.0060, category: MarkerCategory.urgence,
      phone: '21 24 91 00', isOpen24h: true,
    ),
    const MapMarker(
      id: '32', title: 'Pharmacie de Garde Plateau',
      description: 'Pharmacie ouverte 24h — appeler le 185 pour confirmer',
      latitude: 5.3200, longitude: -4.0180, category: MarkerCategory.urgence,
      phone: '185', isOpen24h: true,
    ),
    const MapMarker(
      id: '33', title: 'Commissariat du Plateau',
      description: 'Police nationale — urgences 110 / 170',
      latitude: 5.3210, longitude: -4.0155, category: MarkerCategory.urgence,
      phone: '110',
    ),
    const MapMarker(
      id: '34', title: 'Pompiers Abidjan',
      description: 'Caserne principale — appeler le 180',
      latitude: 5.3280, longitude: -4.0050, category: MarkerCategory.urgence,
      phone: '180', isOpen24h: true,
    ),

    // === SERVICES ===
    const MapMarker(
      id: '40', title: 'Orange Money Cocody',
      description: 'Point de retrait/depot Orange Money',
      latitude: 5.3380, longitude: -3.9820, category: MarkerCategory.service,
    ),
    const MapMarker(
      id: '41', title: 'MTN Money Adjame',
      description: 'Point de retrait/depot MTN Mobile Money',
      latitude: 5.3440, longitude: -4.0260, category: MarkerCategory.service,
    ),
    const MapMarker(
      id: '42', title: 'Station Total Cocody',
      description: 'Station-service avec boutique',
      latitude: 5.3350, longitude: -3.9900, category: MarkerCategory.service,
    ),
    const MapMarker(
      id: '43', title: 'BICICI Plateau',
      description: 'Agence bancaire — DAB disponible',
      latitude: 5.3190, longitude: -4.0175, category: MarkerCategory.service,
    ),
  ];
}
