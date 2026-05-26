import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,

    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
