/*
 * @Date: 2025-05-29 14:46:46
 * @LastEditTime: 2025-05-29 14:46:53
 */
// app_navigator.dart
import 'package:flutter/material.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState? get navigator => navigatorKey.currentState;

  /// 不使用 context 的路由跳转
  static Future<dynamic>? pushNamed(String routeName, {Object? arguments}) {
    return navigator?.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic>? pushReplacementNamed(String routeName, {Object? arguments}) {
    return navigator?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void pop([result]) {
    return navigator?.pop(result);
  }
}
