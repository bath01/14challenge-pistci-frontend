import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pistci/core/constants/app_colors.dart';
import 'package:pistci/features/zones/domain/entities/zone_entity.dart';

/// Zones prédéfinies réalistes d'Abidjan
class MockZoneDatasource {
  static final List<ZoneEntity> zones = [
    // === QUARTIERS ===
    ZoneEntity(
      id: 'q1', name: 'Commune du Plateau', type: ZoneType.quartier,
      description: 'Centre administratif et des affaires. Siege de la plupart des ministeres et banques.',
      isOfficial: true,
      fillColor: AppColors.ciOrange.withAlpha(40),
      strokeColor: AppColors.ciOrange,
      points: [
        LatLng(5.3250, -4.0250), LatLng(5.3250, -4.0100),
        LatLng(5.3180, -4.0050), LatLng(5.3120, -4.0100),
        LatLng(5.3120, -4.0200), LatLng(5.3180, -4.0280),
      ],
    ),
    ZoneEntity(
      id: 'q2', name: 'Commune de Cocody', type: ZoneType.quartier,
      description: 'Quartier residentiel haut standing. Universites, ambassades, Hotel Ivoire.',
      isOfficial: true,
      fillColor: AppColors.ciGreen.withAlpha(40),
      strokeColor: AppColors.ciGreen,
      points: [
        LatLng(5.3500, -3.9950), LatLng(5.3500, -3.9650),
        LatLng(5.3400, -3.9500), LatLng(5.3250, -3.9500),
        LatLng(5.3200, -3.9650), LatLng(5.3200, -3.9800),
        LatLng(5.3300, -3.9950), LatLng(5.3400, -4.0000),
      ],
    ),
    ZoneEntity(
      id: 'q3', name: 'Commune de Yopougon', type: ZoneType.quartier,
      description: 'Plus grande commune d\'Abidjan. Quartier populaire, zone industrielle.',
      isOfficial: true,
      fillColor: const Color(0xFF9B59B6).withAlpha(40),
      strokeColor: const Color(0xFF9B59B6),
      points: [
        LatLng(5.3700, -4.0900), LatLng(5.3700, -4.0500),
        LatLng(5.3500, -4.0400), LatLng(5.3300, -4.0500),
        LatLng(5.3300, -4.0800), LatLng(5.3500, -4.0950),
      ],
    ),
    ZoneEntity(
      id: 'q4', name: 'Commune d\'Abobo', type: ZoneType.quartier,
      description: 'Commune la plus peuplee. Quartier populaire au nord d\'Abidjan.',
      isOfficial: true,
      fillColor: const Color(0xFFE74C3C).withAlpha(40),
      strokeColor: const Color(0xFFE74C3C),
      points: [
        LatLng(5.4200, -4.0400), LatLng(5.4200, -4.0100),
        LatLng(5.3900, -4.0000), LatLng(5.3700, -4.0100),
        LatLng(5.3700, -4.0350), LatLng(5.3900, -4.0450),
      ],
    ),
    ZoneEntity(
      id: 'q5', name: 'Commune de Treichville', type: ZoneType.quartier,
      description: 'Quartier anime, port autonome, gare routiere. Vie nocturne.',
      isOfficial: true,
      fillColor: const Color(0xFFF39C12).withAlpha(40),
      strokeColor: const Color(0xFFF39C12),
      points: [
        LatLng(5.3100, -4.0200), LatLng(5.3100, -4.0000),
        LatLng(5.2950, -3.9950), LatLng(5.2900, -4.0050),
        LatLng(5.2900, -4.0200), LatLng(5.3000, -4.0250),
      ],
    ),
    ZoneEntity(
      id: 'q6', name: 'Commune de Marcory', type: ZoneType.quartier,
      description: 'Zone 4, quartier residentiel et commercial. Restaurants, maquis.',
      isOfficial: true,
      fillColor: const Color(0xFF1ABC9C).withAlpha(40),
      strokeColor: const Color(0xFF1ABC9C),
      points: [
        LatLng(5.3100, -3.9950), LatLng(5.3100, -3.9750),
        LatLng(5.2950, -3.9700), LatLng(5.2850, -3.9800),
        LatLng(5.2900, -3.9950),
      ],
    ),

    // === TRANSPORT ===
    ZoneEntity(
      id: 't1', name: 'Zone Bateau-bus Lagune', type: ZoneType.transport,
      description: 'Desserte lagunaire reliant Plateau, Cocody, Abobo-Doume, Yopougon.',
      transportInfo: 'Lignes : Plateau-Abobo-Doume, Plateau-Yopougon, Cocody-Plateau',
      isOfficial: true,
      fillColor: const Color(0xFF3498DB).withAlpha(30),
      strokeColor: const Color(0xFF3498DB),
      points: [
        LatLng(5.3400, -4.0600), LatLng(5.3400, -3.9600),
        LatLng(5.3050, -3.9600), LatLng(5.3050, -4.0600),
      ],
    ),
    ZoneEntity(
      id: 't2', name: 'Zone Gbaka Adjame-Yopougon', type: ZoneType.transport,
      description: 'Axe principal des Gbaka entre Adjame et Yopougon. Tarif 200-350 FCFA.',
      transportInfo: 'Gbaka 200-350 FCFA — Frequence : toutes les 2-5 min aux heures de pointe',
      isOfficial: true,
      fillColor: AppColors.ciGreen.withAlpha(30),
      strokeColor: AppColors.ciGreen,
      points: [
        LatLng(5.3550, -4.0700), LatLng(5.3550, -4.0250),
        LatLng(5.3400, -4.0200), LatLng(5.3400, -4.0650),
      ],
    ),

    // === COMMERCIAL ===
    ZoneEntity(
      id: 'c1', name: 'Grand Marche d\'Adjame', type: ZoneType.commercial,
      description: 'Plus grand marche d\'Abidjan. Fruits, legumes, vivriers, textile.',
      isOfficial: true,
      fillColor: const Color(0xFFE67E22).withAlpha(40),
      strokeColor: const Color(0xFFE67E22),
      points: [
        LatLng(5.3480, -4.0310), LatLng(5.3480, -4.0250),
        LatLng(5.3420, -4.0240), LatLng(5.3420, -4.0300),
      ],
    ),
    ZoneEntity(
      id: 'c2', name: 'Zone 4 Marcory', type: ZoneType.commercial,
      description: 'Zone commerciale et de restauration. Maquis, restaurants, boutiques.',
      isOfficial: true,
      fillColor: const Color(0xFFE91E63).withAlpha(40),
      strokeColor: const Color(0xFFE91E63),
      points: [
        LatLng(5.3050, -3.9900), LatLng(5.3050, -3.9780),
        LatLng(5.2970, -3.9760), LatLng(5.2970, -3.9880),
      ],
    ),
  ];
}
