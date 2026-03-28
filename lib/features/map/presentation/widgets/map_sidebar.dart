import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pistci/core/constants/app_colors.dart';
import 'package:pistci/features/map/domain/entities/map_marker.dart';
import 'package:pistci/features/map/presentation/providers/map_providers.dart';
import 'package:pistci/features/search/presentation/providers/search_providers.dart';

/// Panneau latéral gauche de la carte avec recherche, catégories et markers
class MapSidebar extends ConsumerWidget {
  const MapSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Container(
      width: isMobile ? null : 340,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: isMobile ? null : const Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          _SearchBar(ref: ref),
          _SearchResults(ref: ref),
          _CategoryFilter(ref: ref),
          const Expanded(child: _MarkersList()),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final WidgetRef ref;
  const _SearchBar({required this.ref});

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: AppColors.textDim),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Rechercher un lieu en CI...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            if (query.isNotEmpty)
              GestureDetector(
                onTap: () => ref.read(searchQueryProvider.notifier).state = '',
                child: const Icon(Icons.close, size: 16, color: AppColors.textDim),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final WidgetRef ref;
  const _SearchResults({required this.ref});

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    if (results.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${results.length} resultat${results.length > 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textDim,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          ...results.map((m) => _SearchResultTile(
                marker: m,
                onTap: () {
                  ref.read(selectedMarkerProvider.notifier).state = m;
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final MapMarker marker;
  final VoidCallback onTap;
  const _SearchResultTile({required this.marker, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Text(marker.category.icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(marker.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          )),
                      Text(marker.description,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final WidgetRef ref;
  const _CategoryFilter({required this.ref});

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _CategoryChip(
            label: 'Tous',
            icon: '📍',
            isSelected: selected == null,
            onTap: () => ref.read(selectedCategoryProvider.notifier).state = null,
          ),
          ...MarkerCategory.values
              .where((c) => c != MarkerCategory.custom)
              .map((c) => _CategoryChip(
                    label: c.label,
                    icon: c.icon,
                    isSelected: selected == c,
                    onTap: () => ref.read(selectedCategoryProvider.notifier).state = c,
                  )),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.ciOrange.withAlpha(30) : AppColors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.ciOrange : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.ciOrange : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarkersList extends ConsumerWidget {
  const _MarkersList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markersAsync = ref.watch(filteredMarkersProvider);
    final selectedMarker = ref.watch(selectedMarkerProvider);

    return markersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.ciOrange)),
      error: (e, _) => Center(child: Text('Erreur: $e')),
      data: (markers) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: markers.length,
        itemBuilder: (context, index) {
          final marker = markers[index];
          final isSelected = selectedMarker?.id == marker.id;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: isSelected ? AppColors.ciOrange.withAlpha(15) : AppColors.card,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  ref.read(selectedMarkerProvider.notifier).state =
                      isSelected ? null : marker;
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.ciOrange : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
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
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.ciOrange : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              marker.description,
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          marker.category.label,
                          style: const TextStyle(fontSize: 9, color: AppColors.textDim),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
