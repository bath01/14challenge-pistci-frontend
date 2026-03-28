import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pistci/core/constants/app_colors.dart';
import 'package:pistci/core/constants/app_strings.dart';
import 'package:pistci/core/extensions/format_extensions.dart';
import 'package:pistci/features/routes/domain/entities/route_entity.dart';
import 'package:pistci/features/routes/presentation/providers/route_providers.dart';

/// Page des itinéraires
class RoutesPage extends ConsumerWidget {
  const RoutesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 20 : 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              const Text(
                AppStrings.routeTitle,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.routeSubtitle,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),

              // Formulaire
              const _RouteForm(),
              const SizedBox(height: 32),

              // Itinéraires populaires
              const Text(
                AppStrings.routePopular,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textDim,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              const _RouteList(),

              // Footer
              const SizedBox(height: 40),
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

class _RouteForm extends ConsumerWidget {
  const _RouteForm();

  Future<void> _calculateRoute(BuildContext context, WidgetRef ref) async {
    final origin = ref.read(routeOriginTextProvider);
    final destination = ref.read(routeDestinationTextProvider);
    final mode = ref.read(routeModeProvider);

    if (origin.trim().isEmpty || destination.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir le depart et la destination'),
          backgroundColor: AppColors.ciOrange,
        ),
      );
      return;
    }

    ref.read(isCalculatingRouteProvider.notifier).state = true;

    final repo = ref.read(routeRepositoryProvider);
    final result = await repo.calculateRoute(
      origin: origin,
      destination: destination,
      mode: mode,
    );

    ref.read(isCalculatingRouteProvider.notifier).state = false;
    ref.read(calculatedRouteProvider.notifier).state = result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(routeModeProvider);
    final isCalculating = ref.watch(isCalculatingRouteProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Champs départ / arrivée
          Row(
            children: [
              Expanded(
                child: _RouteInput(
                  label: AppStrings.routeOriginLabel,
                  hint: 'Point de depart',
                  dotColor: AppColors.ciGreen,
                  onChanged: (v) => ref.read(routeOriginTextProvider.notifier).state = v,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _RouteInput(
                  label: AppStrings.routeDestinationLabel,
                  hint: 'Destination',
                  dotColor: AppColors.ciOrange,
                  onChanged: (v) => ref.read(routeDestinationTextProvider.notifier).state = v,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sélection du mode
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TransportMode.values.map((m) {
              final isSelected = mode == m;
              return GestureDetector(
                onTap: () => ref.read(routeModeProvider.notifier).state = m,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.ciOrange.withAlpha(30) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(m.icon, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        m.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppColors.ciOrange : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Bouton calculer
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: AppColors.ciOrange.withAlpha(60), blurRadius: 16),
                ],
              ),
              child: ElevatedButton(
                onPressed: isCalculating ? null : () => _calculateRoute(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                ),
                child: isCalculating
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text(AppStrings.routeCalculate),
              ),
            ),
          ),
          // Résultat du calcul
          _CalculatedRouteResult(),
        ],
      ),
    );
  }
}

class _RouteInput extends StatelessWidget {
  final String label;
  final String hint;
  final Color dotColor;
  final ValueChanged<String> onChanged;

  const _RouteInput({
    required this.label,
    required this.hint,
    required this.dotColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 10, color: AppColors.textDim, letterSpacing: 1),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteList extends ConsumerWidget {
  const _RouteList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routesAsync = ref.watch(routesProvider);
    final selectedRoute = ref.watch(selectedRouteProvider);

    return routesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.ciOrange)),
      error: (e, _) => Text('Erreur: $e'),
      data: (routes) => Column(
        children: routes.map((r) {
          final isSelected = selectedRoute?.id == r.id;
          return _RouteCard(route: r, isSelected: isSelected);
        }).toList(),
      ),
    );
  }
}

class _RouteCard extends ConsumerWidget {
  final RouteEntity route;
  final bool isSelected;

  const _RouteCard({required this.route, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          ref.read(selectedRouteProvider.notifier).state = isSelected ? null : route;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? route.color.withAlpha(10) : AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? route.color : AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Infos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: route.color.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${route.mode.icon} ${route.mode.label}',
                            style: TextStyle(fontSize: 10, color: route.color, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            const Icon(Icons.circle, size: 8, color: AppColors.ciGreen),
                            Text(route.origin, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            const Text('→', style: TextStyle(color: AppColors.textDim)),
                            const Icon(Icons.circle, size: 8, color: AppColors.ciOrange),
                            Flexible(child: Text(route.destination, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Distance / durée
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        route.distance.toDistanceString(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: route.color),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        route.duration.toDurationString(),
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      if (route.estimatedCostFCFA > 0) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.ciGreen.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '~${route.formattedCost}',
                            style: const TextStyle(fontSize: 10, color: AppColors.ciGreen, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),

              // Détails étendus
              if (isSelected) ...[
                const SizedBox(height: 16),
                Container(height: 1, color: AppColors.border),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _DetailChip(icon: '📏', label: 'Distance', value: route.distance.toDistanceString()),
                    const SizedBox(width: 12),
                    _DetailChip(icon: '⏱️', label: 'Duree', value: route.duration.toDurationString()),
                    const SizedBox(width: 12),
                    _DetailChip(icon: route.mode.icon, label: 'Mode', value: route.mode.label),
                    const SizedBox(width: 12),
                    _DetailChip(icon: '💰', label: 'Cout', value: route.formattedCost),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CalculatedRouteResult extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(calculatedRouteProvider);
    if (route == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.ciOrange.withAlpha(10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.ciOrange),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.ciOrange, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    route.name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MiniStat(icon: route.mode.icon, value: route.mode.label),
                _MiniStat(icon: '📏', value: route.distance.toDistanceString()),
                _MiniStat(icon: '⏱️', value: route.duration.toDurationString()),
                if (route.estimatedCostFCFA > 0)
                  _MiniStat(icon: '💰', value: route.formattedCost),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String icon;
  final String value;
  const _MiniStat({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _DetailChip({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textDim)),
          ],
        ),
      ),
    );
  }
}
