import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pistci/core/constants/app_colors.dart';

/// Mode de transport — inclut les transports locaux ivoiriens
enum TransportMode {
  car,
  bike,
  walk,
  gbaka,
  woroWoro,
  bateauBus;

  String get label {
    switch (this) {
      case TransportMode.car:
        return 'Voiture';
      case TransportMode.bike:
        return 'Velo';
      case TransportMode.walk:
        return 'A pied';
      case TransportMode.gbaka:
        return 'Gbaka';
      case TransportMode.woroWoro:
        return 'Woro-woro';
      case TransportMode.bateauBus:
        return 'Bateau-bus';
    }
  }

  String get icon {
    switch (this) {
      case TransportMode.car:
        return '🚗';
      case TransportMode.bike:
        return '🚲';
      case TransportMode.walk:
        return '🚶';
      case TransportMode.gbaka:
        return '🚐';
      case TransportMode.woroWoro:
        return '🚕';
      case TransportMode.bateauBus:
        return '⛴️';
    }
  }

  IconData get materialIcon {
    switch (this) {
      case TransportMode.car:
        return Icons.directions_car;
      case TransportMode.bike:
        return Icons.directions_bike;
      case TransportMode.walk:
        return Icons.directions_walk;
      case TransportMode.gbaka:
        return Icons.directions_bus;
      case TransportMode.woroWoro:
        return Icons.local_taxi;
      case TransportMode.bateauBus:
        return Icons.directions_boat;
    }
  }

  /// Tarif moyen par km en FCFA
  int get costPerKmFCFA {
    switch (this) {
      case TransportMode.car:
        return 150;
      case TransportMode.bike:
        return 0;
      case TransportMode.walk:
        return 0;
      case TransportMode.gbaka:
        return 25;
      case TransportMode.woroWoro:
        return 50;
      case TransportMode.bateauBus:
        return 75;
    }
  }

  /// Tarif de base en FCFA (prise en charge)
  int get baseFareFCFA {
    switch (this) {
      case TransportMode.car:
        return 0;
      case TransportMode.bike:
        return 0;
      case TransportMode.walk:
        return 0;
      case TransportMode.gbaka:
        return 200;
      case TransportMode.woroWoro:
        return 250;
      case TransportMode.bateauBus:
        return 300;
    }
  }
}

/// Représente un itinéraire calculé
class RouteEntity extends Equatable {
  final String id;
  final String name;
  final String origin;
  final String destination;
  final LatLng originCoords;
  final LatLng destinationCoords;
  final List<LatLng> waypoints;
  final TransportMode mode;
  final List<LatLng> polyline;
  final double distance; // en mètres
  final int duration; // en secondes
  final Color color;

  const RouteEntity({
    required this.id,
    required this.name,
    required this.origin,
    required this.destination,
    required this.originCoords,
    required this.destinationCoords,
    this.waypoints = const [],
    this.mode = TransportMode.car,
    this.polyline = const [],
    this.distance = 0,
    this.duration = 0,
    this.color = AppColors.ciOrange,
  });

  /// Estimation du coût en FCFA
  int get estimatedCostFCFA {
    final distanceKm = distance / 1000;
    return mode.baseFareFCFA + (distanceKm * mode.costPerKmFCFA).round();
  }

  /// Coût formaté
  String get formattedCost {
    final cost = estimatedCostFCFA;
    if (cost == 0) return 'Gratuit';
    if (cost >= 1000) {
      return '${(cost / 1000).toStringAsFixed(cost % 1000 == 0 ? 0 : 1)}k FCFA';
    }
    return '$cost FCFA';
  }

  RouteEntity copyWith({
    String? id,
    String? name,
    String? origin,
    String? destination,
    LatLng? originCoords,
    LatLng? destinationCoords,
    List<LatLng>? waypoints,
    TransportMode? mode,
    List<LatLng>? polyline,
    double? distance,
    int? duration,
    Color? color,
  }) {
    return RouteEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      originCoords: originCoords ?? this.originCoords,
      destinationCoords: destinationCoords ?? this.destinationCoords,
      waypoints: waypoints ?? this.waypoints,
      mode: mode ?? this.mode,
      polyline: polyline ?? this.polyline,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [id, origin, destination, mode, distance, duration];
}
