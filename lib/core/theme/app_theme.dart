import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get appTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,

      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: const Color(0xFF1E1E1E),
      ),
      textTheme: TextTheme(
        headlineLarge: AppFonts.h1.copyWith(color: Colors.white),
        headlineMedium: AppFonts.h2.copyWith(color: Colors.white),
        titleLarge: AppFonts.h3.copyWith(color: Colors.white),
        bodyLarge: AppFonts.bodyLarge.copyWith(color: Colors.white),
        bodyMedium: AppFonts.bodyMedium.copyWith(color: Colors.white70),
        bodySmall: AppFonts.bodySmall.copyWith(color: Colors.white70),
        labelLarge: AppFonts.labelText.copyWith(color: Colors.white70),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: AppFonts.bodyLarge.copyWith(
          fontWeight: FontWeight.w500,
        ),
        textColor: AppColors.textPrimary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),

        selectedColor: Colors.white,
        selectedTileColor: const Color(0xFF2C2C2E),
        tileColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.1),
        thickness: 1,
      ),
    );
  }
}
