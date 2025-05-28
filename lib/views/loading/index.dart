import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_demo01/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../store/global_state.dart';
import 'dart:async';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  String _token = '';

  void _navigateTo(BuildContext context) {
    print('token: ${_token}');
    if(_token.isNotEmpty && _token != '') {
      Navigator.of(context).pushReplacement(createFadeRoute('/home'));
    } else {
      Navigator.of(context).pushReplacement(createFadeRoute('/login'));
    }
  }

  @override
  void initState() {
    super.initState();

    // 延迟 3 秒后跳转到首页
    Timer(Duration(seconds: 3), () {
      _navigateTo(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);
    _token = globalState.user.token;

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // 加载动画（可选）
      ),
    );
  }
}
