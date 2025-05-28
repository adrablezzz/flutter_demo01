import 'package:flutter_demo01/model/response_model.dart';
import 'package:flutter_demo01/model/api_result.dart';
import 'package:flutter_demo01/utils/dio_client.dart';
import 'package:flutter_demo01/model/wish_list_response.dart';
import 'package:flutter_demo01/model/wish_comment_response.dart';


class WishApi {
  // 获取许愿列表
  static Future<ApiResult<ResponseModel<WishListResponse>>> getWishList(Map<String, dynamic> params) async {
    return await DioClient().postAndParse(
      '/api/portal/v1/wish/getWishList',
      fromJson: (json) => ResponseModel.fromJson(json, fromJsonT: (dataJson) => WishListResponse.fromJson(dataJson)),
      data: params,
    );
  }
  // 许愿
  static Future<ApiResult<ResponseModel>> saveWish(Map<String, dynamic> params) async {
    return await DioClient().postAndParse(
      '/api/portal/v1/wish/saveWish',
      fromJson: (json) => ResponseModel.fromJson(json),
      data: params,
    );
  }
  
  // 关注
  static Future<ApiResult<ResponseModel>> follow(int memberId) async {
    return await DioClient().postAndParse(
      '/api/portal/v1/member/addRelationShip',
      fromJson: (json) => ResponseModel.fromJson(json),
      data: {
        'memberId': memberId,
      },
    );
  }
  // 取消关注
  static Future<ApiResult<ResponseModel>> cancelFollow(int memberId) async {
    return await DioClient().postAndParse(
      '/api/portal/v1/member/deleteRelationShip',
      fromJson: (json) => ResponseModel.fromJson(json),
      data: {
        'memberId': memberId,
      },
    );
  }
  // 黑名单操作 optionType	操作类型 0 删除黑名单 1 添加黑名单
  static Future<ApiResult<ResponseModel>> blacklistOption(int tatgetMemberId, String optionType) async {
    return await DioClient().postAndParse(
      '/api/portal/v1/member/blacklistOption',
      fromJson: (json) => ResponseModel.fromJson(json),
      data: {
        "optionType": optionType,
        "tatgetMemberId": tatgetMemberId
      },
    );
  }
  // 点赞
  static Future<ApiResult<ResponseModel>> wishLick(int wishId) async {
    return await DioClient().getAndParse(
      '/api/portal/v1/wish/wishLike/$wishId',
      fromJson: (json) => ResponseModel.fromJson(json),
    );
  }
  // 取消点赞
  static Future<ApiResult<ResponseModel>> wishCancelLike(int wishId) async {
    return await DioClient().getAndParse(
      '/api/portal/v1/wish/wishCancelLike/$wishId',
      fromJson: (json) => ResponseModel.fromJson(json),
    );
  }
  // 点踩
  static Future<ApiResult<ResponseModel>> wishDislike(int wishId) async {
    return await DioClient().getAndParse(
      '/api/portal/v1/wish/wishDown/$wishId',
      fromJson: (json) => ResponseModel.fromJson(json),
    );
  }
  // 取消点踩
  static Future<ApiResult<ResponseModel>> wishCancelDislike(int wishId) async {
    return await DioClient().getAndParse(
      '/api/portal/v1/wish/wishCancelDown/$wishId',
      fromJson: (json) => ResponseModel.fromJson(json),
    );
  }

  // 获取评论列表
  static Future<ApiResult<ResponseModel<WishCommentResponse>>> getWishCommentsPaged(Map<String, dynamic> params) async {
    return await DioClient().postAndParse(
      '/api/portal/v1/wishComments/getWishCommentsPaged',
      fromJson: (json) => ResponseModel.fromJson(json, fromJsonT: (dataJson) => WishCommentResponse.fromJson(dataJson)),
      data: params,
    );
  }
  // 点赞评论
  static Future<ApiResult<ResponseModel>> commentLike(int commentId) async {
    return await DioClient().getAndParse(
      '/api/portal/v1/wishComments/commentLike/$commentId',
      fromJson: (json) => ResponseModel.fromJson(json),
    );
  }
  // 取消点赞评论
  static Future<ApiResult<ResponseModel>> commentCancelLike(int commentId) async {
    return await DioClient().getAndParse(
      '/api/portal/v1/wishComments/commentCancelLike/$commentId',
      fromJson: (json) => ResponseModel.fromJson(json),
    );
  }
  // 点踩评论
  static Future<ApiResult<ResponseModel>> commentDown(int commentId) async {
    return await DioClient().getAndParse(
      '/api/portal/v1/wishComments/commentDown/$commentId',
      fromJson: (json) => ResponseModel.fromJson(json),
    );
  }
  // 取消点踩评论
  static Future<ApiResult<ResponseModel>> commentCancelDown(int commentId) async {
    return await DioClient().getAndParse(
      '/api/portal/v1/wishComments/commentCancelDown/$commentId',
      fromJson: (json) => ResponseModel.fromJson(json),
    );
  }
  // 新增评论(回复)
  static Future<ApiResult<ResponseModel>> addWishComment(dynamic params) async {
    return await DioClient().postAndParse(
      '/api/portal/v1/wishComments/save',
      fromJson: (json) => ResponseModel.fromJson(json),
      data: params,
    );
  }
}
