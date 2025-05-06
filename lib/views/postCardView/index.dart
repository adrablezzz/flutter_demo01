import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class PostCardView extends StatefulWidget {
  const PostCardView({Key? key}) : super(key: key);

  @override
  _PostCardViewState createState() => _PostCardViewState();
}

class _PostCardViewState extends State<PostCardView> {
  int _currentIndex = 0; // 当前卡片的索引
  int _totalCards = 5; // 卡片总数
  bool _isAtLastCard = false; // 是否到达最后一张卡片

  // 处理滑动到最后一张卡片的逻辑
  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
      // 判断是否到达最后一张卡片
      if (_currentIndex == _totalCards - 1) {
        _isAtLastCard = true;
      } else {
        _isAtLastCard = false;
      }
    });
  }

  // 弹出 Toast 提示
  void _showEndOfCardsMessage() {
    print('已经是最后一张卡片了！');
  }

  // 监听水平拖动结束
  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      print('向右滑动');
    } else if (details.primaryVelocity! < 0) {
      print('向左滑动');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[100],
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.white,
              child: Center(
                child: Text(
                  'Card $index',
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
            );
          },
          itemCount: 5,
          layout: SwiperLayout.STACK, // 堆叠效果
          itemWidth: 350.0,
          itemHeight: 600.0,
          viewportFraction: 0.8, // 卡片的显示比例
          axisDirection: AxisDirection.right,
          loop: false,
        ),
      ),
    );
  }
}
