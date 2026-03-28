import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pistci/core/constants/app_colors.dart';
import 'package:pistci/features/map/presentation/providers/map_providers.dart';

/// Barre d'informations en bas de la carte
class MapInfoBar extends ConsumerWidget {
  const MapInfoBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapViewStateProvider);
    final markersAsync = ref.watch(filteredMarkersProvider);

    final markerCount = markersAsync.maybeWhen(
      data: (list) => list.length,
      orElse: () => 0,
    );

    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Infos gauche
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.darkBg.withAlpha(230),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _InfoItem(label: 'Zoom', value: '${mapState.zoom.toInt()}', color: AppColors.ciOrange),
                _divider(),
                _InfoItem(
                  label: 'Type',
                  value: mapState.mapType.name[0].toUpperCase() + mapState.mapType.name.substring(1),
                  color: AppColors.ciGreen,
                ),
                _divider(),
                _InfoItem(label: 'Markers', value: '$markerCount', color: AppColors.textPrimary),
              ],
            ),
          ),

          // Coordonnées
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.darkBg.withAlpha(230),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              "Abidjan, Cote d'Ivoire — 5.3167° N, 4.0333° W",
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text('|', style: TextStyle(color: AppColors.border)),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          TextSpan(
            text: value,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
