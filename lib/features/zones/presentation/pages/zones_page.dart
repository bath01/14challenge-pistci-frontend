import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:pistci/core/constants/app_colors.dart';
import 'package:pistci/core/constants/app_strings.dart';
import 'package:pistci/features/zones/domain/entities/zone_entity.dart';
import 'package:pistci/features/zones/presentation/providers/zone_providers.dart';

/// Page de gestion des zones — contexte ivoirien
class ZonesPage extends ConsumerWidget {
  const ZonesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final zonesAsync = ref.watch(filteredZonesProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 20 : 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.zoneTitle,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1),
              ),
              const SizedBox(height: 4),
              const Text(
                'Quartiers, transports et zones commerciales d\'Abidjan',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // Filtres
              const _ZoneFilters(),
              const SizedBox(height: 20),

              // Liste
              zonesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.ciOrange)),
                error: (e, _) => Text('Erreur: $e'),
                data: (zones) => zones.isEmpty
                    ? _EmptyState()
                    : _ZoneList(zones: zones),
              ),

              const SizedBox(height: 20),

              // Bouton ajouter
              _AddZoneButton(),

              const SizedBox(height: 32),
              const Center(
                child: Text(
                  AppStrings.challengeFooter,
                  style: TextStyle(fontSize: 10, color: AppColors.textDim, letterSpacing: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chips de filtrage par type
class _ZoneFilters extends ConsumerWidget {
  const _ZoneFilters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedZoneTypeFilter);
    final onlyMine = ref.watch(showOnlyMyZonesProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'Tous',
            icon: '📍',
            isSelected: selectedType == null && !onlyMine,
            onTap: () {
              ref.read(selectedZoneTypeFilter.notifier).state = null;
              ref.read(showOnlyMyZonesProvider.notifier).state = false;
            },
          ),
          ...ZoneType.values.where((t) => t != ZoneType.custom).map((type) => _FilterChip(
                label: type.label,
                icon: type.icon,
                isSelected: selectedType == type && !onlyMine,
                onTap: () {
                  ref.read(selectedZoneTypeFilter.notifier).state = type;
                  ref.read(showOnlyMyZonesProvider.notifier).state = false;
                },
              )),
          _FilterChip(
            label: 'Mes zones',
            icon: '👤',
            isSelected: onlyMine,
            onTap: () {
              ref.read(showOnlyMyZonesProvider.notifier).state = true;
              ref.read(selectedZoneTypeFilter.notifier).state = null;
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.ciOrange.withAlpha(25) : AppColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? AppColors.ciOrange : AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.ciOrange : AppColors.textSecondary,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

/// Etat vide quand aucune zone ne correspond au filtre
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Text('📍', style: TextStyle(fontSize: 40)),
          SizedBox(height: 12),
          Text('Aucune zone trouvee', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text('Cree ta propre zone ou change de filtre',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

/// Liste de zones avec swipe-to-delete pour les perso
class _ZoneList extends StatelessWidget {
  final List<ZoneEntity> zones;
  const _ZoneList({required this.zones});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: zones.map((z) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: z.isOfficial
                ? _ZoneCard(zone: z)
                : _DismissibleZoneCard(zone: z),
          )).toList(),
    );
  }
}

/// Carte de zone swipeable pour suppression (zones perso uniquement)
class _DismissibleZoneCard extends ConsumerWidget {
  final ZoneEntity zone;
  const _DismissibleZoneCard({required this.zone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(zone.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withAlpha(20),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.card,
            title: const Text('Supprimer cette zone ?'),
            content: Text('La zone "${zone.name}" sera supprimee.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Supprimer', style: TextStyle(color: Color(0xFFEF4444))),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(zoneRepositoryProvider).deleteZone(zone.id);
        ref.invalidate(zonesProvider);
      },
      child: _ZoneCard(zone: zone),
    );
  }
}

/// Carte de zone enrichie
class _ZoneCard extends StatelessWidget {
  final ZoneEntity zone;
  const _ZoneCard({required this.zone});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showZoneDetail(context, zone),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Icône type
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: zone.fillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: zone.strokeColor, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(zone.type.icon, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 14),

            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(zone.name,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis),
                      ),
                      // Badge officielle / perso
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: zone.isOfficial
                              ? AppColors.ciGreen.withAlpha(20)
                              : AppColors.ciOrange.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          zone.isOfficial ? 'Officielle' : 'Perso',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: zone.isOfficial ? AppColors.ciGreen : AppColors.ciOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    zone.description.isEmpty ? '${zone.pointCount} points' : zone.description,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (zone.transportInfo != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.directions_bus, size: 12, color: AppColors.ciGreen),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(zone.transportInfo!,
                              style: const TextStyle(fontSize: 10, color: AppColors.ciGreen),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textDim),
          ],
        ),
      ),
    );
  }

  void _showZoneDetail(BuildContext context, ZoneEntity zone) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _ZoneDetailSheet(zone: zone),
    );
  }
}

