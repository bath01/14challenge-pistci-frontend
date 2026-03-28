import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pistci/core/constants/app_colors.dart';

/// Types de zones adaptés au contexte ivoirien
enum ZoneType {
  quartier,
  transport,
  commercial,
  custom;

  String get label {
    switch (this) {
      case ZoneType.quartier:
        return 'Quartier';
      case ZoneType.transport:
        return 'Transport';
      case ZoneType.commercial:
        return 'Commerce';
      case ZoneType.custom:
        return 'Personnelle';
    }
  }

  String get icon {
    switch (this) {
      case ZoneType.quartier:
        return '🏘️';
      case ZoneType.transport:
        return '🚐';
      case ZoneType.commercial:
        return '🏪';
      case ZoneType.custom:
        return '📌';
    }
  }

  Color get defaultColor {
    switch (this) {
      case ZoneType.quartier:
        return AppColors.ciOrange;
      case ZoneType.transport:
        return AppColors.ciGreen;
      case ZoneType.commercial:
        return const Color(0xFF3498DB);
      case ZoneType.custom:
        return const Color(0xFFA855F7);
    }
  }
}

/// Représente une zone polygonale sur la carte
class ZoneEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final ZoneType type;
  final List<LatLng> points;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  final bool isOfficial;
  final String? transportInfo; // Lignes de Gbaka, etc.

  const ZoneEntity({
    required this.id,
    required this.name,
    this.description = '',
    this.type = ZoneType.custom,
    required this.points,
    required this.fillColor,
    required this.strokeColor,
    this.strokeWidth = 2.0,
    this.isOfficial = false,
    this.transportInfo,
  });

  int get pointCount => points.length;

  ZoneEntity copyWith({
    String? id,
    String? name,
    String? description,
    ZoneType? type,
    List<LatLng>? points,
    Color? fillColor,
    Color? strokeColor,
    double? strokeWidth,
    bool? isOfficial,
    String? transportInfo,
  }) {
    return ZoneEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      points: points ?? this.points,
      fillColor: fillColor ?? this.fillColor,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isOfficial: isOfficial ?? this.isOfficial,
      transportInfo: transportInfo ?? this.transportInfo,
    );
  }

  @override
  List<Object?> get props => [id, name, type, points, isOfficial];
}
