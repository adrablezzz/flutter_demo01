import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20), // 内边距
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.blue,
              ),
              SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
              ),
              SizedBox(height: 20),
              TextField(
                controller: pwController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('Email: ${emailController.text}, Password: ${pwController.text}');
                  Navigator.of(context).pushNamed('/home');
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
