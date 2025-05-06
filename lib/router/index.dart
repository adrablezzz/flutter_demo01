import 'package:flutter/material.dart';
import '../views/loading/index.dart';
import '../views/home/index.dart';
import '../views/login/index.dart';
import '../views/register/index.dart';
import '../views/settingPage/index.dart';

class ConfigRoutes {

  static final Map<String, WidgetBuilder> _routes = {
    '/loading': (context) => Loading(),
    '/login': (context) => Login(),
    '/register': (context) => Register(),
    '/home': (context) => Home(),
    '/settingPage': (context) => SettingPage(),
  };

  // 获取全部路由
  static Map<String, WidgetBuilder> get routes => _routes;

  // 根据路由名称返回对应页面
  static Widget? getRoute(String routeName, BuildContext context) {
    return _routes[routeName]?.call(context);
  }

}