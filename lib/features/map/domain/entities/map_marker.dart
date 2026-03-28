import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pistci/core/constants/app_colors.dart';

/// Catégories de markers — incluant urgences et services ivoiriens
enum MarkerCategory {
  monument,
  commerce,
  transport,
  hotel,
  loisir,
  education,
  quartier,
  urgence,
  service,
  custom;

  String get label {
    switch (this) {
      case MarkerCategory.monument:
        return 'Monument';
      case MarkerCategory.commerce:
        return 'Commerce';
      case MarkerCategory.transport:
        return 'Transport';
      case MarkerCategory.hotel:
        return 'Hotel';
      case MarkerCategory.loisir:
        return 'Loisir';
      case MarkerCategory.education:
        return 'Education';
      case MarkerCategory.quartier:
        return 'Quartier';
      case MarkerCategory.urgence:
        return 'Urgence';
      case MarkerCategory.service:
        return 'Service';
      case MarkerCategory.custom:
        return 'Autre';
    }
  }

  String get icon {
    switch (this) {
      case MarkerCategory.monument:
        return '🏛️';
      case MarkerCategory.commerce:
        return '🏪';
      case MarkerCategory.transport:
        return '🚌';
      case MarkerCategory.hotel:
        return '🏨';
      case MarkerCategory.loisir:
        return '🎭';
      case MarkerCategory.education:
        return '🎓';
      case MarkerCategory.quartier:
        return '🏘️';
      case MarkerCategory.urgence:
        return '🚨';
      case MarkerCategory.service:
        return '💰';
      case MarkerCategory.custom:
        return '📍';
    }
  }

  Color get color {
    switch (this) {
      case MarkerCategory.monument:
        return AppColors.ciOrange;
      case MarkerCategory.commerce:
        return AppColors.categoryCommerce;
      case MarkerCategory.transport:
        return AppColors.ciGreen;
      case MarkerCategory.hotel:
        return AppColors.categoryHotel;
      case MarkerCategory.loisir:
        return AppColors.categoryLoisir;
      case MarkerCategory.education:
        return AppColors.categoryEducation;
      case MarkerCategory.quartier:
        return AppColors.categoryQuartier;
      case MarkerCategory.urgence:
        return const Color(0xFFEF4444);
      case MarkerCategory.service:
        return const Color(0xFFF59E0B);
      case MarkerCategory.custom:
        return AppColors.textSecondary;
    }
  }
}

/// Représente un point d'intérêt sur la carte
class MapMarker extends Equatable {
  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final String description;
  final MarkerCategory category;
  final bool isVisible;
  final String? phone;
  final bool isOpen24h;

  const MapMarker({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    this.description = '',
    this.category = MarkerCategory.custom,
    this.isVisible = true,
    this.phone,
    this.isOpen24h = false,
  });

  LatLng get position => LatLng(latitude, longitude);

  MapMarker copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? title,
    String? description,
    MarkerCategory? category,
    bool? isVisible,
    String? phone,
    bool? isOpen24h,
  }) {
    return MapMarker(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isVisible: isVisible ?? this.isVisible,
      phone: phone ?? this.phone,
      isOpen24h: isOpen24h ?? this.isOpen24h,
    );
  }

  @override
  List<Object?> get props => [id, latitude, longitude, title, description, category, isVisible];
}
