import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(ref.read(apiClientProvider));
});

class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  Future<Map<String, dynamic>> getPaymentStatus(String applicantId) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.getPaymentStatus(applicantId));
      return response.data['data'] ?? response.data;
    } catch (e) {
      throw Exception('Failed to fetch payment status.');
    }
  }

  Future<double> getMembershipFee() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.getFee);
      final amount = response.data['data']['amount'] ?? response.data['amount'];
      return double.parse(amount.toString());
    } catch (e) {
      throw Exception('Failed to fetch membership fee.');
    }
  }

  Future<Map<String, dynamic>> createOrder(String applicantId) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.createOrder,
        data: {'applicant_id': applicantId},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create order.');
    }
  }

  Future<void> verifyPayment(Map<String, dynamic> paymentData) async {
    try {
      await _apiClient.dio.post(
        ApiEndpoints.verifyPayment,
        data: paymentData,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Payment verification failed.');
    }
  }
}