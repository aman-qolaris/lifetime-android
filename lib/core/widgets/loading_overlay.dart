import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.kSurfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const CircularProgressIndicator(color: AppColors.kPrimaryColor),
            ),
          ),
      ],
    );
  }
}