import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../../../../core/widgets/empty_error_widget.dart';
import '../viewmodels/payment_viewmodel.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String? applicantId;

  const PaymentScreen({super.key, this.applicantId});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  late Razorpay _razorpay;
  final _idController = TextEditingController();
  String? _activeApplicantId;

  @override
  void initState() {
    super.initState();
    _activeApplicantId = widget.applicantId;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _idController.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final success = await ref.read(paymentProcessorProvider.notifier).verifySignature({
      'razorpay_payment_id': response.paymentId,
      'razorpay_order_id': response.orderId,
      'razorpay_signature': response.signature,
      'applicant_id': _activeApplicantId,
    });

    if (success && mounted) {
      CustomSnackBar.showSuccess(context, 'Payment Successful! You are now a Member.');
      context.go('/success'); // Or a specific payment success route
    } else if (mounted) {
      CustomSnackBar.showError(context, 'Payment verification failed on our server.');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CustomSnackBar.showError(context, 'Payment Failed: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    CustomSnackBar.showSuccess(context, 'External Wallet Selected: ${response.walletName}');
  }

  void _startPayment(double feeAmount) async {
    if (_activeApplicantId == null) return;

    final orderData = await ref.read(paymentProcessorProvider.notifier).initializeOrder(_activeApplicantId!);
    if (orderData == null) {
      if (mounted) {
        final error = ref.read(paymentProcessorProvider).error;
        CustomSnackBar.showError(context, error.toString().replaceAll('Exception: ', ''));
      }
      return;
    }

    var options = {
      'key': orderData['key'],
      'amount': orderData['order']['amount'],
      'name': 'Maharashtra Mandal',
      'description': 'Lifetime Membership Fee',
      'order_id': orderData['order']['id'],
      'prefill': {
        'contact': orderData['applicant']['mobileNumber'] ?? '',
        'email': orderData['applicant']['email'] ?? ''
      },
      'theme': {
        'color': '#EA580C' // AppColors.kPrimaryColor in HEX
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no ID is provided via deep link, ask the user to input their Application ID
    if (_activeApplicantId == null || _activeApplicantId!.isEmpty) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Check Payment Status'),
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                label: 'Application ID',
                hintText: 'Enter your application ID sent via email',
                controller: _idController,
              ),
              SizedBox(height: 24.h),
              CustomButton(
                text: 'Check Status',
                onPressed: () {
                  if (_idController.text.trim().isNotEmpty) {
                    setState(() {
                      _activeApplicantId = _idController.text.trim();
                    });
                  }
                },
              )
            ],
          ),
        ),
      );
    }

    final statusAsync = ref.watch(paymentStatusProvider(_activeApplicantId!));
    final feeAsync = ref.watch(paymentFeeProvider);
    final isProcessing = ref.watch(paymentProcessorProvider).isLoading;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Membership Payment',
        showBackButton: widget.applicantId == null,
      ),
      body: statusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.kPrimaryColor)),
        error: (err, _) => EmptyErrorWidget(
          message: err.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref.refresh(paymentStatusProvider(_activeApplicantId!)),
        ),
        data: (applicant) {
          final status = applicant['status'];

          if (status != 'PAYMENT_PENDING') {
            return EmptyErrorWidget(
              message: 'Your application status is: $status.\nYou cannot make a payment at this time.',
              icon: Icons.info_outline,
              onRetry: () => setState(() => _activeApplicantId = null), // Reset to enter ID again
            );
          }

          return feeAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.kPrimaryColor)),
            error: (err, _) => const EmptyErrorWidget(message: 'Failed to load fee amount.'),
            data: (feeAmount) {
              return Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: AppColors.kSurfaceColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.kBorderDefault),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.payment, size: 48.sp, color: AppColors.kPrimaryColor),
                          SizedBox(height: 16.h),
                          Text('Membership Fee', style: AppTextStyles.labelBold.copyWith(color: AppColors.kTextHint)),
                          SizedBox(height: 8.h),
                          Text('₹${feeAmount.toStringAsFixed(2)}', style: AppTextStyles.h1Extrabold),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    _buildDetailRow('Name', applicant['fullName']),
                    _buildDetailRow('Mobile', applicant['mobileNumber']),
                    _buildDetailRow('Email', applicant['email']),

                    const Spacer(),

                    CustomButton(
                      text: 'Pay Now',
                      isLoading: isProcessing,
                      onPressed: () => _startPayment(feeAmount),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(value ?? 'N/A', style: AppTextStyles.labelBold),
        ],
      ),
    );
  }
}