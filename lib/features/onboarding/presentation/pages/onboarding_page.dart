import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:pistci/core/constants/app_colors.dart';

/// Villes principales de Côte d'Ivoire avec coordonnées
class CICity {
  final String name;
  final String subtitle;
  final LatLng center;
  final double zoom;

  const CICity({required this.name, required this.subtitle, required this.center, this.zoom = 13});
}

const _cities = [
  CICity(name: 'Abidjan', subtitle: 'Capitale economique', center: LatLng(5.3167, -4.0333)),
  CICity(name: 'Yamoussoukro', subtitle: 'Capitale politique', center: LatLng(6.8276, -5.2893), zoom: 14),
  CICity(name: 'Bouake', subtitle: 'Centre du pays', center: LatLng(7.6939, -5.0308), zoom: 14),
  CICity(name: 'San-Pedro', subtitle: 'Port du Sud-Ouest', center: LatLng(4.7485, -6.6363), zoom: 14),
  CICity(name: 'Korhogo', subtitle: 'Capitale du Nord', center: LatLng(9.4580, -5.6295), zoom: 14),
  CICity(name: 'Man', subtitle: 'Region des montagnes', center: LatLng(7.4125, -7.5536), zoom: 14),
];

/// Provider pour savoir si l'onboarding a été complété
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

/// Provider pour la ville sélectionnée
final selectedCityProvider = StateProvider<CICity?>((ref) => null);

/// Ecran d'onboarding — sélection de la ville
class OnboardingPage extends ConsumerStatefulWidget {
  final VoidCallback onComplete;
  const OnboardingPage({super.key, required this.onComplete});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _currentPage = 0;
  CICity? _selectedCity;

  void _complete() {
    if (_selectedCity != null) {
      ref.read(selectedCityProvider.notifier).state = _selectedCity;
    }
    ref.read(onboardingCompleteProvider.notifier).state = true;
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _currentPage == 0 ? _buildWelcome() : _buildCitySelection(),
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Column(
      children: [
        const Spacer(flex: 2),
        // Drapeau
        Container(
          width: 80, height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Expanded(child: Container(color: AppColors.ciOrange)),
              Expanded(child: Container(color: Colors.white)),
              Expanded(child: Container(color: AppColors.ciGreen)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text.rich(
          TextSpan(children: [
            TextSpan(text: 'Bienvenue sur ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: AppColors.textPrimary)),
            TextSpan(text: 'Pist', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            TextSpan(text: 'CI', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.ciOrange)),
          ]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'Trouvez votre chemin en Cote d\'Ivoire.\nCarte, itineraires, lieux — tout est la.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
        ),
        const SizedBox(height: 40),
        // Features
        _featureRow('🗺️', 'Carte interactive', 'OpenStreetMap avec markers'),
        _featureRow('🚐', 'Transports locaux', 'Gbaka, Woro-woro, Bateau-bus'),
        _featureRow('💰', 'Estimation prix', 'Cout en FCFA par trajet'),
        _featureRow('🚨', 'Urgences', 'Hopitaux, pharmacies, police'),
        const Spacer(flex: 3),
        // Bouton suivant
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _currentPage = 1),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ciOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Commencer', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _featureRow(String emoji, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCitySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Ou es-tu ?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        const Text(
          'Choisis ta ville pour centrer la carte',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: _cities.map((city) {
              final isSelected = _selectedCity?.name == city.name;
              return GestureDetector(
                onTap: () => setState(() => _selectedCity = city),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.ciOrange.withAlpha(15) : AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.ciOrange : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        city.name,
                        style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700,
                          color: isSelected ? AppColors.ciOrange : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(city.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _complete,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ciOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              _selectedCity != null ? 'C\'est parti !' : 'Passer',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_selectedCity == null)
          const Center(
            child: Text(
              'Tu pourras changer plus tard',
              style: TextStyle(fontSize: 11, color: AppColors.textDim),
            ),
          ),
      ],
    );
  }
}
