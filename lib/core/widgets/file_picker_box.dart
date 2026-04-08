import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FilePickerBox extends StatelessWidget {
  final String label;
  final File? file;
  final VoidCallback onTap;

  const FilePickerBox({
    super.key,
    required this.label,
    this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null;
    final isPdf = hasFile && file!.path.toLowerCase().endsWith('.pdf');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelBold),
        SizedBox(height: 6.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6.r),
          child: Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.kSurfaceColor,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: hasFile ? AppColors.kPrimaryColor : AppColors.kBorderDashed,
                width: hasFile ? 2 : 1,
                style: BorderStyle.solid,
              ),
            ),
            child: hasFile
                ? ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: isPdf
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.picture_as_pdf, color: AppColors.kPrimaryColor, size: 40.sp),
                  SizedBox(height: 4.h),
                  Text('PDF Selected', style: AppTextStyles.bodyMedium),
                ],
              )
                  : Image.file(file!, fit: BoxFit.cover, width: double.infinity),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload_outlined, color: AppColors.kTextHint, size: 32.sp),
                SizedBox(height: 4.h),
                Text('Tap to upload', style: AppTextStyles.hintText),
              ],
            ),
          ),
        ),
      ],
    );
  }
}