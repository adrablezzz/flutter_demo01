import 'package:dio/dio.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio _dio;

  DioClient._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://your-api-base-url.com/', // 换成你自己的
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    _dio = Dio(options);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Request error: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  /// 基础 GET 请求
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  /// 基础 POST 请求
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  /// 自动解析的 GET 请求
  Future<T> getAndParse<T>(String path, {required FromJson<T> fromJson, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await get(path, queryParameters: queryParameters);
      if (response.statusCode == 200 && response.data != null) {
        return fromJson(Map<String, dynamic>.from(response.data));
      } else {
        throw Exception('Failed to parse data');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 自动解析的 POST 请求
  Future<T> postAndParse<T>(String path, {required FromJson<T> fromJson, Map<String, dynamic>? data}) async {
    try {
      final response = await post(path, data: data);
      if (response.statusCode == 200 && response.data != null) {
        return fromJson(Map<String, dynamic>.from(response.data));
      } else {
        throw Exception('Failed to parse data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
