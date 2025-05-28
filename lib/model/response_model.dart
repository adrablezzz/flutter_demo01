class ResponseModel<T> {
  final int code;
  final T? data;
  final String msg;
  final String emsg;

  ResponseModel({
    required this.code,
    required this.data,
    required this.msg,
    required this.emsg,
  });

  factory ResponseModel.fromJson(
    Map<String, dynamic> json,
    {T Function(dynamic json)? fromJsonT}
  ) {
    try {
      return ResponseModel<T>(
        code: json['code'] as int? ?? 1,
        data: json['data'] != null
          ? (fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T)
          : null,
        msg: json['msg'] as String? ?? '',
        emsg: json['emsg'] as String? ?? '',
      );
    } catch (e) {
      throw FormatException('Invalid JSON format: $e');
    }
  }

  @override
  String toString() {
    return 'ResponseModel{code: $code, data: $data, msg: $msg, emsg: $emsg}';
  }
}
