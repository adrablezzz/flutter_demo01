import 'package:flutter/material.dart';


class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool disabled;
  final double width;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final List<Color> gradientColors;

  const GradientButton({
    super.key,
    required this.child,
    required this.onTap,
    this.disabled = false,
    this.width = double.infinity,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
    this.borderRadius = 12,
    this.gradientColors = const [Colors.purple, Colors.blue],
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Stack(
        children: [
          Container(
            width: width,
            padding: padding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: disabled ? Colors.white.withOpacity(0.6) : Colors.white,
              ),
              child: child,
            ),
          ),
          if (disabled)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
