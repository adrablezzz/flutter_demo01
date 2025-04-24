import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    if(index == 2) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.blue,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: _buildBottomBarItem,
        ),
      ),
      // 浮动按钮
      floatingActionButton: Transform.translate(
        offset: const Offset(-8, 0), // 调整偏移量，确保按钮居中
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          highlightElevation: 0.0,
          shape: const CircleBorder(),
          onPressed: () {},
          child: const Icon(Icons.change_circle, size: 70), // 图标尺寸较大
        ),
      ),
      // 设置浮动按钮位置底部居中
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // 生成底部导航按钮
  List<BottomNavigationBarItem> get _buildBottomBarItem {
    return [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
      const BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜索'),
      // 中间这个使用空白占位
      const BottomNavigationBarItem(icon: SizedBox(height: 24), label: ''),
      const BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
    ];
  }
}
