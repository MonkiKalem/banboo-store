import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  static final _OAUTH = GoogleSignIn(scopes: ['email','profile']);

  static Future<GoogleSignInAccount?> googleSignIn() async {
    final GoogleSignInAccount? googleUser  = await _OAUTH.signIn();

    if(googleUser  != null) {
      print("Logged in Email :${googleUser.email}");
      return googleUser;
    }
    return null;
  }
}