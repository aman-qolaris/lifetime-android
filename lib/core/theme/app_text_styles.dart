import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headers
  static TextStyle get h1Extrabold => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.kTextPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get h2Bold => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.kTextPrimary,
  );

  // Body & Inputs
  static TextStyle get bodyMedium => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.kTextSecondary,
  );

  static TextStyle get bodyRegular => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.kTextPrimary,
  );

  // Labels & Hints
  static TextStyle get labelBold => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.kTextPrimary,
  );

  static TextStyle get hintText => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.kTextHint,
  );

  static TextStyle get errorText => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.kErrorColor,
  );

  static TextStyle get buttonText => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.kSurfaceColor,
  );
}