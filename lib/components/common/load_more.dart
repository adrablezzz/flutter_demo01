/*
 * @Date: 2025-05-14 10:53:41
 * @LastEditTime: 2025-05-14 11:05:46
 */
import 'package:flutter/material.dart';

class LoadMore extends StatefulWidget {
  final bool isLoading;
  final bool isNoMore;
  LoadMore({Key? key, required this.isLoading, required this.isNoMore})
    : super(key: key);

  @override
  _LoadMoreState createState() => _LoadMoreState();
}

class _LoadMoreState extends State<LoadMore> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? Container(
          margin: EdgeInsets.only(top: 16, bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!widget.isNoMore) SizedBox(
                width: 16.0,
                height: 16.0,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 10),
              Text(widget.isNoMore ? '没有更多了' : '加载中...'),
            ],
          ),
        )
        : SizedBox.shrink();
  }
}
