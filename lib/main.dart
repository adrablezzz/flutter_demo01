import 'package:flutter/material.dart';
import 'router/index.dart';
import 'package:provider/provider.dart';
import 'store/global_state.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: ConfigRoutes.routes,
    );
  }
}
