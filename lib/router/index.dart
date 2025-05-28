/*
 * @Date: 2025-05-13 15:24:00
 * @LastEditTime: 2025-05-22 14:34:08
 */
import 'package:flutter/material.dart';
import '../views/loading/index.dart';
import '../views/home/index.dart';
import '../views/login/index.dart';
import '../views/register/index.dart';
import '../views/settingPage/index.dart';
import '../views/privacyPolicy/index.dart';
import '../views/userAgreement/index.dart';
import '../views/arCoreView/index.dart';

class ConfigRoutes {

  static final Map<String, WidgetBuilder> _routes = {
    '/loading': (context) => Loading(),
    '/login': (context) => Login(),
    '/register': (context) => Register(),
    '/home': (context) => Home(),
    '/settingPage': (context) => SettingPage(),
    '/privacyPolicy': (context) => PrivacyPolicy(),
    '/userAgreement': (context) => UserAgreement(),
    '/arCoreView': (context) => ARCoreView(),
  };

  // 获取全部路由
  static Map<String, WidgetBuilder> get routes => _routes;

  // 根据路由名称返回对应页面
  static Widget? getRoute(String routeName, BuildContext context) {
    return _routes[routeName]?.call(context);
  }

}