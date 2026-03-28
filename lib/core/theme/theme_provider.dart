import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider du mode de thème (clair/sombre)
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

/// Provider pour le mode carte légère (économie de données)
final lightMapModeProvider = StateProvider<bool>((ref) => false);
