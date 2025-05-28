import 'package:flutter/material.dart';

class HotPage extends StatefulWidget {
  final TabController? tabController;
  const HotPage({Key? key, required this.tabController}) : super(key: key);

  @override
  _HotPageState createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabController, 
      children: [
        Text('热点'),
        Text('关注'),
      ]
    );
  }
}
