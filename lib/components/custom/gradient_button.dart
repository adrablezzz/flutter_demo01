/*
 * @Date: 2025-05-13 15:24:00
 * @LastEditTime: 2025-05-16 14:41:14
 */
import 'package:flutter/material.dart';


class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool disabled;
  final double width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final List<Color> gradientColors;
  final Color textColor;

  const GradientButton({
    super.key,
    required this.child,
    required this.onTap,
    this.disabled = false,
    this.width = double.infinity,
    this.height,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
    this.borderRadius = 12,
    this.gradientColors = const [Colors.purple, Colors.blue],
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            padding: padding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: disabled ? Colors.white.withOpacity(0.6) : textColor,
              ),
              child: child,
            ),
          ),
          if (disabled)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
