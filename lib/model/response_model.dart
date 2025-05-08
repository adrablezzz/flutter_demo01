class ResponseModel {
  final int code;
  final dynamic data;
  final String msg;
  final String emsg;

  ResponseModel({
    required this.code,
    required this.data,
    required this.msg,
    required this.emsg,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return ResponseModel(
        code: json['code'] as int? ?? 1,
        data: json['data'] as dynamic,
        msg: json['msg'] as String? ?? '',
        emsg: json['emsg'] as String? ?? '',
      );
    } catch (e) {
      throw FormatException('Invalid JSON format: $e');
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
