/*
 * @Date: 2025-05-20 17:04:02
 * @LastEditTime: 2025-05-20 17:10:13
 */
import 'package:dio/dio.dart';
import 'package:flutter_demo01/model/response_model.dart';
import 'package:flutter_demo01/model/api_result.dart';
import 'package:flutter_demo01/utils/dio_client.dart';


class CommonApi {
  // 上传文件
  static Future<ApiResult<ResponseModel>> upload(FormData formData) async {
    return await DioClient().postAndParse(
      '/api/portal/v1/qiniu/upload',
      fromJson: (json) => ResponseModel.fromJson(json),
      data: formData,
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    );
  }
}
