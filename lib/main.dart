import 'package:banboostore/pages/login_page.dart';
import 'package:banboostore/pages/register_page.dart';
import 'package:banboostore/pages/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        '/login' : (context) => LoginPage(),
        '/register' : (context) => RegisterPage(),
      },
    );
  }
}