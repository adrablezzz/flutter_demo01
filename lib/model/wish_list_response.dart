import 'dart:convert';

WishListResponse wishListResponseFromJson(String str) =>
    WishListResponse.fromJson(json.decode(str));

String wishListResponseToJson(WishListResponse data) =>
    json.encode(data.toJson());

class WishListResponse {
  int pageSize;
  int pageNo;
  int totalCount;
  int totalPage;
  List<WishItem> data;

  WishListResponse({
    required this.pageSize,
    required this.pageNo,
    required this.totalCount,
    required this.totalPage,
    required this.data,
  });

  factory WishListResponse.fromJson(Map<String, dynamic> json) =>
      WishListResponse(
        pageSize: json["pageSize"],
        pageNo: json["pageNo"],
        totalCount: json["totalCount"],
        totalPage: json["totalPage"],
        data: List<WishItem>.from(
          json["data"].map((x) => WishItem.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "pageSize": pageSize,
    "pageNo": pageNo,
    "totalCount": totalCount,
    "totalPage": totalPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class WishItem {
  int id;
  int signId;
  String content;
  dynamic signPicUrl;
  int memberId;
  String memberName;
  String memberPicUrl;
  String wishType;
  String createTime;
  int likeCount;
  int downCount;
  String wishSource;
  String heatValueSort;
  String postContent;
  dynamic postPicUrl;
  List<String> postPicUrlList;
  int wishAddressId;
  String wishAddressName;
  dynamic operate; // '0'点赞 '1'点踩 null无
  String permission;
  int commentCount;
  String sourceMemberRelationShip; // '0'未关注 '1'关注
  dynamic imgUrl;

  WishItem({
    required this.id,
    required this.signId,
    required this.content,
    required this.signPicUrl,
    required this.memberId,
    required this.memberName,
    required this.memberPicUrl,
    required this.wishType,
    required this.createTime,
    required this.likeCount,
    required this.downCount,
    required this.wishSource,
    required this.heatValueSort,
    required this.postContent,
    required this.postPicUrl,
    required this.postPicUrlList,
    required this.wishAddressId,
    required this.wishAddressName,
    required this.operate,
    required this.permission,
    required this.commentCount,
    required this.sourceMemberRelationShip,
    required this.imgUrl,
  });

  factory WishItem.fromJson(Map<String, dynamic> json) => WishItem(
    id: json["id"],
    signId: json["signId"],
    content: json["content"],
    signPicUrl: json["signPicUrl"],
    memberId: json["memberId"],
    memberName: json["memberName"],
    memberPicUrl: json["memberPicUrl"],
    wishType: json["wishType"],
    createTime: json["createTime"],
    likeCount: json["likeCount"],
    downCount: json["downCount"],
    wishSource: json["wishSource"],
    heatValueSort: json["heatValueSort"],
    postContent: json["postContent"],
    postPicUrl: json["postPicUrl"],
    postPicUrlList: List<String>.from(json["postPicUrlList"].map((x) => x)),
    wishAddressId: json["wishAddressId"],
    wishAddressName: json["wishAddressName"],
    operate: json["operate"],
    permission: json["permission"],
    commentCount: json["commentCount"],
    sourceMemberRelationShip: json["sourceMemberRelationShip"],
    imgUrl: json["imgUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "signId": signId,
    "content": content,
    "signPicUrl": signPicUrl,
    "memberId": memberId,
    "memberName": memberName,
    "memberPicUrl": memberPicUrl,
    "wishType": wishType,
    "createTime": createTime,
    "likeCount": likeCount,
    "downCount": downCount,
    "wishSource": wishSource,
    "heatValueSort": heatValueSort,
    "postContent": postContent,
    "postPicUrl": postPicUrl,
    "postPicUrlList": List<String>.from(postPicUrlList.map((x) => x)),
    "wishAddressId": wishAddressId,
    "wishAddressName": wishAddressName,
    "operate": operate,
    "permission": permission,
    "commentCount": commentCount,
    "sourceMemberRelationShip": sourceMemberRelationShip,
    "imgUrl": imgUrl,
  };
}

extension WishListExtension on WishListResponse {
  // 更新关注状态
  void updateFollowStatusByMember(int memberId, String relation) {
    data.forEach((item) {
      if (item.memberId == memberId) {
        item.sourceMemberRelationShip = relation;
      }
    });
  }

  // 更新点赞/踩状态
  void updateOperateStatusByWish(int id, String? newOperate) {
    final wishItem = data.firstWhere((item) => item.id == id);
    print('更新点赞/踩状态：${wishItem.operate} $newOperate');
    if (wishItem == null) {
      return;
    }
    // 点赞
    if(newOperate == '0') {
      wishItem.likeCount++;
      if(wishItem.operate == '1') { // 如果之前点踩过取消点踩
        wishItem.downCount--;
      }
    } else if(newOperate == '1') { // 点踩
      wishItem.downCount--;
      if(wishItem.operate == '0') {// 如果之前点赞过取消点赞
        wishItem.likeCount--;
      }
    } else if(newOperate == null) { // 取消点赞/点踩
      if(wishItem.operate == '0') { // 如果之前点赞过取消点赞
        wishItem.likeCount--;
      } else if(wishItem.operate == '1') { // 如果之前点踩过取消点踩
        wishItem.downCount--;
      }
    }
    wishItem.operate = newOperate;
    print('更新后的状态： ${wishItem.operate}');
  }
}
