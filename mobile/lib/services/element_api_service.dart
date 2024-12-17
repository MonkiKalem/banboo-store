import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/token_manager.dart';

class ElementApiService {
  static const String baseUrl = "http://10.0.2.2:3000";
  final TokenManager _tokenManager = TokenManager();

  Future<List<Map<String, dynamic>>> getElements() async {
    final url = Uri.parse('$baseUrl/elements');

    try {
      final token = await _tokenManager.getToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        dynamic decoded = json.decode(response.body);
        if (decoded is List) {
          return decoded.cast<Map<String, dynamic>>();
        }
        if (decoded is Map) {
          return (decoded['elements'] as List).cast<Map<String, dynamic>>();
        }
        throw Exception('Unexpected response format');
      } else {
        throw Exception('Failed to fetch elements: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch elements: $e');
    }
  }

}
