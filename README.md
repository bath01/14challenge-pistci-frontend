# PistCI

**Application de cartographie interactive pour la Cote d'Ivoire**

> "Pist" = piste, les routes et chemins de Cote d'Ivoire. Reference aux pistes qui relient les villes et villages ivoiriens.

Projet du **Challenge 14-14-14** — Jour 12 | Mars 2026

## Fonctionnalites

### Carte interactive
- Carte OpenStreetMap avec tuiles standard, satellite et terrain
- Markers par categories : monuments, commerces, transports, hotels, loisirs, education, urgences, services
- Geolocalisation GPS en temps reel
- Zones polygonales (quartiers, transports, commerces)
- Mode carte legere pour economiser les donnees mobiles
- Recherche de lieux avec bouton micro

### Transports locaux ivoiriens
- 6 modes : Voiture, Velo, A pied, **Gbaka**, **Woro-woro**, **Bateau-bus**
- Calcul d'itineraire dynamique via OSRM (distances et durees reelles)
- Geocodage des noms de lieux via Nominatim
- **Estimation du cout en FCFA** selon le mode de transport

### Zones d'Abidjan
- 10 zones predefinies : Plateau, Cocody, Yopougon, Abobo, Treichville, Marcory
- Zones de couverture transport (Bateau-bus lagune, Gbaka Adjame-Yopougon)
- Zones commerciales (Grand Marche d'Adjame, Zone 4 Marcory)
- Filtres par type + creation de zones personnelles

### Lieux d'urgence et services
- Hopitaux (CHU Cocody, CHU Treichville), pharmacies de garde, police, pompiers
- Services : Orange Money, MTN Money, stations-service, banques
- Numeros de telephone et indicateur 24h

### UX adaptee au contexte ivoirien
- Splash screen anime aux couleurs du drapeau CI
- Onboarding avec selection de ville (Abidjan, Yamoussoukro, Bouake, San-Pedro, Korhogo, Man)
- Theme clair/sombre (toggle dans la navbar)
- Indicateur hors-ligne avec fallback sur donnees locales
- Partage de lieux via WhatsApp/SMS
- Signalement communautaire sur les markers
- Responsive : desktop (sidebar + carte) / mobile (bottom nav)

## API

| Endpoint | Source | Usage |
|----------|--------|-------|
| `GET /places` | `api.pistci.chalenge14.com` | Lieux touristiques CI (20 lieux) |
| OSRM | `router.project-osrm.org` | Calcul d'itineraire (distance, duree) |
| Nominatim | `nominatim.openstreetmap.org` | Geocodage des noms de lieux |
| OpenStreetMap | `tile.openstreetmap.org` | Tuiles de carte |
| ArcGIS | `server.arcgisonline.com` | Tuiles satellite |
| OpenTopoMap | `tile.opentopomap.org` | Tuiles terrain |

Fallback : si l'API PistCI ne repond pas, les donnees mock locales prennent le relais.

## Stack technique

| Couche | Technologie |
|--------|-------------|
| Frontend | Flutter (iOS, Android, Web) |
| State management | Riverpod |
| Navigation | go_router |
| HTTP | Dio |
| Cartographie | flutter_map + OpenStreetMap |
| Geolocalisation | Geolocator |
| Partage | share_plus |
| Connectivite | connectivity_plus |
| Backend | Rust + GraphQL *(repo separe)* |

## Architecture

Clean Architecture + Feature-first :

```
lib/
├── core/
│   ├── constants/         # Couleurs CI, textes, valeurs par defaut
│   ├── theme/             # Themes clair/sombre + provider
│   ├── router/            # GoRouter avec ShellRoute
│   ├── network/           # Client Dio configure
│   └── widgets/           # AppShell, indicateur connexion
├── features/
│   ├── map/               # Carte + markers (API + mock)
│   ├── routes/            # Itineraires dynamiques (OSRM)
│   ├── zones/             # Zones d'Abidjan (quartiers, transport, commerce)
│   ├── search/            # Recherche de lieux
│   ├── onboarding/        # Ecran de bienvenue + selection ville
│   └── about/             # Page A propos
```

Chaque feature suit le pattern : `domain/` (entities, repositories) → `data/` (datasources, implementations) → `presentation/` (pages, widgets, providers)

## Demarrage rapide

```bash
# Installer les dependances
flutter pub get

# Lancer sur Android
flutter run

# Lancer en mode web
flutter run -d chrome

# Analyser le code
flutter analyze

# Build APK release
flutter build apk --release

# Build web
flutter build web
```

## Workflow

```
Splash (3s) → Onboarding (1er lancement) → Carte
                                             ├── Chercher un lieu
                                             ├── Voir un marker → Partager / Signaler
                                             ├── Calculer un itineraire → Cout FCFA
                                             └── Explorer les zones d'Abidjan
```

## Equipe

| Membre | Role |
|--------|------|
| **Bath Dorgeles** | Chef de projet & Front-end |
| **Oclin Marcel Coulibaly** | Front-end (Flutter) |
| **Rayane Irie** | Back-end (Rust + GraphQL) |

## Licence

Open Source sur [225os.com](https://225os.com) & [GitHub](https://github.com)
