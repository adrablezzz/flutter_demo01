/*
 * @Date: 2025-04-16 10:37:57
 * @LastEditTime: 2025-04-30 14:02:05
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo01/utils/utils.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final double HEIGHT = 300.0;
  final double BOT_HEIGHT = 160.0;

  // 用户名 前面 头像 动态 关注 粉丝

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 列表部分
        SingleChildScrollView(
          padding: EdgeInsets.only(top: HEIGHT),
          child: Column(
            children: List.generate(30, (index) {
              return ListTile(title: Text("列表项 ${index + 1}"));
            }),
          ),
        ),
        // 上方固定部分
        Container(
          width: MediaQuery.of(context).size.width,
          height: HEIGHT,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'http://oss.linkon.me/changjia/20250224/f166d1cb-05af-4d59-ab1e-f9699146f75d.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 40.0,
          right: 10.0,
          child: Row(
          children: [
            Text('我的星环', style: TextStyle(color: Colors.white),),
            SizedBox(width: 20.0,),
            // 自定义按钮
            InkWell(
              child: Icon(Icons.settings_outlined, color: Colors.white,),
              onTap: () {
                  Navigator.of(context).push(createSlideRoute('/settingPage'));
              },
            )
          ],
        )),
        Positioned(
          top: HEIGHT - BOT_HEIGHT,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: BOT_HEIGHT,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  'http://oss.linkon.me/changjia/20250224/f166d1cb-05af-4d59-ab1e-f9699146f75d.jpg',
                ),
                radius: 40,
              ),
              SizedBox(height: 8.0),
              Text('用户名', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 8.0),
              Text(
                '签名...',
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Column(
                    children: [
                      Text('13', style: TextStyle(fontSize: 16.0)),
                      Text(
                        '动态',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(width: 50.0),
                  Column(
                    children: [
                      Text('8', style: TextStyle(fontSize: 16.0)),
                      Text(
                        '关注',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(width: 50.0),
                  Column(
                    children: [
                      Text('4', style: TextStyle(fontSize: 16.0)),
                      Text(
                        '粉丝',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            elevation: 16.0,
                            child: Container(
                              height: 220.0,
                              width: 300.0,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 220,
                                    width: 300,
                                    padding: EdgeInsets.only(
                                      top: 60,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox.shrink(),
                                        Text(
                                          '这是一个自定义弹框！',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // 关闭弹框
                                          },
                                          child: Text('关闭'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 超出弹框顶部的图片
                                  Positioned(
                                    top: -45, // 调整图片上方的位置
                                    left: 90, // 调整图片左右位置
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        'http://oss.linkon.me/changjia/20250224/f166d1cb-05af-4d59-ab1e-f9699146f75d.jpg', // 替换成你的图片路径
                                        height: 80, // 设置图片高度
                                        width: 80, // 设置图片宽度
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text('测试'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
