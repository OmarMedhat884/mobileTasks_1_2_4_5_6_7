import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home/home_screen/home_page.dart';
import 'profile/user_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(),
    );
  }
}
