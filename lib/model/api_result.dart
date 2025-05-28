// api_result.dart
class ApiResult<T> {
  final T? data;
  final String? error;

  bool get isSuccess => data != null;

  ApiResult.success(this.data) : error = null;
  ApiResult.failure(this.error) : data = null;
}
