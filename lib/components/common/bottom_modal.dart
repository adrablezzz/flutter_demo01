/*
 * @Date: 2025-05-13 15:24:00
 * @LastEditTime: 2025-05-17 15:03:57
 */
import 'package:flutter/material.dart';

class BottomModal {
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder childBuilder,
    bool isDismissible = true,
    Color backgroundColor = Colors.white,
    double borderRadius = 16,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierLabel: 'BottomModal',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // 把点击事件放在遮罩层（上方透明部分）
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    if (isDismissible) close(context);
                  },
                  child: Container(color: Colors.transparent),
                ),
              ),
              // 弹出的底部 modal
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  color: backgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(borderRadius),
                  ),
                  child: SafeArea(top: false, child: childBuilder(context)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void close(BuildContext context) {
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(milliseconds: 10), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }
}
