import 'package:flutter/material.dart';
import 'package:flutter_demo01/components/custom/list_post_item.dart';
import 'package:flutter_demo01/components/custom/post_container.dart';

import 'package:flutter_demo01/model/post_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List listData = [
    PostItem(
      id: 1, 
      userAvatar: 'https://www.keaitupian.cn/cjpic/frombd/0/253/2279408239/3825398873.jpg', 
      userName: '用户名称1', 
      postTime: '2025-04-23 21:05:09', 
      postContent: '落霞与孤鹜齐飞，秋水共长天一色。', 
      postImage: 'https://ts1.tc.mm.bing.net/th/id/R-C.987f582c510be58755c4933cda68d525?rik=C0D21hJDYvXosw&riu=http%3a%2f%2fimg.pconline.com.cn%2fimages%2fupload%2fupc%2ftx%2fwallpaper%2f1305%2f16%2fc4%2f20990657_1368686545122.jpg&ehk=netN2qzcCVS4ALUQfDOwxAwFcy41oxC%2b0xTFvOYy5ds%3d&risl=&pid=ImgRaw&r=0',
      likeCount: 1,
      commentCount: 2,
      dislikeCount: 0
    )
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PostContainer(
          onPost: () {
            print('发布了');
          },
        ),
        ...List.generate(listData.length, (index) {
          return ListPostItem(postItem: listData[index]);
        }),
      ],
    );
  }
}
