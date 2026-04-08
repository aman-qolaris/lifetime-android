import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.kBackgroundColor,
      colorScheme: const ColorScheme.light(
        primary: AppColors.kPrimaryColor,
        onPrimary: AppColors.kSurfaceColor,
        secondary: AppColors.kPrimaryHover,
        onSecondary: AppColors.kSurfaceColor,
        error: AppColors.kErrorColor,
        onError: AppColors.kSurfaceColor,
        surface: AppColors.kSurfaceColor,
        onSurface: AppColors.kTextPrimary,
      ),

      // Default AppBar Style
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.kSurfaceColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.kTextPrimary),
        titleTextStyle: AppTextStyles.h2Bold,
      ),

      // Default Global Text Theme
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.h1Extrabold,
        headlineMedium: AppTextStyles.h2Bold,
        bodyLarge: AppTextStyles.bodyMedium,
        bodyMedium: AppTextStyles.bodyRegular,
        labelLarge: AppTextStyles.labelBold,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kPrimaryColor,
          foregroundColor: AppColors.kSurfaceColor,
          textStyle: AppTextStyles.buttonText,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
      ),

      // Input Decoration (Text Fields) Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.kSurfaceColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        hintStyle: AppTextStyles.hintText,
        errorStyle: AppTextStyles.errorText,

        // Default Border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: AppColors.kBorderDefault, width: 1),
        ),
        // Enabled Border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: AppColors.kBorderDefault, width: 1),
        ),
        // Focused Border (Orange)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: AppColors.kBorderFocus, width: 2),
        ),
        // Error Border (Red)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: AppColors.kErrorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: AppColors.kErrorColor, width: 2),
        ),
      ),
    );
  }
}