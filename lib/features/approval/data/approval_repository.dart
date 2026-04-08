import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final approvalRepositoryProvider = Provider<ApprovalRepository>((ref) {
  return ApprovalRepository(ref.read(apiClientProvider));
});

class ApprovalRepository {
  final ApiClient _apiClient;

  ApprovalRepository(this._apiClient);

  Future<Map<String, dynamic>> fetchApprovalDetails(String token, String role) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.verifyApprovalToken(token, role),
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Invalid or expired token.');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> submitApproval(String role, String token, String action) async {
    try {
      await _apiClient.dio.post(
        ApiEndpoints.submitApproval(role),
        data: {
          'token': token,
          'action': action, // 'APPROVED' or 'REJECTED'
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to submit action.');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }
}