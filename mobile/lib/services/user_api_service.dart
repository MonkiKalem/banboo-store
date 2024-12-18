import 'dart:convert';
import 'dart:ffi';
import 'package:banboostore/utils/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserApiService {
  static const String baseUrl = "http://10.0.2.2:3000";
  static final TokenManager _tokenManager = TokenManager();

  static Future<Map<String, dynamic>> loginWithEmail(String email, String password) async {
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/users/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': email,
            'password': password
          })
      );

      final responseData = json.decode(response.body);

      print('Response Data: $responseData');


      if (response.statusCode == 200) {
        // Simpan data ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);
        await prefs.setString('userEmail', responseData['user']['email']);
        await prefs.setString('userName', responseData['user']['name']);
        await prefs.setString('userId', responseData['user']['userId'].toString());
        await prefs.setString('userRole', responseData['user']['role']);
        await prefs.setString('profilePicture', responseData['user']['profile_picture']) ?? '';
        await prefs.setBool('isGoogleUser', false);
        await prefs.setBool('isLoggedIn', true);

        await _tokenManager.saveToken(responseData['token']);
        await _tokenManager.saveUserId(responseData['user']['userId']);
        return {
          'success': true,
          'message': responseData['message'],
          'user': responseData['user']
        };
      } else {
        // Tangani error dari backend
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'An error occurred: $e'
      };
    }
  }

  static Future<String?> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<bool?> getIsloggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn');
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userRole');
    await prefs.remove('isLoggedIn');
    await prefs.remove('profilePicture');
    await prefs.remove('isGoogleUser');

  }

  static Future<Map<String, dynamic>> register(
      String username,
      String email,
      String password,
      String role,
      ) async {
    final url = Uri.parse('$baseUrl/users/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': username,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    final responseBody = json.decode(response.body);


    if (response.statusCode == 201) {
      // return jsonDecode(response.body);
      return {
        'success': true,
        'message': responseBody['message']
      };
    } else {
      if (response.statusCode == 409) {
        return {
          'success': false,
          'message': "Failed to register: ${responseBody['message'] ?? 'Email already exists.'}"
        };
        // throw Exception("Failed to register: ${responseBody['message'] ?? 'Email already exists.'}");
      } else {
        return {
          'success': false,
          'message': 'An error occurred: ${responseBody['message']} ?? "Failed to register: Internal Error'
        };
        // throw Exception(responseBody['message'] ?? "Failed to register: Internal Error");
      }
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? profilePicture,
  }) async {
    try {
      final token = await _tokenManager.getToken();
      final userId = await _tokenManager.getUserId();

      final response = await http.put(
        Uri.parse('$baseUrl/users/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',

        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'profilePicture': profilePicture,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        if (name != null) await prefs.setString('userName', name);
        if (email != null) await prefs.setString('userEmail', email);
        if (responseData['user']['profile_picture'] != null) {
          await prefs.setString('profilePicture', responseData['user']['profile_picture']);
        }

        return {
          'success': true,
          'message': responseData['message'],
          'user': responseData['user']
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Update failed'
        };
      }
    } catch (e) {
      print('Profile update error: $e');
      return {
        'success': false,
        'message': 'An error occurred: $e'
      };
    }
  }

}
