import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000";

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      _saveUserData(responseBody['token'], responseBody['user']);

      return responseBody;
    } else {
      throw Exception("Failed to log in");
    }
  }

  static Future<void> _saveUserData(String token, Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('userId', userData['userId']);
    prefs.setString('userName', userData['name']);
    prefs.setString('userEmail', userData['email']);
    prefs.setString('userRole', userData['role']);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
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
        'role': role, // Always "customer"
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 409){
      throw Exception("Failed to register: Email Already Existed");
    }
    else {
      throw Exception("Failed to register : Internal Error");
    }
  }

}
