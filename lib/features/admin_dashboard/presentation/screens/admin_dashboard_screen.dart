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
import '../../../admin_auth/data/admin_auth_repository.dart';
import '../viewmodels/admin_dashboard_viewmodel.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const _ApplicantsTab(),
    const _MembersTab(),
    const _SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Admin Dashboard',
        showBackButton: false,
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.logout, color: AppColors.kErrorColor),
                onPressed: () async {
                  await ref.read(adminAuthRepositoryProvider).logout();
                  if (context.mounted) context.go('/admin/login');
                },
              );
            },
          )
        ],
      ),
      body: SafeArea(child: _tabs[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.kPrimaryColor,
        unselectedItemColor: AppColors.kTextHint,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_add_alt_1), label: 'Applicants'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Members'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// --- TAB WIDGETS ---

class _ApplicantsTab extends ConsumerWidget {
  const _ApplicantsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicantsState = ref.watch(applicantsListProvider);

    return applicantsState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
      ),
      error: (err, _) => EmptyErrorWidget(
        message: err.toString(),
        onRetry: () => ref.refresh(applicantsListProvider),
      ),
      data: (applicants) {
        if (applicants.isEmpty) {
          return const EmptyErrorWidget(
            message: 'No pending applicants.',
            icon: Icons.inbox,
          );
        }
        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: applicants.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: 12.h), // ✅ fixed
          itemBuilder: (context, index) {
            final Map<String, dynamic> applicant = applicants[index]; // ✅ safer typing
            return ListTile(
              tileColor: AppColors.kSurfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              title: Text(
                applicant['fullName'] ?? 'Unknown',
                style: AppTextStyles.labelBold,
              ),
              subtitle: Text(
                applicant['status'] ?? 'Pending',
                style: AppTextStyles.bodyMedium,
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.kPrimaryColor,
              ),
              onTap: () =>
                  context.push('/edit-application/${applicant['id']}'),
            );
          },
        );
      },
    );
  }
}

class _MembersTab extends ConsumerWidget {
  const _MembersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersState = ref.watch(membersListProvider);

    return membersState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
      ),
      error: (err, _) => EmptyErrorWidget(
        message: err.toString(),
        onRetry: () => ref.refresh(membersListProvider),
      ),
      data: (members) {
        if (members.isEmpty) {
          return const EmptyErrorWidget(
            message: 'No members found.',
            icon: Icons.group_off,
          );
        }
        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: members.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: 12.h), // ✅ fixed
          itemBuilder: (context, index) {
            final Map<String, dynamic> member = members[index]; // ✅ safer typing
            return ListTile(
              tileColor: AppColors.kSurfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              title: Text(
                member['fullName'] ?? 'Unknown',
                style: AppTextStyles.labelBold,
              ),
              subtitle: Text(
                member['registrationNumber'] ?? 'No Reg No.',
                style: AppTextStyles.bodyMedium,
              ),
              leading: const CircleAvatar(
                backgroundColor: AppColors.kPrimaryLight,
                child: Icon(Icons.person, color: AppColors.kPrimaryColor),
              ),
            );
          },
        );
      },
    );
  }
}

class _SettingsTab extends ConsumerStatefulWidget {
  const _SettingsTab();

  @override
  ConsumerState<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<_SettingsTab> {
  final _feeController = TextEditingController();

  @override
  void dispose() {
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feeState = ref.watch(feeUpdateViewModelProvider);

    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('System Settings', style: AppTextStyles.h2Bold),
          SizedBox(height: 24.h),
          CustomTextField(
            label: 'Update Membership Fee (₹)',
            controller: _feeController,
            keyboardType: TextInputType.number,
            hintText: 'e.g. 5000',
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Save Changes',
            isLoading: feeState.isLoading,
            onPressed: () async {
              final amount = double.tryParse(_feeController.text);
              if (amount == null) {
                CustomSnackBar.showError(
                    context, 'Please enter a valid amount');
                return;
              }
              final success = await ref
                  .read(feeUpdateViewModelProvider.notifier)
                  .updateFee(amount);

              if (success && context.mounted) {
                CustomSnackBar.showSuccess(
                    context, 'Fee updated successfully!');
                _feeController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}