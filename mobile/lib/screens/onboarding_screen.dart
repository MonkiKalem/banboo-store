import 'package:banboostore/components/login_button.dart';
import 'package:banboostore/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // google login
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        print("Google Sign-in canceled.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print("User signed in: ${userCredential.user?.displayName}");
      return userCredential.user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  void onLoginHandler(BuildContext context) async {
    try {
      User? user = await signInWithGoogle();

      if (user != null) {
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
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric( horizontal: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 64,),
                const SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome to",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 28,
                          color: AppColors.textColorDark
                      ),),
                      Text("Banboo Store",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                            color: AppColors.textColorDark
                        ),),
                      Divider(),
                      SizedBox(height: 15,),
                      Text("Project Mobile Cloud Computing \nBara, Syuja, Zaky ",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: AppColors.textColorDark
                        ),),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      LoginButton(
                        icon: const FaIcon(FontAwesomeIcons.user, color: Colors.black,),
                        text: "Login with Username",
                        backgroundColor: AppColors.primaryColor,
                        textColor: AppColors.textColor,
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),

                      const SizedBox(height: 10,),

                      // Login Google
                      LoginButton(
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black,),
                          text: "Login with Google",
                          backgroundColor: AppColors.primaryColor,
                          textColor: AppColors.textColor,
                          onPressed: () => onLoginHandler(context),
                      ),
                      const SizedBox(height: 10,),

                      // Login Facebook
                      LoginButton(
                        icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.black,),
                        text: "Login with Facebook",
                        backgroundColor: AppColors.primaryColor,
                        textColor: AppColors.textColor,
                        onPressed: () {

                        },
                      ),

                    ],
                  ),
                )
        
              ],
          ),
        ),
      ),
    );

  }
}
