import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pistci/core/constants/app_colors.dart';
import 'package:pistci/features/routes/domain/entities/route_entity.dart';

/// Itinéraires fictifs de la maquette
class MockRouteDatasource {
  static final List<RouteEntity> routes = [
    RouteEntity(
      id: '1',
      name: 'Plateau → Cocody',
      origin: 'Plateau',
      destination: 'Hotel Ivoire, Cocody',
      originCoords: LatLng(5.3197, -4.0167),
      destinationCoords: LatLng(5.3310, -3.9780),
      mode: TransportMode.car,
      distance: 8200,
      duration: 1500,
      color: AppColors.ciOrange,
    ),
    RouteEntity(
      id: '2',
      name: 'Adjame → Treichville',
      origin: "Marche d'Adjame",
      destination: 'Gare de Treichville',
      originCoords: LatLng(5.3450, -4.0280),
      destinationCoords: LatLng(5.3050, -4.0100),
      mode: TransportMode.car,
      distance: 6800,
      duration: 1200,
      color: AppColors.ciGreen,
    ),
    RouteEntity(
      id: '3',
      name: 'Abidjan → Bassam',
      origin: 'Aeroport FHB',
      destination: 'Plage de Bassam',
      originCoords: LatLng(5.2614, -3.9262),
      destinationCoords: LatLng(5.1950, -3.7400),
      mode: TransportMode.car,
      distance: 32000,
      duration: 2700,
      color: const Color(0xFF3498DB),
    ),
  ];
}
