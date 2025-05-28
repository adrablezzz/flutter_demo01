import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;

  const ExpandableText({
    Key? key,
    required this.text,
    this.style,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  bool _overflow = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // 创建 TextPainter 判断文字是否溢出
      final span = TextSpan(text: widget.text, style: widget.style);
      final tp = TextPainter(
        text: span,
        maxLines: widget.maxLines,
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: constraints.maxWidth);

      _overflow = tp.didExceedMaxLines;

      // 实际展示的文本内容
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: widget.style,
            maxLines: _expanded ? null : widget.maxLines,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (_overflow)
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _expanded ? '/收起' : '/展开全部',
                  style: const TextStyle(color: Colors.blue, fontSize: 13),
                ),
              ),
            ),
        ],
      );
    });
  }
}