/// Bottom sheet de détail d'une zone
class _ZoneDetailSheet extends ConsumerWidget {
  final ZoneEntity zone;
  const _ZoneDetailSheet({required this.zone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poignée
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: zone.fillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: zone.strokeColor, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(zone.type.icon, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(zone.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: zone.type.defaultColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(zone.type.label,
                              style: TextStyle(fontSize: 10, color: zone.type.defaultColor, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          zone.isOfficial ? 'Officielle' : 'Zone personnelle',
                          style: const TextStyle(fontSize: 11, color: AppColors.textDim),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          if (zone.description.isNotEmpty)
            Text(zone.description, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6)),

          // Info transport
          if (zone.transportInfo != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.ciGreen.withAlpha(10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.ciGreen.withAlpha(40)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_bus, size: 18, color: AppColors.ciGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(zone.transportInfo!,
                        style: const TextStyle(fontSize: 12, color: AppColors.ciGreen, height: 1.4)),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Stats
          Row(
            children: [
              _StatChip(label: 'Points', value: '${zone.pointCount}'),
              const SizedBox(width: 8),
              _StatChip(label: 'Type', value: zone.type.label),
            ],
          ),

          const SizedBox(height: 20),

          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final nav = Navigator.of(context);
                    nav.pop();
                    // Utilise un delay pour laisser le pop finir avant de naviguer
                    Future.microtask(() {
                      if (context.mounted) context.go('/map');
                    });
                  },
                  icon: const Icon(Icons.map, size: 16),
                  label: const Text('Voir sur la carte'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ciOrange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              if (!zone.isOfficial) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    ref.read(zoneRepositoryProvider).deleteZone(zone.id);
                    ref.invalidate(zonesProvider);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withAlpha(15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEF4444).withAlpha(40)),
                    ),
                    child: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFEF4444)),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: '$label: ', style: const TextStyle(fontSize: 11, color: AppColors.textDim)),
        TextSpan(text: value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ])),
    );
  }
}

/// Bouton flottant pour ajouter une zone personnelle
class _AddZoneButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showAddDialog(context, ref),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.textDim),
            SizedBox(width: 8),
            Text('Nouvelle zone personnelle',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    ZoneType selectedType = ZoneType.custom;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Nouvelle zone', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Nom de la zone',
                    filled: true, fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                TextField(
                  controller: descController,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Description (optionnel)',
                    filled: true, fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                  ),
                ),
                const SizedBox(height: 14),

                // Type
                const Text('Type de zone', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: ZoneType.values.map((type) {
                    final isSelected = selectedType == type;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedType = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? type.defaultColor.withAlpha(25) : AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isSelected ? type.defaultColor : AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(type.icon, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(type.label, style: TextStyle(
                              fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? type.defaultColor : AppColors.textSecondary,
                            )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                final color = selectedType.defaultColor;
                final newZone = ZoneEntity(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  description: descController.text.trim(),
                  type: selectedType,
                  isOfficial: false,
                  fillColor: color.withAlpha(48),
                  strokeColor: color,
                  points: [
                    LatLng(5.3200, -4.0200), LatLng(5.3200, -4.0100),
                    LatLng(5.3150, -4.0050), LatLng(5.3100, -4.0100),
                    LatLng(5.3100, -4.0200),
                  ],
                );

                ref.read(zoneRepositoryProvider).createZone(newZone);
                ref.invalidate(zonesProvider);
                Navigator.pop(ctx);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Zone "$name" creee !'), backgroundColor: color),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.ciOrange),
              child: const Text('Creer'),
            ),
          ],
        ),
      ),
    );
  }
}
