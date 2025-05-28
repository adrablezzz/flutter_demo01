/*
 * @Date: 2025-05-13 15:24:00
 * @LastEditTime: 2025-05-16 16:32:42
 */
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: 160.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE4EC), // 浅粉色（左上）
            Color(0xFFDDEEFF), 
            Colors.white// 浅蓝色（右上）
          ],
          stops: [0.0, 0.5, 1.0]
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Text('消息', style: TextStyle(fontSize: 18)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [Icon(Icons.message, size: 20), Text('点赞')]),
              Column(children: [Icon(Icons.message, size: 20), Text('新增关注')]),
              Column(children: [Icon(Icons.message, size: 20), Text('评论')]),
            ],
          ),
        ],
      ),
    );
  }
}
