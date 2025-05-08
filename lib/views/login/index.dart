import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo01/components/custom/gradient_button.dart';
import 'package:flutter_demo01/utils/utils.dart';
import 'package:flutter_demo01/api/login_api.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_demo01/store/global_state.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

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

  bool? _hasError = null;
  void _validate() {
    final value = _phoneController.text;
    final regex = RegExp(r'^1[3-9]\d{9}$');
    setState(() {
      _hasError = !regex.hasMatch(value);
    });
  }

  bool? _hasErrorCode = null;
  void _validateCode() {
    final value = _codeController.text;
    setState(() {
      _hasErrorCode = value.length != 4;
    });
  }

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20), // 内边距
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              // 手机号
              Text(
                '手机号',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(11),
                  FilteringTextInputFormatter.digitsOnly, // 只允许数字
                ],
                onChanged: (_) => _validate(),
                decoration: InputDecoration(
                  hintText: '请输入手机号',
                  hintStyle: TextStyle(fontSize: 14.0),
                  filled: true,
                  fillColor: Colors.grey[100], // 设置背景颜色
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ), // 设置内边距
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // 设置圆角
                    borderSide:
                        _hasError == true
                            ? BorderSide(color: Colors.red)
                            : BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        _hasError == true
                            ? BorderSide(color: Colors.red)
                            : BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        _hasError == true
                            ? BorderSide(color: Colors.red)
                            : BorderSide.none,
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 18),
                    child:
                        _hasError == true
                            ? Icon(Icons.info_outline, color: Colors.red)
                            : _hasError == false
                            ? Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            )
                            : null,
                  ),
                ),
              ),
              // 验证码
              SizedBox(height: 20),
              Text(
                '验证码',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _codeController,
                onChanged: (_) => _validateCode(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly, // 只允许数字
                ],
                decoration: InputDecoration(
                  hintText: '请输入验证码',
                  hintStyle: TextStyle(fontSize: 14.0),
                  filled: true,
                  fillColor: Colors.grey[100], // 设置背景颜色
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ), // 设置内边距
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // 设置圆角
                    borderSide:
                        _hasErrorCode == true
                            ? BorderSide(color: Colors.red)
                            : BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        _hasErrorCode == true
                            ? BorderSide(color: Colors.red)
                            : BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        _hasErrorCode == true
                            ? BorderSide(color: Colors.red)
                            : BorderSide.none,
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: TextButton(
                      onPressed: () async {
                        _validate();
                        if (_hasError == false) {
                          final result = await LoginApi.sendVerifyCode(
                            _phoneController.text,
                          );
                          if (result.isSuccess) {
                            showToast(result.data?.msg);
                          }
                        }
                      },
                      child: Text('发送验证码'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isChecked = !(_isChecked ?? false);
                      });
                    },
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 1),
                        gradient:
                            _isChecked!
                                ? LinearGradient(
                                  colors: [const Color.fromARGB(255, 217, 0, 255), const Color.fromARGB(255, 0, 140, 255)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                      ),
                      child:
                          _isChecked!
                              ? Icon(Icons.check, color: Colors.white, size: 14)
                              : null,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('已阅读并同意'),
                  InkWell(
                    onTap: () {},
                    child: Text('《隐私政策》', style: TextStyle(color: Colors.blue)),
                  ),
                  Text('及'),
                  InkWell(
                    onTap: () {},
                    child: Text('《用户协议》', style: TextStyle(color: Colors.blue)),
                  ),
                  Text('。'),
                ],
              ),
              SizedBox(height: 20),
              GradientButton(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16, ),
                borderRadius: 30,
                disabled: !_isChecked || _hasError != false,
                child: Text(
                  '登录',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  _validate();
                  // 验证
                  if(_hasError != false || _codeController.text == '') {
                    showToast('请填写完整信息');
                    return;
                  }
                  print(
                    'phone: ${_phoneController.text}, code: ${_codeController.text}',
                  );
                  globalState.setToken('Basic YXBwOmFwcA==');
                  // Navigator.of(context).pushReplacement(createFadeRoute('/home'));
                  final res = LoginApi.loginBySms(
                    _phoneController.text,
                    _codeController.text,
                  );
                  print('res: ' + res.toString());
                },
              ),
              Text('Token: ${globalState.token}'),
            ],
          ),
        ),
      ),
    );
  }
}
