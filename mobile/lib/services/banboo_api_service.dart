import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/banboo.dart';
import '../screens/onboarding_screen.dart';
import '../utils/token_manager.dart';

class BanbooApiService {
  static const String baseUrl = "http://10.0.2.2:3000";
  final TokenManager _tokenManager = TokenManager();

  Future<void> _handleTokenExpired(BuildContext context) async {
    // Hapus token
    await _tokenManager.deleteToken();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Token expired, Please login to continue',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
    // Navigate ke login screen
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
            (route) => false
    );
  }

  // Fetch all Banboos
  static Future<List<Banboo>> getAllBanboos(BuildContext context) async {
    final url = Uri.parse('$baseUrl/banboos');
    final token = await _getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Banboo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Banbooss');
    }
  }

  // Get Banboo by ID
  Future<dynamic> getBanbooById(BuildContext context, String id) async {
    final url = Uri.parse('$baseUrl/banboos/$id');
    final token = await _tokenManager.getToken();

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401 || response.statusCode == 403) {
      // Token expired
      await _handleTokenExpired(context);
      throw Exception('Token expired');
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Banboo details');
    }
  }

  // Create a new Banboo (Admin only)
  Future<Map<String, dynamic>> createBanboo({
    required BuildContext context,
    required String name,
    required int price,
    required String description,
    required int elementId,
    required int level,
    required String imageUrl,
  }) async {
    final url = Uri.parse('$baseUrl/banboos/add');
    final token = await _tokenManager.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'elementId': elementId,
        'level': level,
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode == 401 || response.statusCode == 403) {
      // Token expired
      await _handleTokenExpired(context);
      throw Exception('Token expired');
    }

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create Banboo');
    }
  }

  // Update a Banboo (Admin only)
  Future<Map<String, dynamic>> updateBanboo({
    required BuildContext context,
    required int id,
    required String name,
    required int price,
    required String description,
    required int elementId,
    required int level,
    required String imageUrl,
  }) async {
    final url = Uri.parse('$baseUrl/banboos/update/$id');
    final token = await _tokenManager.getToken();

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',

      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'elementId': elementId,
        'level': level,
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode == 401 || response.statusCode == 403) {
      // Token expired
      await _handleTokenExpired(context);
      throw Exception('Token expired');
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or missing token');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden: Admins only');
    } else {
      throw Exception('Failed to update Banboo: ${response.body}');
    }
  }

  // Delete a Banboo (Admin only)
  Future<Map<String, dynamic>> deleteBanboo(BuildContext context, int id) async {
    final url = Uri.parse('$baseUrl/banboos/delete/$id');
    final token = await _tokenManager.getToken();

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401 || response.statusCode == 403) {
      // Token expired
      await _handleTokenExpired(context);
      throw Exception('Token expired');
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete Banboo');
    }
  }

  // Helper method to get token from SharedPreferences
  static Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}