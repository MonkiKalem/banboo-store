import 'package:banboostore/services/auth.dart';
import 'package:banboostore/widgets/layout/carousel.dart';
import 'package:banboostore/widgets/login_button.dart';
import 'package:banboostore/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();

  void onLoginHandler(BuildContext context) async {
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(width: 15),
            Text('Signing in with Google...'),
          ],
        ),
        duration: Duration(minutes: 1),
        backgroundColor: Colors.blue,
      ),
    );

    try {
      final result = await GoogleAuth.googleSignIn();
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      if (result['success']) {

          String welcomeMessage = result['isNewUser']
              ? "Welcome! Your account has been created."
              : "Welcome back ${result['user'].displayName ??
              result['user'].email}!";
          // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              welcomeMessage,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

          await Future.delayed(const Duration(seconds: 3));
          Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error SnackBar for login failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Google sign-in failed',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Remove loading SnackBar
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      // Show detailed error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login failed: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDarkColor,
      body: Stack(
        children: [
          // BACKGROUND IMAGE
          Container(
            height: double.infinity,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl:"https://fastcdn.hoyoverse.com/content-v2/nap/102026/37198ce9c5ee13abb2c49f1bd1c3ca97_7846165079824928446.png",
              placeholder: (context, url) =>
              const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          // BLACK LAYER
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.7),

          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                const SizedBox(height: 84,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome to our",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 28,
                            color: AppColors.textColor
                        ),),
                      Text("Banboo Store",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                            color: AppColors.textColor
                        ),),
                      Divider(),
                      SizedBox(height: 15,),
                      Text("Project Mobile Cloud Computing \nBara, Syuja, Zaky ",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: AppColors.textColor
                        ),),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Carousel(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              "Continue with",
                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ),
                          LoginButton(
                            icon: "lib/assets/images/ic_google.png",
                            text: "Login with Email",
                            backgroundColor: AppColors.primaryColor,
                            textColor: AppColors.textColor,
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                                  child: Text(
                                    "Or",
                                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Login Google
                              IconButton(
                                icon: Image.asset('lib/assets/images/ic_google.png', width: 32, height: 32,),
                                onPressed: () => onLoginHandler(context),
                              ),

                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text("Don't have an account? Register here", style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),


                    ],
                  ),
                )

              ],
            ),
          ),
        ]
      ),
    );

  }
}
