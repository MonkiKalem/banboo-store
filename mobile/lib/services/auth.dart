import 'package:banboostore/utils/token_manager.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
//
// class GoogleAuth {
//   static final _OAUTH = GoogleSignIn(scopes: ['email','profile']);
//
//   static Future<GoogleSignInAccount?> googleSignIn() async {
//     final GoogleSignInAccount? googleUser  = await _OAUTH.signIn();
//     if(googleUser  != null) {
//       print("Logged in Email :${googleUser.email} ${googleUser.id}");
//       return googleUser;
//     }
//     return null;
//   }
// }

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuth {
  static final _OAUTH = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _OAUTH.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final userData = {
          'email': googleUser.email,
          'name': googleUser.displayName ?? '',
          'googleId': googleUser.id,
          'profilePicture': googleUser.photoUrl ?? '',
        };

        final response = await _sendGoogleLoginToBackend(userData);

        final Map<String, dynamic> parsedResponse = _convertToStringDynamicMap(response);

        if (parsedResponse['token'] != null) {
          await _saveUserSession(parsedResponse);

          return {
            'success': true,
            'user': googleUser,
            'isNewUser': parsedResponse['isNewUser'] ?? false,
            'message': parsedResponse['message'] ?? 'Login successful'
          };
        } else {
          return {
            'success': false,
            'message': parsedResponse['message'] ?? 'Google sign-in failed'
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Google sign-in cancelled'
        };
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${error.toString()}'
      };
    }
  }

  static Map<String, dynamic> _convertToStringDynamicMap(dynamic response) {
    if (response == null) {
      return {};
    }

    if (response is Map<String, dynamic>) {
      return response;
    }

    if (response is Map) {
      return response.map((key, value) => MapEntry(key.toString(), value));
    }

    try {
      // If it's a JSON string, decode it first
      final Map<dynamic, dynamic> decodedMap =
      response is String ? json.decode(response) : response;

      // Convert to Map<String, dynamic>
      return decodedMap.map((key, value) =>
          MapEntry(key.toString(), value)
      );
    } catch (e) {
      print('Error converting map: $e');
      return {};
    }
  }

  static Future<dynamic> _sendGoogleLoginToBackend(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/users/google-login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        // Parse error response
        final errorBody = json.decode(response.body);
        return {
          'success': false,
          'message': errorBody['message'] ?? 'Unknown server error',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      print('Backend Communication Error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server'
      };
    }
  }

  // Save user session locally with robust type handling
  static Future<void> _saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final TokenManager _tokenManager = TokenManager();
    // Null-safe and type-safe access with default values
    await prefs.setString('token', _safeStringConvert(userData['token']));
    await prefs.setString('userId', _safeStringConvert(userData['userId']));
    await prefs.setString('userEmail', _safeStringConvert(userData['email']));
    await prefs.setString('userName', _safeStringConvert(userData['name']));
    await prefs.setBool('isGoogleUser', true);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userRole', _safeStringConvert(userData['role'], defaultValue: 'customer'));
    await prefs.setString('profilePicture', _safeStringConvert(userData['profilePicture']));
    await _tokenManager.saveToken(userData['token']);
    await _tokenManager.saveUserId(userData['userId']);


  }

  // Utility method to safely convert to string
  static String _safeStringConvert(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString().trim().isEmpty ? defaultValue : value.toString();
  }

  // Logout method
  static Future<void> logout() async {
    try {
      // Sign out from Google
      await _OAUTH.signOut();

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      print('Logged out successfully');
    } catch (error) {
      print('Logout error: $error');
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token')?.isNotEmpty ?? false;
  }
}


