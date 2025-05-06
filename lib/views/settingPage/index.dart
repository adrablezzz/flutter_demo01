/*
 * @Date: 2025-04-30 13:56:44
 * @LastEditTime: 2025-04-30 14:25:55
 */
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置', style: TextStyle(fontSize: 18.0)),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16.0),
        // height: 260.0,
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.file_copy, size: 16.0),
                    title: Text('账号与安全', style: TextStyle(fontSize: 14.0)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.file_copy, size: 16.0),
                    title: Text('隐私政策', style: TextStyle(fontSize: 14.0)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.file_copy, size: 16.0),
                    title: Text('用户协议', style: TextStyle(fontSize: 14.0)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.file_copy, size: 16.0),
                    title: Text('黑名单', style: TextStyle(fontSize: 14.0)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0,),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue[100]),
                    ),
                    onPressed: () {}, child: Text('退出登录', style: TextStyle(color: Colors.white),)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
