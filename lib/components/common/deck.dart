import 'package:flutter/material.dart';

class Deck extends StatefulWidget {
  const Deck({super.key});

  @override
  _DeckState createState() => _DeckState();
}

class _DeckState extends State<Deck> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //SlideTransition 用于执行平移动画
        child: Column(
          children: [
            SlideTransition(
              position: animation,
              //将要执行动画的子view
              child: Container(width: 200, height: 200, color: Colors.red),
            ),
            ElevatedButton(
              onPressed: () {
                controller.forward();
              },
              child: Text('开始'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.reverse();
              },
              child: Text('返回'),
            ),
            Image.network(
              'https://bpic.588ku.com/element_origin_min_pic/23/07/11/d32dabe266d10da8b21bd640a2e9b611.jpg',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    //     controller.addStatusListener((status) {
    //       if (status == AnimationStatus.completed) {
    //         //AnimationStatus.completed 动画在结束时停止的状态
    //         debugPrint('完成');
    //         // controller.reverse();
    //       } else if (status == AnimationStatus.dismissed) {
    //         //AnimationStatus.dismissed 表示动画在开始时就停止的状态
    //         debugPrint('消失');
    //         // controller.forward();
    // //        controller.dispose();
    //       }
    //     });
    // animation = Tween(begin: Offset.zero, end: Offset(1.0, 0.0)).animate(controller);
    animation = Tween(begin: Offset(0.5, 0.0), end: Offset(2.2, 0.0)).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
    );
    //开始执行动画
    // controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
}
