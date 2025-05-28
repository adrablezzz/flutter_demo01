import 'dart:io';
import 'package:photo_manager/photo_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_demo01/api/common_api.dart'; // 确保你导入了正确路径
import 'package:flutter_demo01/model/api_result.dart';
import 'package:flutter_demo01/model/response_model.dart';

Future<List<String>> uploadFileList(List<AssetEntity> mediaList) async {
  List<String> mediaPathList = [];
  try {
    for (AssetEntity asset in mediaList) {
      // 获取文件
      File? file = await asset.file;
      if (file == null) continue;

      // 创建 MultipartFile
      MultipartFile multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      );

      // 创建 FormData
      FormData formData = FormData.fromMap({
        'file': multipartFile,
      });

      // 上传
      ApiResult<ResponseModel> result = await CommonApi.upload(formData);

      if (result.isSuccess && result.data?.code == 0) {
        final String url = result.data?.data;
        if(url.isNotEmpty) {
          mediaPathList.add(url);
        }
        print("上传成功：$url");
      } else {
        print("上传失败");
      }
    }
    return mediaPathList;
  } catch (e) {
    print("上传异常: $e");
    return mediaPathList;
  }
}
