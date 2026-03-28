/// Textes statiques de l'application
class AppStrings {
  AppStrings._();

  static const String appName = 'PistCI';
  static const String appTagline = 'Cartographie interactive — Cote d\'Ivoire';

  // Navigation
  static const String navMap = 'Carte';
  static const String navRoutes = 'Itineraires';
  static const String navZones = 'Zones';
  static const String navAbout = 'A propos';

  // Map
  static const String searchPlaceholder = 'Rechercher un lieu en CI...';
  static const String mapTypeStandard = 'Standard';
  static const String mapTypeSatellite = 'Satellite';
  static const String mapTypeTerrain = 'Terrain';

  // Routes
  static const String routeTitle = 'Itineraires';
  static const String routeSubtitle = 'Calcul d\'itineraires en Cote d\'Ivoire';
  static const String routeOriginLabel = 'Depart';
  static const String routeDestinationLabel = 'Arrivee';
  static const String routeCalculate = 'Calculer l\'itineraire';
  static const String routePopular = 'Itineraires populaires';

  // Modes de transport
  static const String modeCar = 'Voiture';
  static const String modeBike = 'Velo';
  static const String modeWalk = 'A pied';

  // Zones
  static const String zoneTitle = 'Zones & Polygones';
  static const String zoneSubtitle = 'Dessiner et gerer des zones sur la carte';
  static const String zoneNew = 'Nouvelle zone';

  // About
  static const String aboutDescription =
      'Jour 12 du Challenge 14-14-14. PistCI est une application de '
      'cartographie interactive dediee a la Cote d\'Ivoire. "Pist" fait '
      'reference aux pistes et routes qui relient les villes et villages ivoiriens.';
  static const String aboutObjective =
      'L\'objectif : cartographier les lieux, calculer des itineraires et '
      'dessiner des zones sur une carte interactive. Voiture, velo ou a pied '
      '— trouvez votre chemin en CI.';

  // Challenge
  static const String challengeFooter = 'CHALLENGE 14-14-14 // JOUR 12 // MARS 2026';
}
