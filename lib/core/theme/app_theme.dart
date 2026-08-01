import 'package:flutter/material.dart';

class AppColors {
  static const pine = Color(0xFF2F5D53);
  static const marigold = Color(0xFFE8A33D);
  static const paper = Color(0xFFF7F5F0);
  static const clay = Color(0xFFC1502E);
  static const sage = Color(0xFF7A9471);
  static const ink = Color(0xFF2B2B26);
}

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.pine,
      brightness: Brightness.light,
      primary: AppColors.pine,
      secondary: AppColors.marigold,
      error: AppColors.clay,
      surface: AppColors.paper,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.paper,
      textTheme: Typography.englishLike2021.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.marigold,
          foregroundColor: AppColors.ink,
        ),
      ),
    );
  }
}