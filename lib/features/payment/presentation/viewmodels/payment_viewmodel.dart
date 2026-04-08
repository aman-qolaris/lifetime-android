import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/payment_repository.dart';

final paymentFeeProvider = FutureProvider.autoDispose<double>((ref) async {
  return ref.read(paymentRepositoryProvider).getMembershipFee();
});

final paymentStatusProvider = FutureProvider.family.autoDispose<Map<String, dynamic>, String>((ref, applicantId) async {
  return ref.read(paymentRepositoryProvider).getPaymentStatus(applicantId);
});

final paymentProcessorProvider = StateNotifierProvider<PaymentProcessorViewModel, AsyncValue<void>>((ref) {
  return PaymentProcessorViewModel(ref.read(paymentRepositoryProvider));
});

class PaymentProcessorViewModel extends StateNotifier<AsyncValue<void>> {
  final PaymentRepository _repository;

  PaymentProcessorViewModel(this._repository) : super(const AsyncData(null));

  Future<Map<String, dynamic>?> initializeOrder(String applicantId) async {
    state = const AsyncLoading();
    try {
      final orderData = await _repository.createOrder(applicantId);
      state = const AsyncData(null);
      return orderData;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> verifySignature(Map<String, dynamic> paymentDetails) async {
    state = const AsyncLoading();
    try {
      await _repository.verifyPayment(paymentDetails);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}