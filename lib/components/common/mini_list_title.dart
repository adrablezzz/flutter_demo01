import 'package:flutter/material.dart';


class MiniListTitle extends StatefulWidget {
   final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final double spacing;

  const MiniListTitle({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  _MiniListTitleState createState() => _MiniListTitleState();
}

class _MiniListTitleState extends State<MiniListTitle> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.leading != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 4),
                widget.leading!,
              ],
            ),
            SizedBox(width: widget.spacing),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.title,
                if (widget.subtitle != null) ...[
                  SizedBox(height: 2.0),
                  widget.subtitle!,
                ],
              ],
            ),
          ),
          if (widget.trailing != null) ...[
            SizedBox(width: widget.spacing),
            widget.trailing!,
          ],
        ],
      ),
    );
  }
}
