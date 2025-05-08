import 'package:dio/dio.dart';
import 'package:flutter_demo01/utils/utils.dart';
import 'package:flutter_demo01/model/api_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio _dio;

  DioClient._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://testsgmj.linkon.me:8090/base', // 换成你自己的
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
    );

    _dio = Dio(options);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 在请求前动态获取 token 并添加到请求头
          String? token = await _getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token'; // 添加 token 到请求头
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('Request error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  // 获取 token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // 从 shared_preferences 中获取 token
  }

  void handleDioError(dynamic error) {
    if (error is DioException) {
      print('Request error: ${error.message}');
      print('Error type: ${error.type}');
      if (error.response != null) {
        print('Response status code: ${error.response?.statusCode}');
        print('Response data: ${error.response?.data}');
        print('消息: ${error.response?.data['msg']}');

        // toast显示
        showToast(error.response?.data['msg'] ?? '网络异常');
      }
      if (error.requestOptions != null) {
        print('Request path: ${error.requestOptions.path}');
        print('Request headers: ${error.requestOptions.headers}');
        print('Request data: ${error.requestOptions.data}');
      }
    } else {
      print('Unknown error: $error');
    }
  }

  /// 基础 GET 请求
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  /// 基础 POST 请求
  Future<Response> post(String path, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  /// 自动解析的 GET 请求
  Future<ApiResult<T>> getAndParse<T>(
    String path, {
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await get(path, queryParameters: queryParameters);
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final parsed = fromJson(response.data);
        return ApiResult.success(parsed);
      } else {
        return ApiResult.failure('Invalid response format');
      }
    } catch (e) {
      handleDioError(e); // 仍然打印或上报错误
      return ApiResult.failure('Request failed: $e');
    }
  }

  /// 自动解析的 POST 请求
  Future<ApiResult<T>> postAndParse<T>(
    String path, {
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await post(path, data: data);

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final parsed = fromJson(response.data);
        return ApiResult.success(parsed);
      } else {
        return ApiResult.failure('Invalid response format');
      }
    } catch (e) {
      handleDioError(e); // 记录错误日志
      return ApiResult.failure('Request failed: $e');
    }
  }
}
