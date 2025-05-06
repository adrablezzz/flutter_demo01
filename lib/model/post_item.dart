class PostItem {
  final int id;
  final String userAvatar;
  final String userName;
  final String postTime;
  final String postContent;
  final String postImage;
  final int likeCount;
  final int commentCount;
  final int dislikeCount;

  PostItem({
    required this.id,
    required this.userAvatar,
    required this.userName,
    required this.postTime,
    required this.postContent,
    required this.postImage,
    this.likeCount = 0,
    this.commentCount = 0,
    this.dislikeCount = 0,
  });

  factory PostItem.fromJson(Map<String, dynamic> json) {
    try {
      return PostItem(
        id: json['id'] as int? ?? 0,
        userAvatar: json['userAvatar'] as String? ?? '',
        userName: json['userName'] as String? ?? '',
        postTime: json['postTime'] as String? ?? '',
        postContent: json['postContent'] as String? ?? '',
        postImage: json['postImage'] as String? ?? '',
        likeCount: _parseInt(json['likeCount']),
        commentCount: _parseInt(json['commentCount']),
        dislikeCount: _parseInt(json['dislikeCount']),
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
