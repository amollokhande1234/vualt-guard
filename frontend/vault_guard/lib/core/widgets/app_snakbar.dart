import 'package:flutter/material.dart';
import 'package:vault_guard/core/constants/app_colors.dart';

extension SnackbarExtension on BuildContext {
  void showSnackbar({
    required String message,
    Color backgroundColor = AppColors.primary,
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
  }
}
