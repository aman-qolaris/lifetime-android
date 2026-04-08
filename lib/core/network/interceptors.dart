import 'dart:developer';
import 'package:dio/dio.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('🌐 [REQ] [${options.method}] ${options.uri}');
    // We can add global headers here if needed (e.g., Accept-Language)
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('✅ [RES] [${response.statusCode}] ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    log('❌ [ERR] [$statusCode] ${err.requestOptions.uri}');

    if (err.response?.data != null) {
      log('❌ [ERR DATA]: ${err.response?.data}');
    }

    // Handle session expiry globally
    if (statusCode == 401 || statusCode == 403) {
      log('⚠️ Unauthorized! Session expired or invalid role.');
      // NOTE: We will handle the actual navigation redirect to /admin/login
      // in the repository or auth viewmodel layer when this specific error is caught.
    }

    super.onError(err, handler);
  }
}