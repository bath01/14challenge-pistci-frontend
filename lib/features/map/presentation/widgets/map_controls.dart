import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pistci/core/constants/app_colors.dart';
import 'package:pistci/features/map/domain/entities/map_state.dart';
import 'package:pistci/features/map/presentation/providers/map_providers.dart';
import 'package:pistci/core/theme/theme_provider.dart';
import 'package:pistci/features/zones/presentation/providers/zone_providers.dart';

/// Contrôles flottants à droite de la carte (type, zoom, géolocalisation, zones)
class MapControls extends ConsumerWidget {
  const MapControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapViewStateProvider);
    final isTracking = mapState.isTracking;
    final showZones = ref.watch(showZonesProvider);

    return Positioned(
      right: 16,
      top: 16,
      child: Column(
        children: [
          // Sélecteur de type de carte
          _ControlGroup(
            children: [
              ...MapType.values.map((type) => _ControlButton(
                    label: type.name,
                    isActive: mapState.mapType == type,
                    onTap: () => ref.read(mapViewStateProvider.notifier).setMapType(type),
                  )),
            ],
          ),
          const SizedBox(height: 8),

          // Zoom
          _ControlGroup(
            children: [
              _ControlButton(
                icon: Icons.add,
                onTap: () => ref.read(mapViewStateProvider.notifier).zoomIn(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '${mapState.zoom.toInt()}',
                  style: const TextStyle(fontSize: 10, color: AppColors.textDim),
                  textAlign: TextAlign.center,
                ),
              ),
              _ControlButton(
                icon: Icons.remove,
                onTap: () => ref.read(mapViewStateProvider.notifier).zoomOut(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Géolocalisation
          _SingleControl(
            icon: Icons.my_location,
            isActive: isTracking,
            activeColor: AppColors.ciOrange,
            onTap: () => ref.read(mapViewStateProvider.notifier).toggleTracking(),
          ),
          const SizedBox(height: 8),

          // Zones
          _SingleControl(
            icon: Icons.hexagon_outlined,
            isActive: showZones,
            activeColor: AppColors.ciGreen,
            onTap: () => ref.read(showZonesProvider.notifier).state = !showZones,
          ),
          const SizedBox(height: 8),

          // Mode carte légère (économie données)
          _SingleControl(
            icon: Icons.data_saver_on,
            isActive: ref.watch(lightMapModeProvider),
            activeColor: AppColors.ciOrange,
            onTap: () {
              final current = ref.read(lightMapModeProvider);
              ref.read(lightMapModeProvider.notifier).state = !current;
            },
          ),
        ],
      ),
    );
  }
}

class _ControlGroup extends StatelessWidget {
  final List<Widget> children;
  const _ControlGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBg.withAlpha(230),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ControlButton({
    this.label,
    this.icon,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.ciOrange.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: icon != null
            ? Icon(icon, size: 18, color: isActive ? AppColors.ciOrange : AppColors.textPrimary)
            : Text(
                label ?? '',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.ciOrange : AppColors.textSecondary,
                ),
              ),
      ),
    );
  }
}

class _SingleControl extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _SingleControl({
    required this.icon,
    this.isActive = false,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withAlpha(30) : AppColors.darkBg.withAlpha(230),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 18, color: isActive ? activeColor : AppColors.textSecondary),
      ),
    );
  }
}
