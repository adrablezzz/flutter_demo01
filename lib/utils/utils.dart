import 'package:flutter/material.dart';
import '../router/index.dart';
import 'package:fluttertoast/fluttertoast.dart';

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


// 中间弹框
void showToast(msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
  );
}

// 自定义富文本弹框
void showStyledToast(BuildContext context, List<InlineSpan> children) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.47,
      left: MediaQuery.of(context).size.width * 0.1,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              children: children
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: 2)).then((value) => overlayEntry.remove());
}
