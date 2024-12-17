import 'package:banboostore/utils/constants.dart';
import 'package:banboostore/screens/onboarding_screen.dart';
import 'package:banboostore/services/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await UserApiService.getIsloggedIn();

    await Future.delayed(const Duration(seconds: 2));

    if (isLoggedIn == true) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacementNamed(context, "/onboarding");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDarkColor,
      body: Center(
        child: Stack(
          children: [
            const Background(
              imageUrl:
              "https://fastcdn.hoyoverse.com/content-v2/nap/102026/37198ce9c5ee13abb2c49f1bd1c3ca97_7846165079824928446.png",
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.8),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 48,),
                  Text("Banboo Store",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor
                    ),
                  ),
                  CircularProgressIndicator()
                ],
              ),
            ),
          ],

        ),

      ),
    );
  }


}
