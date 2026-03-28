import 'package:equatable/equatable.dart';
import 'package:pistci/features/map/domain/entities/map_marker.dart';

/// Résultat d'une recherche de lieu
class SearchResult extends Equatable {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final MarkerCategory category;

  const SearchResult({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.category = MarkerCategory.custom,
  });

  @override
  List<Object?> get props => [name, address, latitude, longitude, category];
}

/// Etat de la recherche
class SearchState extends Equatable {
  final String query;
  final List<SearchResult> results;
  final List<String> recentSearches;
  final bool isLoading;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.recentSearches = const [],
    this.isLoading = false,
  });

  SearchState copyWith({
    String? query,
    List<SearchResult>? results,
    List<String>? recentSearches,
    bool? isLoading,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      recentSearches: recentSearches ?? this.recentSearches,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [query, results, recentSearches, isLoading];
}
