import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'childComponents/home_page.dart';
import 'childComponents/hot_page.dart';
import 'childComponents/message_page.dart';
import 'childComponents/personal_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  DateTime? _lastPressedAt;

  void _onItemTapped(int index) {
    if (index == 2) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
          DateTime.now().difference(_lastPressedAt!) > Duration(seconds: 2)) {
          
          _lastPressedAt = DateTime.now();
          Fluttertoast.showToast(
            msg: '再按一次退出',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          return false; // 不退出
        }
        return true; // 2秒内按第二次，退出
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('标题'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(172, 240, 179, 199),
                  Color.fromARGB(202, 176, 207, 231),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            HomePage(),
            HotPage(),
            SizedBox(),
            MessagePage(),
            PersonalPage(),
          ],
        ),
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
      ),
    );
  }

  // 生成底部导航按钮
  List<BottomNavigationBarItem> get _buildBottomBarItem {
    return [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
      const BottomNavigationBarItem(icon: Icon(Icons.fireplace), label: '焦点'),
      // 中间这个使用空白占位
      const BottomNavigationBarItem(icon: SizedBox(height: 24), label: ''),
      const BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
    ];
  }
}
