import 'package:flutter/material.dart';
import '../router/index.dart';

// 封装的页面跳转方法
// 从右侧进入，透明度过渡
Route createSlideRoute(String routePath) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      final route = ConfigRoutes.getRoute(routePath, context);
      return route ?? const SizedBox.shrink();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // 从右侧进入
      const end = Offset.zero; // 到达屏幕中心
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      var opacityTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: curve));
      var opacityAnimation = animation.drive(opacityTween);

      return FadeTransition(
        opacity: opacityAnimation,
        child: SlideTransition(position: offsetAnimation, child: child),
      );
    },
  );
}

// 透明度过渡
Route createFadeRoute(String routePath) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      final route = ConfigRoutes.getRoute(routePath, context);
      return route ?? const SizedBox.shrink();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;

      var opacityTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: curve));
      
      var opacityAnimation = animation.drive(opacityTween);

      return FadeTransition(
        opacity: opacityAnimation,
        child: child,
      );
    },
  );
}