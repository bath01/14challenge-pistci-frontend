import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:pistci/core/constants/app_defaults.dart';

/// Types de carte disponibles
enum MapType { standard, satellite, terrain }

/// Etat global de la carte
class MapViewState extends Equatable {
  final LatLng center;
  final double zoom;
  final MapType mapType;
  final bool isTracking;

  const MapViewState({
    required this.center,
    this.zoom = AppDefaults.defaultZoom,
    this.mapType = MapType.standard,
    this.isTracking = false,
  });

  factory MapViewState.initial() => MapViewState(
        center: AppDefaults.defaultCenter,
      );

  MapViewState copyWith({
    LatLng? center,
    double? zoom,
    MapType? mapType,
    bool? isTracking,
  }) {
    return MapViewState(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      mapType: mapType ?? this.mapType,
      isTracking: isTracking ?? this.isTracking,
    );
  }

  @override
  List<Object?> get props => [center, zoom, mapType, isTracking];
}
