import 'dart:convert';

WishCommentResponse wishCommentResponseFromJson(String str) => WishCommentResponse.fromJson(json.decode(str));

String wishCommentResponseToJson(WishCommentResponse data) => json.encode(data.toJson());

class WishCommentResponse {
    int pageSize;
    int pageNo;
    int totalCount;
    int totalPage;
    List<Datum> data;

    WishCommentResponse({
        required this.pageSize,
        required this.pageNo,
        required this.totalCount,
        required this.totalPage,
        required this.data,
    });

    factory WishCommentResponse.fromJson(Map<String, dynamic> json) => WishCommentResponse(
        pageSize: json["pageSize"],
        pageNo: json["pageNo"],
        totalCount: json["totalCount"],
        totalPage: json["totalPage"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pageSize": pageSize,
        "pageNo": pageNo,
        "totalCount": totalCount,
        "totalPage": totalPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    int wishId;
    int targetMemberId;
    String targetMemberName;
    String targetMemberPic;
    int sourceMemberId;
    String sourceMemberName;
    String sourceMemberPic;
    int parentId;
    String contents;
    int likeCount;
    int replyCount;
    String createTime;
    String commentsType;
    dynamic operate; // 操作 0点赞 1点踩 null无
    // 固定参数
    bool isExpend = false; // 是否展开
    List<Datum> children = []; // 子评论列表

    Datum({
        required this.id,
        required this.wishId,
        required this.targetMemberId,
        required this.targetMemberName,
        required this.targetMemberPic,
        required this.sourceMemberId,
        required this.sourceMemberName,
        required this.sourceMemberPic,
        required this.parentId,
        required this.contents,
        required this.likeCount,
        required this.replyCount,
        required this.createTime,
        required this.commentsType,
        required this.operate,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        wishId: json["wishId"],
        targetMemberId: json["targetMemberId"],
        targetMemberName: json["targetMemberName"],
        targetMemberPic: json["targetMemberPic"],
        sourceMemberId: json["sourceMemberId"],
        sourceMemberName: json["sourceMemberName"],
        sourceMemberPic: json["sourceMemberPic"],
        parentId: json["parentId"],
        contents: json["contents"],
        likeCount: json["likeCount"],
        replyCount: json["replyCount"],
        createTime: json["createTime"],
        commentsType: json["commentsType"],
        operate: json["operate"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "wishId": wishId,
        "targetMemberId": targetMemberId,
        "targetMemberName": targetMemberName,
        "targetMemberPic": targetMemberPic,
        "sourceMemberId": sourceMemberId,
        "sourceMemberName": sourceMemberName,
        "sourceMemberPic": sourceMemberPic,
        "parentId": parentId,
        "contents": contents,
        "likeCount": likeCount,
        "replyCount": replyCount,
        "createTime": createTime,
        "commentsType": commentsType,
        "operate": operate,
    };
}
