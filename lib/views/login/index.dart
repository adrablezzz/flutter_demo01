import 'package:flutter/material.dart';
import 'package:flutter_demo01/components/custom/gradient_button.dart';
import 'package:flutter_demo01/utils/utils.dart';
import 'package:flutter_demo01/api/login_api.dart';
import 'package:flutter/services.dart';
import '../../model/user.dart';
import 'package:provider/provider.dart';
import '../../store/global_state.dart';
import 'dart:async';


class Login extends StatefulWidget {
  Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  // 手机号验证
  bool? _hasError = null;
  void _validate() {
    final value = _phoneController.text;
    final regex = RegExp(r'^1[3-9]\d{9}$');
    setState(() {
      _hasError = !regex.hasMatch(value);
    });
  }

  // 验证码验证
  bool? _hasErrorCode = null;
  void _validateCode() {
    final value = _codeController.text;
    setState(() {
      _hasErrorCode = value.length != 4;
    });
  }

  // 发送验证码倒计时
  int _seconds = 0;
  Timer? _timer;
  void _startTimer() {
    if (_timer != null) return;
    setState(() => _seconds = 60);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds--;
        if (_seconds == 0) {
          _timer?.cancel();
          _timer = null;
        }
      });
    });
  }
  // 清除定时器
  void _clearTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // 是否勾选协议
  bool _isChecked = false;

  @override
  void dispose() {
    _clearTimer();
    super.dispose();
  }

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
                        // 验证手机号
                        _validate();
                        // 需要先勾选协议
                        if (_isChecked == false) {
                          showStyledToast(context, [
                            TextSpan(text: '请先阅读'),
                            TextSpan(
                              text: '隐私政策',
                              style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                            ),
                            TextSpan(text: '和'),
                            TextSpan(
                              text: '用户协议',
                              style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                            ),
                            TextSpan(text: '，勾选同意后才能发送验证码'),
                          ]);
                          return;
                        }
                        // 倒计时没结束不能发送验证码
                        if(_seconds != 0) {
                          return;
                        }
                        if (_hasError == false) {
                          final result = await LoginApi.sendVerifyCode(
                            _phoneController.text,
                          );
                          if (result.isSuccess) {
                            showToast(result.data?.msg);
                          }
                          _startTimer();
                        }
                      },
                      child: Text(_seconds == 0 ? '获取验证码' : '$_seconds秒后重试', style: TextStyle(color: _seconds == 0 ? Colors.blue[400] : Colors.grey)),
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
                                  colors: [
                                    const Color.fromARGB(255, 217, 0, 255),
                                    const Color.fromARGB(255, 0, 140, 255),
                                  ],
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
                    onTap: () {
                      Navigator.of(context).push(createSlideRoute('/privacyPolicy'));
                    },
                    child: Text('《隐私政策》', style: TextStyle(color: Colors.blue)),
                  ),
                  Text('及'),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(createSlideRoute('/userAgreement'));
                    },
                    child: Text('《用户协议》', style: TextStyle(color: Colors.blue)),
                  ),
                  Text('。'),
                ],
              ),
              SizedBox(height: 20),
              GradientButton(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                borderRadius: 30,
                disabled: !_isChecked || _hasError != false || _hasErrorCode != false,
                child: Text(
                  '登录',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  _validate();
                  // 验证
                  if(_hasError != false || _codeController.text == '') {
                    showToast('请填写完整信息');
                    return;
                  }
                  // 收起键盘
                  FocusScope.of(context).unfocus();
                  final res = await LoginApi.loginBySms(
                    _phoneController.text,
                    _codeController.text,
                  );
                  if (res.isSuccess) {
                    User user = res.data!;
                    print('返回结果:');
                    print(user);
                    // 设置用户信息
                    globalState.setUser(user);
                    Navigator.of(context).pushReplacement(createFadeRoute('/home'));
                  } else {
                    // showToast('手机号或验证码错误，请检查');
                  }
                },
              ),
              ElevatedButton(onPressed: () {
                globalState.clearState();
              }, child: Text('测试清除缓存'))
            ],
          ),
        ),
      ),
    );
  }
}
