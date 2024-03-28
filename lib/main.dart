// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:profile_app/Screens/login_screen.dart';
import 'package:profile_app/Screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: const LoginScreen(),
    );
  }
}
