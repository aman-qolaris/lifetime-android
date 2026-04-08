import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../../../../core/widgets/empty_error_widget.dart';
import '../viewmodels/edit_application_viewmodel.dart';
import '../viewmodels/admin_dashboard_viewmodel.dart';

class EditApplicationScreen extends ConsumerWidget {
  final String applicantId;

  const EditApplicationScreen({super.key, required this.applicantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final applicantAsync = ref.watch(applicantDetailsProvider(applicantId));

    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Application'),
      body: applicantAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.kPrimaryColor)),
        error: (err, _) => EmptyErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(applicantDetailsProvider(applicantId)),
        ),
        data: (applicantData) {
          // Pass the loaded data to a stateful form so controllers can be initialized once
          return _EditApplicationForm(
            applicantId: applicantId,
            initialData: applicantData['applicant'] ?? applicantData,
          );
        },
      ),
    );
  }
}

// --- Stateful Form for Prepopulating Data ---
class _EditApplicationForm extends ConsumerStatefulWidget {
  final String applicantId;
  final Map<String, dynamic> initialData;

  const _EditApplicationForm({required this.applicantId, required this.initialData});

  @override
  ConsumerState<_EditApplicationForm> createState() => _EditApplicationFormState();
}

class _EditApplicationFormState extends ConsumerState<_EditApplicationForm> {
  late TextEditingController _nameCtrl;
  late TextEditingController _mobileCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _occupationCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialData['fullName'] ?? '');
    _mobileCtrl = TextEditingController(text: widget.initialData['mobileNumber'] ?? '');
    _emailCtrl = TextEditingController(text: widget.initialData['email'] ?? '');
    _occupationCtrl = TextEditingController(text: widget.initialData['occupation'] ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _occupationCtrl.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final updateData = {
      'fullName': _nameCtrl.text.trim(),
      'mobileNumber': _mobileCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'occupation': _occupationCtrl.text.trim(),
    };

    final success = await ref.read(editAppViewModelProvider.notifier).updateApplicant(widget.applicantId, updateData);

    if (success && mounted) {
      CustomSnackBar.showSuccess(context, 'Application updated successfully.');
      ref.invalidate(applicantsListProvider); // Refresh the dashboard list
    } else if (mounted) {
      final error = ref.read(editAppViewModelProvider).error;
      CustomSnackBar.showError(context, error.toString().replaceAll('Exception: ', ''));
    }
  }

  void _handleReview(String action) async {
    final success = await ref.read(editAppViewModelProvider.notifier).reviewApplicant(widget.applicantId, action);

    if (success && mounted) {
      CustomSnackBar.showSuccess(context, 'Application $action successfully.');
      ref.invalidate(applicantsListProvider); // Refresh dashboard
      context.pop(); // Go back to dashboard
    } else if (mounted) {
      final error = ref.read(editAppViewModelProvider).error;
      CustomSnackBar.showError(context, error.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = ref.watch(editAppViewModelProvider).isLoading;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.kPrimaryColor),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Status: ${widget.initialData['status']}',
                    style: AppTextStyles.labelBold.copyWith(color: AppColors.kPrimaryHover),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          CustomTextField(label: 'Full Name', controller: _nameCtrl),
          SizedBox(height: 16.h),
          CustomTextField(label: 'Mobile Number', controller: _mobileCtrl, keyboardType: TextInputType.phone),
          SizedBox(height: 16.h),
          CustomTextField(label: 'Email', controller: _emailCtrl, keyboardType: TextInputType.emailAddress),
          SizedBox(height: 16.h),
          CustomTextField(label: 'Occupation', controller: _occupationCtrl),

          SizedBox(height: 32.h),

          CustomButton(
            text: 'Save Changes',
            isLoading: isProcessing,
            onPressed: _handleSave,
          ),

          SizedBox(height: 32.h),
          const Divider(),
          SizedBox(height: 16.h),
          Text('Admin Actions', style: AppTextStyles.h2Bold),
          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Reject',
                  variant: ButtonVariant.outlined,
                  isLoading: isProcessing,
                  onPressed: () => _handleReview('REJECTED'),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomButton(
                  text: 'Approve',
                  isLoading: isProcessing,
                  onPressed: () => _handleReview('APPROVED'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}