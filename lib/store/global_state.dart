import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalState with ChangeNotifier {
  String _userName = '';
  String _token = '';

  String get userName => _userName;
  String get token => _token;

  // 读取本地存储的值
  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? '';
    _token = prefs.getString('token') ?? '';
    notifyListeners();
  }

  // 保存用户名和 token 到本地存储
  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _userName = name;
    await prefs.setString('userName', name);
    notifyListeners();
  }

  Future<void> setToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    _token = newToken;
    await prefs.setString('token', newToken);
    notifyListeners();
  }

  // 清除所有存储的状态
  Future<void> clearState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('token');
    _userName = '';
    _token = '';
    notifyListeners();
  }
}
