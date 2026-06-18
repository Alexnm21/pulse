import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF6200EE);
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);

  // Dark theme surfaces
  static const Color scaffoldBackground = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardBackground = Color(0xFF242528);
  static const Color selectedTileColor = Color(0xFF2C2C2E);
  static const Color sidebarBackground = Color(0xFF1D2021);
  static const Color chipColor = Color(0xFF2A2A2A);

  // Light theme surfaces (unused in current dark-only theme)
  static const Color background = Color(0xFFF5F5F7);
  static const Color surface = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFFE5E2E1);
  static const Color textSecondary = Color(0xFF86868B);

  // Accent & functional colors
  static const Color normal = Color(0xFF53E16F);
  static const Color moderately = Color(0xFFFFCC00);
  static const Color critical = Color(0xFFFF5545);
  static const Color error = Color(0xFFB00020);

  // UI component colors
  static const Color selectedColor = Color(0xFFADC6FF);
  static const Color unselectedColor = Color(0xFFC1C6D7);

  // Pre-computed white variants with opacity (avoids Color.withValues on every build)
  static const Color white004 = Color(0x0AFFFFFF);
  static const Color white006 = Color(0x0FFFFFFF);
  static const Color white008 = Color(0x14FFFFFF);
  static const Color white010 = Color(0x1AFFFFFF);
  static const Color white012 = Color(0x1FFFFFFF);
  static const Color white050 = Color(0x80FFFFFF);

  // Pre-computed selectedColor variants with opacity
  static const Color selectedColor010 = Color(0x1AADC6FF);
  static const Color selectedColor020 = Color(0x33ADC6FF);
}
