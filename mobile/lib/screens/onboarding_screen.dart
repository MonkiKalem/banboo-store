import 'package:banboostore/services/auth.dart';
import 'package:banboostore/widgets/layout/carousel.dart';
import 'package:banboostore/widgets/login_button.dart';
import 'package:banboostore/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  late YoutubePlayerController _controller;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'KGOynaQoofc', // Ganti dengan ID video YouTube Anda
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
        hideControls: true,
        showLiveFullscreenButton: false
      ),
    );

    _controller.addListener(() {
      if (_controller.value.isReady) {
        print("Video is ready to play");
      }

      if (_controller.value.hasError) {
        print('Error: ${_controller.value.errorCode}');
      }
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onLoginHandler(BuildContext context) async {
    try {
      GoogleSignInAccount? user = await GoogleAuth.googleSignIn();

      if (user != null) {
        final GoogleSignInAuthentication? googleAuth = await user.authentication;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Welcome ${user.displayName ?? user.email}!")),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in canceleed or failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
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
                            icon: const FaIcon(FontAwesomeIcons.user, color: Colors.black,),
                            text: "Login with Username",
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
                              IconButton(
                                icon: Image.asset('lib/assets/images/ic_facebook.png', width: 32, height: 32,),
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
