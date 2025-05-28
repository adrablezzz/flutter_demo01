import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import 'childComponents/home_page.dart';
import 'childComponents/hot_page.dart';
import 'childComponents/message_page.dart';
import 'childComponents/personal_page.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentIndex = 0;
  DateTime? _lastPressedAt;

  TabController? _tabController;
  final List<String> _tabs = ['热点', '关注'];

  void _onItemTapped(int index) {
    if (index == 2) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  PreferredSizeWidget? _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.min, // 让内容宽度自适应
            children: [
              Icon(Icons.location_on_outlined, size: 20),
              SizedBox(width: 3.0),
              Container(
                constraints: BoxConstraints(maxWidth: 100),
                child: Text(
                  '恋湖公园1111111111111',
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(254, 231, 251, 1),
                  Color.fromRGBO(228, 237, 254, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        );
      case 1:
        return AppBar(
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(horizontal: 24.0),
                tabs:
                    _tabs
                        .map(
                          (t) => Tab(
                            height: 24.0,
                            child: Text(t, style: TextStyle(fontSize: 16.0)),
                          ),
                        )
                        .toList(),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.purpleAccent,
                indicatorPadding: EdgeInsets.only(bottom: 5),
                indicatorWeight: 4,
                dividerHeight: 0,
              ),
              SizedBox(width: 50.0),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(254, 231, 251, 1),
                  Color.fromRGBO(228, 237, 254, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        );
      case 2:
        return AppBar(
          title: const Text('标题'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(254, 231, 251, 1),
                  Color.fromRGBO(228, 237, 254, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        );
      case 3:
      case 4:
        return null;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) > Duration(seconds: 2)) {
          _lastPressedAt = DateTime.now();
          showToast('再按一次退出');

          return false; // 不退出
        }
        return true; // 2秒内按第二次，退出
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomePage(),
            HotPage(
              tabController: _tabController,
            ),
           
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
            backgroundColor: Colors.white,
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
            onPressed: () {
              Navigator.of(context).push(createFadeRoute('/arCoreView'));
            },
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
