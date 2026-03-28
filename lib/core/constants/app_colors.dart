import 'package:flutter/material.dart';

/// Palette de couleurs de PistCI — inspirée du drapeau ivoirien
class AppColors {
  AppColors._();

  // Couleurs principales CI
  static const Color ciOrange = Color(0xFFFF6B00);
  static const Color ciGreen = Color(0xFF00B456);
  static const Color ciWhite = Color(0xFFFFFFFF);

  // Fond sombre
  static const Color darkBg = Color(0xFF0D0D12);
  static const Color card = Color(0xFF16161E);
  static const Color surface = Color(0xFF1C1C26);
  static const Color border = Color(0xFF2A2A36);

  // Texte
  static const Color textPrimary = Color(0xFFF0F0F0);
  static const Color textSecondary = Color(0xFF9898A6);
  static const Color textDim = Color(0xFF5A5A6E);

  // Gradients
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [ciOrange, Color(0xFFFFa040)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [ciGreen, Color(0xFF00D468)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Couleurs de catégories de markers
  static const Color categoryMonument = ciOrange;
  static const Color categoryCommerce = Color(0xFF3B82F6);
  static const Color categoryTransport = ciGreen;
  static const Color categoryHotel = Color(0xFFA855F7);
  static const Color categoryLoisir = Color(0xFFF59E0B);
  static const Color categoryEducation = Color(0xFF06B6D4);
  static const Color categoryQuartier = Color(0xFFEF4444);
}
