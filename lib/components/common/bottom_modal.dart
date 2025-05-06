import 'package:flutter/material.dart';

class BottomModal {
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool isDismissible = true,
    Color backgroundColor = Colors.white,
    double borderRadius = 16,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadius),
                ),
              ),
              padding: const EdgeInsets.all(0),
              child: builder(context),
            );
          },
        );
      },
    );
  }

  // 手动关闭弹窗的方法
  static void close(BuildContext context) {
    Navigator.pop(context);
  }
}

