import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pistci/core/widgets/app_shell.dart';
import 'package:pistci/features/map/presentation/pages/map_page.dart';
import 'package:pistci/features/routes/presentation/pages/routes_page.dart';
import 'package:pistci/features/zones/presentation/pages/zones_page.dart';
import 'package:pistci/features/about/presentation/pages/about_page.dart';

/// Configuration du routeur principal
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/map',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/map',
            name: 'map',
            builder: (context, state) => const MapPage(),
          ),
          GoRoute(
            path: '/routes',
            name: 'routes',
            builder: (context, state) => const RoutesPage(),
          ),
          GoRoute(
            path: '/zones',
            name: 'zones',
            builder: (context, state) => const ZonesPage(),
          ),
          GoRoute(
            path: '/about',
            name: 'about',
            builder: (context, state) => const AboutPage(),
          ),
        ],
      ),
    ],
  );
}
