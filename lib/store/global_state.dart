import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class GlobalState with ChangeNotifier {
  User _user = User();
  late SharedPreferences _prefs;  // 缓存 SharedPreferences 实例

  User get user => _user;

  // 初始化 SharedPreferences
  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 读取本地存储的值
  Future<void> loadState() async {
    await _initializePrefs(); // 确保 SharedPreferences 被初始化

    print('load state');
    print('token ${_prefs.getString('token')}');
    _user = User.fromMap({
      'id': _prefs.getString('id') ?? '',
      'username': _prefs.getString('username') ?? '',
      'token': _prefs.getString('token') ?? '',
      'nickName': _prefs.getString('nickName') ?? '',
      'avatar': _prefs.getString('avatar') ?? '',
    });

    print(_user);
    notifyListeners();
  }

  // 设置用户信息
  Future<void> setUser(User user) async {
    await _initializePrefs();  // 确保 SharedPreferences 被初始化

    // 保存 User 对象中的每个字段
    final userMap = user.toMap();
    // final batch = _prefs; // 批量操作
    // userMap.forEach((key, value) {
    //   batch.setString(key, value);
    // });
    // await batch.commit();

    await Future.wait(userMap.entries.map((entry) =>
    _prefs.setString(entry.key, entry.value)));

    _user = user; // 更新内部 _user 对象
    notifyListeners();
  }

  // 清除所有存储的状态
  Future<void> clearState() async {
    await _initializePrefs();  // 确保 SharedPreferences 被初始化

    final keys = [
      'id', 'username', 'token', 'nickName', 'avatar'
      // 更多字段
    ];

    // 批量删除
    for (var key in keys) {
      await _prefs.remove(key);
    }

    _user = User(); // 重置为默认值
    notifyListeners();
  }
}
