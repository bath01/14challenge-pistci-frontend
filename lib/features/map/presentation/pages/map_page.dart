import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pistci/core/constants/app_colors.dart';
import 'package:pistci/core/constants/app_defaults.dart';
import 'package:pistci/core/theme/theme_provider.dart';
import 'package:pistci/core/widgets/app_shell.dart';
import 'package:pistci/features/map/domain/entities/map_marker.dart';
import 'package:pistci/features/map/presentation/providers/map_providers.dart';
import 'package:pistci/features/map/presentation/widgets/map_controls.dart';
import 'package:pistci/features/map/presentation/widgets/map_info_bar.dart';
import 'package:pistci/features/map/presentation/widgets/map_sidebar.dart';
import 'package:pistci/features/zones/domain/entities/zone_entity.dart';
import 'package:pistci/features/zones/presentation/providers/zone_providers.dart';

/// Provider global du MapController pour que les contrôles puissent agir sur la carte
final mapControllerProvider = Provider<MapController>((ref) => MapController());

/// Page principale de la carte interactive — responsive
class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).width < kMobileBreakpoint;

    if (isMobile) {
      return const _MobileMapLayout();
    }

    return Row(
      children: [
        const MapSidebar(),
        const Expanded(child: _MapArea()),
      ],
    );
  }
}

/// Layout mobile : carte plein écran (la recherche est dans la navbar)
class _MobileMapLayout extends StatelessWidget {
  const _MobileMapLayout();

  @override
  Widget build(BuildContext context) {
    return const _MapArea();
  }
}

class _MapArea extends ConsumerStatefulWidget {
  const _MapArea();

  @override
  ConsumerState<_MapArea> createState() => _MapAreaState();
}

class _MapAreaState extends ConsumerState<_MapArea> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = ref.read(mapControllerProvider);
  }

  /// Demande la position GPS et déplace la carte
  Future<void> _goToUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      ref.read(mapViewStateProvider.notifier).moveTo(
            LatLng(position.latitude, position.longitude),
            zoom: 15,
          );
    } catch (_) {
      // Géolocalisation non disponible (émulateur, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapViewStateProvider);
    final markersAsync = ref.watch(filteredMarkersProvider);
    final selectedMarker = ref.watch(selectedMarkerProvider);
    final showZones = ref.watch(showZonesProvider);
    final zonesAsync = ref.watch(zonesProvider);
    final isMobile = MediaQuery.sizeOf(context).width < kMobileBreakpoint;

    // Synchroniser le MapController avec le state Riverpod
    ref.listen(mapViewStateProvider, (prev, next) {
      if (prev == null) return;
      if (prev.zoom != next.zoom || prev.center != next.center) {
        _mapController.move(next.center, next.zoom);
      }
    });

    // Quand le tracking s'active, obtenir la position GPS
    ref.listen(mapViewStateProvider.select((s) => s.isTracking), (prev, next) {
      if (next) _goToUserLocation();
    });

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: mapState.center,
            initialZoom: mapState.zoom,
            minZoom: AppDefaults.minZoom,
            maxZoom: AppDefaults.maxZoom,
            backgroundColor: AppColors.darkBg,
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) {
                ref.read(mapViewStateProvider.notifier).setZoom(position.zoom);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: ref.watch(lightMapModeProvider)
                  ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
                  : (AppDefaults.tileUrls[mapState.mapType.name] ?? AppDefaults.osmTileUrl),
              userAgentPackageName: 'com.pistci',
              tileSize: ref.watch(lightMapModeProvider) ? 512 : 256,
              maxZoom: ref.watch(lightMapModeProvider) ? 16 : 19,
            ),
            if (showZones)
              zonesAsync.maybeWhen(
                data: (zones) => PolygonLayer(
                  polygons: zones.map<Polygon<Object>>(_buildPolygon).toList(),
                ),
                orElse: () => const PolygonLayer(polygons: <Polygon<Object>>[]),
              ),
            markersAsync.maybeWhen(
              data: (markers) => MarkerLayer(
                markers: markers.map((m) => _buildMarker(m, selectedMarker)).toList(),
              ),
              orElse: () => const MarkerLayer(markers: []),
            ),
          ],
        ),

        const MapControls(),

        if (!isMobile) const MapInfoBar(),

        if (selectedMarker != null) _MarkerPopup(marker: selectedMarker, isMobile: isMobile),
      ],
    );
  }

  Polygon<Object> _buildPolygon(ZoneEntity zone) {
    return Polygon(
      points: zone.points,
      color: zone.fillColor,
      borderColor: zone.strokeColor,
      borderStrokeWidth: zone.strokeWidth,
    );
  }

  Marker _buildMarker(MapMarker marker, MapMarker? selected) {
    final isSelected = selected?.id == marker.id;
    return Marker(
      point: marker.position,
      width: isSelected ? 48 : 40,
      height: isSelected ? 48 : 40,
      child: GestureDetector(
        onTap: () {
          ref.read(selectedMarkerProvider.notifier).state = isSelected ? null : marker;
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.ciOrange : AppColors.card,
            borderRadius: BorderRadius.circular(isSelected ? 14 : 10),
            border: Border.all(
              color: isSelected ? AppColors.ciOrange : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: AppColors.ciOrange.withAlpha(60), blurRadius: 12)]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(marker.category.icon, style: TextStyle(fontSize: isSelected ? 20 : 16)),
        ),
      ),
    );
  }
}

class _MarkerPopup extends StatelessWidget {
  final MapMarker marker;
  final bool isMobile;

  const _MarkerPopup({required this.marker, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: isMobile ? 16 : 80,
      left: 16,
      right: isMobile ? 16 : null,
      child: Container(
        width: isMobile ? null : 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(80), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(marker.category.icon, style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        marker.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.ciOrange.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          marker.category.label,
                          style: const TextStyle(fontSize: 9, color: AppColors.ciOrange, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              marker.description,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
            ),
            // Téléphone (urgences/services)
            if (marker.phone != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone, size: 14, color: AppColors.ciGreen),
                  const SizedBox(width: 6),
                  Text(marker.phone!, style: const TextStyle(fontSize: 12, color: AppColors.ciGreen, fontWeight: FontWeight.w600)),
                  if (marker.isOpen24h) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.ciGreen.withAlpha(20),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('24h', style: TextStyle(fontSize: 9, color: AppColors.ciGreen, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '${marker.latitude.toStringAsFixed(4)}° N, ${marker.longitude.abs().toStringAsFixed(4)}° W',
              style: const TextStyle(fontSize: 10, color: AppColors.textDim),
            ),
            const SizedBox(height: 10),
            // Boutons d'action
            Row(
              children: [
                // Partager (WhatsApp)
                _ActionButton(
                  icon: Icons.share,
                  label: 'Partager',
                  color: AppColors.ciGreen,
                  onTap: () {
                    final text = '📍 ${marker.title}\n'
                        '${marker.description}\n'
                        'Position: ${marker.latitude.toStringAsFixed(4)}°N, ${marker.longitude.abs().toStringAsFixed(4)}°W\n'
                        'Via PistCI 🇨🇮';
                    Share.share(text);
                  },
                ),
                const SizedBox(width: 8),
                // Signaler
                _ActionButton(
                  icon: Icons.flag_outlined,
                  label: 'Signaler',
                  color: AppColors.ciOrange,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Merci ! Ton signalement sera examine.'),
                        backgroundColor: AppColors.ciOrange,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
