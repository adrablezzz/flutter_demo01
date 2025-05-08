import 'package:dio/dio.dart';
import 'package:flutter_demo01/model/response_model.dart';
import 'package:flutter_demo01/model/api_result.dart';
import 'package:flutter_demo01/utils/dio_client.dart';

class LoginApi {
  //发送验证码
  static Future<ApiResult<ResponseModel>> sendVerifyCode(String phone) async {
    return await DioClient().getAndParse(
      '/auth/open/sendRegisterCode',
      fromJson: (json) => ResponseModel.fromJson(json),
      queryParameters: {'cellPhone': phone},
    );
  }

  //登录111
  static Future<ApiResult<ResponseModel>> loginBySms(String phone, String code) async {
    return await DioClient().postAndParse(
      '/auth/oauth/token',
      fromJson: (json) => ResponseModel.fromJson(json),
      data: {'phone': phone, 'code': code},
      queryParameters: {
        'grant_type': 'sms',
      },
    );
  }
}
