import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor {
  final Dio _dio;
  final SharedPreferences _prefs;

  TokenInterceptor(this._dio, this._prefs);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = _prefs.getString('accessToken');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // 401 Unauthorized 에러를 캐치
    if (err.response?.statusCode == 401) {
      final refreshToken = _prefs.getString('refreshToken');
      final dio = Dio(); // 새 Dio 인스턴스 생성

      try {
        // refreshToken으로 새 accessToken을 요청
        final response = await dio.post(
          'https://k10e203.p.ssafy.io/api/user/refresh',
          data: {
            "refreshToken": refreshToken,
          },
        );

        // 새로운 토큰 저장
        final newAccessToken = response.data['accessToken'];
        await _prefs.setString('accessToken', newAccessToken);

        // 원래 요청을 새 토큰으로 업데이트하여 재시도
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final opts = Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
        );
        final clonedRequest = await _dio.request(
          err.requestOptions.path,
          options: opts,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );

        return handler.resolve(clonedRequest);
      } catch (e) {
        // 토큰 갱신 실패
        return handler.next(err);
      }
    }

    return super.onError(err, handler);
  }
}
