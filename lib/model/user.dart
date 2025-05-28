class User {
  int id;
  String username;
  String token;
  String nickName;
  String avatar;

  User({
    this.id = 0,
    this.username = '',
    this.token = '',
    this.nickName = '',
    this.avatar = '',
  });

  
  // 将 User 对象转为 Map，方便存储到 SharedPreferences
  Map<String, String> toMap() {
    return {
      'id': id.toString(),
      'username': username,
      'token': token,
      'nickName': nickName,
      'avatar': avatar,
      // 添加更多字段
    };
  }

  // 从 Map 中创建 User 对象
  factory User.fromMap(Map<String, String> map) {
    return User(
      id: int.tryParse(map['id'].toString()) ?? 0,
      username: map['username'] ?? '',
      token: map['token'] ?? '',
      nickName: map['nickName'] ?? '',
      avatar: map['avatar'] ?? '',
      // 读取更多字段
    );
  }

  // 从 json 中创建 User 对象
  factory User.fromJson(Map<String, dynamic> json) {
    // json: {token: '', user_info: { id: 1, username: '', nickName: '', avatar: '' }}
    final userInfo = json['user_info'] as Map<String, dynamic>? ?? {};
    
    return User(
      id: int.tryParse(userInfo['id'].toString()) ?? 0,
      username: userInfo['username'] ?? '',
      token: json['access_token'] ?? '',
      nickName: userInfo['nickName'] ?? '',
      avatar: userInfo['avatar'] ?? '',
      // 读取更多字段
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, token: $token, nickName: $nickName, avatar: $avatar}';
  }
}