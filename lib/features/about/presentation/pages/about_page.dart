import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pistci/core/constants/app_colors.dart';
import 'package:pistci/core/constants/app_strings.dart';
import 'package:pistci/features/map/presentation/providers/map_providers.dart';
import 'package:pistci/features/routes/presentation/providers/route_providers.dart';
import 'package:pistci/features/zones/presentation/providers/zone_providers.dart';

/// Page A propos du projet PistCI
class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 20 : 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              _DescriptionCard(),
              const SizedBox(height: 24),
              isMobile
                  ? const Column(
                      children: [
                        _TeamCard(),
                        SizedBox(height: 16),
                        _StackCard(),
                      ],
                    )
                  : const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _TeamCard()),
                        SizedBox(width: 16),
                        Expanded(child: _StackCard()),
                      ],
                    ),
              const SizedBox(height: 24),
              _StatsRow(ref: ref),
              const SizedBox(height: 24),
              _OpenSourceBadge(),
              const SizedBox(height: 24),
              const Text(
                AppStrings.challengeFooter,
                style: TextStyle(fontSize: 10, color: AppColors.textDim, letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drapeau CI
          Container(
            width: 56,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: const Row(
              children: [
                Expanded(child: ColoredBox(color: AppColors.ciOrange, child: SizedBox.expand())),
                Expanded(child: ColoredBox(color: Colors.white, child: SizedBox.expand())),
                Expanded(child: ColoredBox(color: AppColors.ciGreen, child: SizedBox.expand())),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.ciOrange,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.aboutDescription,
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.8),
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.aboutObjective,
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.8),
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard();

  static const _team = [
    {'name': 'Bath Dorgeles', 'role': 'Chef de projet & Front'},
    {'name': 'Oclin Marcel C.', 'role': 'Dev Front-end (Flutter)'},
    {'name': 'Rayane Irie', 'role': 'Back-end (Rust + GraphQL)'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "L'EQUIPE",
            style: TextStyle(fontSize: 10, color: AppColors.textDim, letterSpacing: 1.5),
          ),
          const SizedBox(height: 14),
          ..._team.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        m['name']!.split(' ').take(2).map((w) => w[0]).join(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m['name']!,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          m['role']!,
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _StackCard extends StatelessWidget {
  const _StackCard();

  static const _stack = ['Flutter (Web)', 'Rust', 'GraphQL', 'OpenStreetMap'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STACK TECHNIQUE',
            style: TextStyle(fontSize: 10, color: AppColors.textDim, letterSpacing: 1.5),
          ),
          const SizedBox(height: 14),
          ..._stack.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    t,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ciGreen,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final WidgetRef ref;
  const _StatsRow({required this.ref});

  @override
  Widget build(BuildContext context) {
    final markerCount = ref.watch(markersProvider).maybeWhen(data: (l) => l.length, orElse: () => 0);
    final routeCount = ref.watch(routesProvider).maybeWhen(data: (l) => l.length, orElse: () => 0);
    final zoneCount = ref.watch(zonesProvider).maybeWhen(data: (l) => l.length, orElse: () => 0);

    final stats = [
      {'value': '$markerCount', 'label': 'Lieux'},
      {'value': '$routeCount', 'label': 'Itineraires'},
      {'value': '$zoneCount', 'label': 'Zones'},
      {'value': '7', 'label': 'Categories'},
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
      children: stats.asMap().entries.map((entry) {
        final i = entry.key;
        final s = entry.value;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                s['value']!,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: i.isEven ? AppColors.ciOrange : AppColors.ciGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                s['label']!,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _OpenSourceBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Open Source sur ', style: TextStyle(color: AppColors.textSecondary)),
            TextSpan(
              text: '225os.com',
              style: TextStyle(color: AppColors.ciOrange, fontWeight: FontWeight.w600),
            ),
            TextSpan(text: ' & ', style: TextStyle(color: AppColors.textSecondary)),
            TextSpan(
              text: 'GitHub',
              style: TextStyle(color: AppColors.ciGreen, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
