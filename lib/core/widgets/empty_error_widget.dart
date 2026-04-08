import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'custom_button.dart';

class EmptyErrorWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  const EmptyErrorWidget({
    super.key,
    required this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64.sp, color: AppColors.kTextHint),
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              CustomButton(
                text: 'Retry',
                onPressed: onRetry,
                variant: ButtonVariant.outlined,
                width: 150.w,
              )
            ]
          ],
        ),
      ),
    );
  }
}