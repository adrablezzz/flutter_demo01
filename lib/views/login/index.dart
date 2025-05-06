import 'package:flutter/material.dart';
import 'package:flutter_demo01/utils/utils.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  static const _statusMap = {'LOGIN': 0, 'REGISTER': 1, 'RESET': 2};

  var _status = _statusMap['LOGIN'];

  String _getBtnText() {
    switch (_status) {
      case 0:
        return '登录';
      case 1:
        return '注册';
      case 2:
        return '忘记密码';
      default:
        return '登录';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20), // 内边距
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, size: 100, color: Colors.blue),
              SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '邮箱账号',
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
              ),
              SizedBox(height: 20),
              TextField(
                controller: pwController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '密码',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(vertical: 16),
                  ),
                  minimumSize: WidgetStateProperty.all(
                    Size(double.infinity, 48),
                  ),
                ),
                onPressed: () {
                  print(
                    'Email: ${emailController.text}, Password: ${pwController.text}',
                  );
                  Navigator.of(context).pushReplacement(createFadeRoute('/home'));
                },
                child: Text(
                  _getBtnText(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(_status != _statusMap['LOGIN']) Row(
                    children: [
                      Text('已有账户?'),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _status = _statusMap['LOGIN'];
                          });
                        },
                        child: Text('去登录'),
                      ),
                    ],
                  ),
                  if(_status != _statusMap['REGISTER']) Row(
                    children: [
                      Text('还没有账户?'),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _status = _statusMap['REGISTER'];
                          });
                        },
                        child: Text('去注册'),
                      ),
                    ],
                  ),
                  if(_status != _statusMap['RESET']) Row(
                    children: [
                      Text('忘记密码?'),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _status = _statusMap['RESET'];
                          });
                        },
                        child: Text('去重置'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
