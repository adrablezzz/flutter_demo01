/*
 * @Date: 2025-05-13 15:24:00
 * @LastEditTime: 2025-05-16 14:41:50
 */
import 'package:flutter/material.dart';
import 'router/index.dart';
import 'package:provider/provider.dart';
import 'store/global_state.dart';
import './utils/app_navigator.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalState()..loadState(),
      child: MyApp(),
    ),
  );
}

 
class MyApp extends StatelessWidget {
  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/loading',
      routes: ConfigRoutes.routes,
    );
  }
}
