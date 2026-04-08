import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum ButtonVariant { primary, outlined }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == ButtonVariant.primary;

    return SizedBox(
      width: width ?? double.infinity,
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.kPrimaryColor : AppColors.kSurfaceColor,
          foregroundColor: isPrimary ? AppColors.kSurfaceColor : AppColors.kPrimaryColor,
          elevation: isPrimary ? 1 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: AppColors.kPrimaryColor, width: 1.5),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
          height: 24.h,
          width: 24.h,
          child: CircularProgressIndicator(
            color: isPrimary ? AppColors.kSurfaceColor : AppColors.kPrimaryColor,
            strokeWidth: 2.5,
          ),
        )
            : Text(
          text,
          style: AppTextStyles.buttonText.copyWith(
            color: isPrimary ? AppColors.kSurfaceColor : AppColors.kPrimaryColor,
          ),
        ),
      ),
    );
  }
}