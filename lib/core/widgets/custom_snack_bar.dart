import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomSnackBar {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
        backgroundColor: AppColors.kErrorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}