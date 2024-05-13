import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  TokenInterceptor(this._dio, this._storage);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _storage.read(key: 'accessToken');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
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
          // data: {
          //   "refreshToken": refreshToken,
          // },
        );

        final newAccessToken = response.data['accessToken'];
        await _storage.write(key: 'accessToken', value: newAccessToken);

        // 갱신된 accessToken으로 요청 헤더 업데이트
        options.headers['Authorization'] = 'Bearer $newAccessToken';

        // 원본 요청 재시도
        final clonedRequest = await _dio.request(
          options.path,
          options: Options(
            method: options.method,
            headers: options.headers,
          ),
          data: options.data,
          queryParameters: options.queryParameters,
        );

        return handler.resolve(clonedRequest);
      } catch (e) {
        print('Token refresh failed: $e');
        // 토큰 갱신 실패 시 오류 처리
        return handler.next(err);
      }
    } else {
      return super.onError(err, handler);
    }
  }
}
