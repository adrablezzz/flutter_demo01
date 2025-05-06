import 'package:flutter/material.dart';
import 'package:flutter_demo01/utils/utils.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('loading...'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(createFadeRoute('/login'));
              },
              child: Icon(Icons.arrow_forward),
            )
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Center(child: Text('Welcome to Login Page')),
    );
  }
}