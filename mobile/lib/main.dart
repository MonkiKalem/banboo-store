import 'package:banboostore/constants.dart';
import 'package:banboostore/pages/login_page.dart';
import 'package:banboostore/pages/register_page.dart';
import 'package:banboostore/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banboo Store',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme() ,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
          centerTitle: true,
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login' : (context) => const LoginPage(),
        '/register' : (context) => const RegisterPage(),
      },
    );
  }
}