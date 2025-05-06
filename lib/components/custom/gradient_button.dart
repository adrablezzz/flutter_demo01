import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Function? onTap;
  final EdgeInsets? padding;
  final Widget? child;
  final double borderRadius;
  final double width;


  const GradientButton({
    Key? key,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    this.borderRadius = 999,
    this.width = 60.0,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: padding,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),

      onHighlightChanged: (pressed) {
        // setState(() {
        //   _isPressed = pressed;
        // });
      },
    );
  }
}
