import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final adminAuthRepositoryProvider = Provider<AdminAuthRepository>((ref) {
  return AdminAuthRepository(ref.read(apiClientProvider));
});

class AdminAuthRepository {
  final ApiClient _apiClient;

  AdminAuthRepository(this._apiClient);

  Future<void> login(String phoneNumber, String password) async {
    try {
      await _apiClient.dio.post(
        ApiEndpoints.adminLogin,
        data: {
          'phone_number': phoneNumber,
          'password': password,
        },
      );
      // If it reaches here (status 200), login is successful and the cookie is set.
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Login failed. Please check your credentials.';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> logout() async {
    // Clear the HTTP-only cookies from the cookie jar to log out
    await _apiClient.clearCookies();
  }
}