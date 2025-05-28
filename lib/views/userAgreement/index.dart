import 'package:flutter/material.dart';

class UserAgreement extends StatelessWidget {
  const UserAgreement({Key? key}) : super(key: key);

  final String userAgreement = 
'''欢迎使用我们的应用！

1. 用户须知
您在使用本应用前，应仔细阅读本协议的所有条款。
本协议内容包括但不限于以下内容：

2. 隐私政策
我们重视您的隐私，您在使用本应用时的信息将按照我们的隐私政策处理。

3. 免责声明
本应用所提供的信息仅供参考，我们不对任何损失承担责任。

感谢您的支持！
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('隐私政策'), backgroundColor: Colors.white,),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Text(
            userAgreement,
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
