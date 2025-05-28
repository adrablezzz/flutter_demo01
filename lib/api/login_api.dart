/*
 * @Date: 2025-05-13 15:24:00
 * @LastEditTime: 2025-05-17 10:39:15
 */
import 'package:flutter_demo01/model/response_model.dart';
import 'package:flutter_demo01/model/api_result.dart';
import 'package:flutter_demo01/utils/dio_client.dart';
import 'package:flutter_demo01/model/user.dart';

class LoginApi {
  //发送验证码
  static Future<ApiResult<ResponseModel>> sendVerifyCode(String phone) async {
    return await DioClient().getAndParse(
      '/auth/open/sendRegisterCode',
      fromJson: (json) => ResponseModel.fromJson(json),
      queryParameters: {'cellPhone': phone},
    );
  }

  //登录
  static Future<ApiResult<User>> loginBySms(String phone, String code) async {
    return await DioClient().postAndParse(
      '/auth/oauth/token',
      fromJson: (json) => User.fromJson(json),
      data: {'phone': phone, 'code': code},
      queryParameters: {
        'grant_type': 'sms',
      },
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
  }
}
