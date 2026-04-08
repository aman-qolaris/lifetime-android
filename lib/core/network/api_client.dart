import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_endpoints.dart';
import 'interceptors.dart';

// Riverpod Provider for global access to the configured ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  late final Dio dio;
  late final CookieJar cookieJar;

  ApiClient() {
    // 1. Initialize Dio with Base Options
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          // Dio handles multipart automatically when FormData is passed,
          // but we set json as the default for standard requests.
          'Content-Type': 'application/json',
        },
      ),
    );

    // 2. Initialize In-Memory Cookie Jar
    // (This automatically saves cookies from responses and adds them to requests)
    cookieJar = CookieJar();

    // 3. Add Interceptors
    dio.interceptors.addAll([
      CookieManager(cookieJar),
      AppInterceptor(),
    ]);
  }

  // --- Helper Methods to easily clear cookies on logout ---
  Future<void> clearCookies() async {
    await cookieJar.deleteAll();
  }
}