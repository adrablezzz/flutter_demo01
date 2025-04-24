import 'package:flutter/material.dart';
import 'views/home/index.dart';
import 'views/login/index.dart';
import 'views/register/index.dart';
import 'views/loading/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Home(),
      routes: {
        '/loading': (context) => Loading(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/home': (context) => Home(),
      },
    );
  }
}
