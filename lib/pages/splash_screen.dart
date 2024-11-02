import 'package:banboostore/constants.dart';
import 'package:banboostore/pages/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Constants _constants = Constants();

  @override
  void initState() {
    super.initState();
    navigateToLogin();
  }

  void navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3),() {
    },);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()));
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Banboo Store"),
        ],
      ),
    );
  }


}
