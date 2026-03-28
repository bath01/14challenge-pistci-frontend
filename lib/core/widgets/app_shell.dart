import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pistci/core/constants/app_colors.dart';
import 'package:pistci/core/constants/app_strings.dart';
import 'package:pistci/core/theme/theme_provider.dart';
import 'package:pistci/core/widgets/connection_indicator.dart';
import 'package:pistci/features/map/domain/entities/map_marker.dart';
import 'package:pistci/features/map/presentation/providers/map_providers.dart';
import 'package:pistci/features/search/presentation/providers/search_providers.dart';

/// Seuil pour considérer l'écran comme mobile
const double kMobileBreakpoint = 600;

/// Shell principal avec navigation adaptative
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < kMobileBreakpoint;

    return Scaffold(
      bottomNavigationBar: isMobile ? _MobileBottomNav() : null,
      body: Column(
        children: [
          const ConnectionIndicator(),
          if (isMobile) const _MobileNavBar(),
          if (!isMobile) const _DesktopNavBar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Barre de navigation mobile : logo + champ recherche
class _MobileNavBar extends ConsumerStatefulWidget {
  const _MobileNavBar();

  @override
  ConsumerState<_MobileNavBar> createState() => _MobileNavBarState();
}

class _MobileNavBarState extends ConsumerState<_MobileNavBar> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _isSearching = true);
    _focusNode.requestFocus();
  }

  void _closeSearch() {
    setState(() => _isSearching = false);
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);

    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.darkBg,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Logo
                if (!_isSearching) ...[
                  GestureDetector(
                    onTap: () => context.go('/map'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSmallFlag(),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.appName,
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Toggle thème
                  GestureDetector(
                    onTap: () {
                      final current = ref.read(themeModeProvider);
                      ref.read(themeModeProvider.notifier).state =
                          current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(
                        ref.watch(themeModeProvider) == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                        size: 16, color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Bouton recherche
                  GestureDetector(
                    onTap: _openSearch,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, size: 16, color: AppColors.textDim),
                          SizedBox(width: 6),
                          Text('Rechercher...', style: TextStyle(fontSize: 12, color: AppColors.textDim)),
                        ],
                      ),
                    ),
                  ),
                ],

                // Mode recherche actif
                if (_isSearching) ...[
                  Expanded(
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.ciOrange),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 16, color: AppColors.ciOrange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
                              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                hintText: 'Rechercher un lieu en CI...',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                                isDense: true,
                              ),
                            ),
                          ),
                          // Bouton micro (recherche vocale)
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Recherche vocale bientot disponible'),
                                  backgroundColor: AppColors.ciOrange,
                                ),
                              );
                            },
                            child: const Icon(Icons.mic, size: 18, color: AppColors.textDim),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _closeSearch,
                    child: const Text(
                      'Annuler',
                      style: TextStyle(fontSize: 13, color: AppColors.ciOrange, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Résultats de recherche en dropdown
          if (_isSearching && searchResults.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 250),
              color: AppColors.surface,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final marker = searchResults[index];
                  return _SearchResultTile(
                    marker: marker,
                    onTap: () {
                      ref.read(selectedMarkerProvider.notifier).state = marker;
                      _closeSearch();
                      context.go('/map');
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSmallFlag() {
    return Container(
      width: 22,
      height: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(child: Container(color: AppColors.ciOrange)),
          Expanded(child: Container(color: Colors.white)),
          Expanded(child: Container(color: AppColors.ciGreen)),
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
      padding: const EdgeInsets.only(bottom: 4),
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
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
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

/// Navigation bottom bar pour mobile
class _MobileBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final items = [
      ('/map', Icons.map_outlined, Icons.map, AppStrings.navMap),
      ('/routes', Icons.directions_outlined, Icons.directions, AppStrings.navRoutes),
      ('/zones', Icons.hexagon_outlined, Icons.hexagon, AppStrings.navZones),
      ('/about', Icons.info_outline, Icons.info, AppStrings.navAbout),
    ];

    final currentIndex = items.indexWhere((item) => item.$1 == location).clamp(0, 3);

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: NavigationBar(
        backgroundColor: AppColors.darkBg,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.ciOrange.withAlpha(30),
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) => context.go(items[index].$1),
        destinations: items.map((item) => NavigationDestination(
          icon: Icon(item.$2, color: AppColors.textDim, size: 22),
          selectedIcon: Icon(item.$3, color: AppColors.ciOrange, size: 22),
          label: item.$4,
        )).toList(),
      ),
    );
  }
}

/// Barre de navigation desktop
class _DesktopNavBar extends StatelessWidget {
  const _DesktopNavBar();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.darkBg,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildLogo(context),
          const SizedBox(width: 40),
          _buildNavItem(context, AppStrings.navMap, '/map', location),
          _buildNavItem(context, AppStrings.navRoutes, '/routes', location),
          _buildNavItem(context, AppStrings.navZones, '/zones', location),
          _buildNavItem(context, AppStrings.navAbout, '/about', location),
          const Spacer(),
          _buildCIFlag(),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/map'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: AppColors.border, width: 0.5),
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
          const SizedBox(width: 10),
          Text(AppStrings.appName, style: Theme.of(context).appBarTheme.titleTextStyle),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, String path, String currentLocation) {
    final isActive = currentLocation == path;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () => context.go(path),
        style: TextButton.styleFrom(
          foregroundColor: isActive ? AppColors.ciOrange : AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: isActive ? AppColors.ciOrange.withAlpha(25) : null,
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildCIFlag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('\u{1f1e8}\u{1f1ee}', style: TextStyle(fontSize: 14)),
          SizedBox(width: 6),
          Text('CI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
