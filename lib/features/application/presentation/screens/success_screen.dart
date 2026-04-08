import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSurfaceColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Success Icon
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 80.sp,
                ),
              ),
              SizedBox(height: 32.h),

              // Success Message
              Text(
                'Application Submitted!',
                style: AppTextStyles.h1Extrabold.copyWith(color: Colors.green.shade700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'Your lifetime membership application has been successfully submitted.\n\nIt is now pending review by your proposer and the Mandal President. You will be notified via email once approved to proceed with the payment.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
              ),

              const Spacer(),

              // Return Button
              CustomButton(
                text: 'Back to Home',
                onPressed: () {
                  // Navigate back to the start
                  context.go('/');
                },
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}