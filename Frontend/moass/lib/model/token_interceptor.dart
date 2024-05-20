import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  TokenInterceptor(this._dio, this._storage);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken != null) {
      options.headers['Authorization'] = 'Bearer $refreshToken';
    }
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      RequestOptions options = err.requestOptions;
      final refreshToken = await _storage.read(key: 'refreshToken');

      try {
        final response = await _dio.post(
          'https://k10e203.p.ssafy.io/api/user/refresh',
          options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
        );

        final newAccessToken = response.data['data']['accessToken'];
        final newRefreshToken = response.data['data']['refreshToken'];
        await _storage.write(key: 'accessToken', value: newAccessToken);
        await _storage.write(key: 'refreshToken', value: newRefreshToken);

        // 갱신된 accessToken으로 요청 헤더 업데이트
        options.headers['Authorization'] = 'Bearer $newAccessToken';
      } catch (e) {
        // print('Token refresh failed: $e');
        return handler.next(err);
      }
    } else {
      return super.onError(err, handler);
    }
  }
}
