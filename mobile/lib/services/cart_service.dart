import 'dart:convert';
import 'package:banboostore/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/cart.dart';
import '../model/banboo.dart';
import '../model/order.dart';
import '../utils/api_constants.dart';
import '../utils/token_manager.dart';

class CartService {
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

  Future<Cart> getCart(BuildContext context) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/cart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        await _handleTokenExpired(context);
        throw Exception('Token expired');
      }

      if (response.statusCode == 200) {
        return Cart.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load cart: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching cart: $e');
    }
  }

  // Metode statis untuk menambahkan ke cart
  Future<void> addToCart(BuildContext context,Banboo banboo, int quantity) async {
    try {
      final tokenManager = TokenManager();
      final token = await tokenManager.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/cart/add'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'banbooId': banboo.banbooId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        // Token expired
        await _handleTokenExpired(context);
        throw Exception('Token expired');
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to add to cart: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding to carte: $e');
    }
  }

  Future<void> removeFromCart(BuildContext context,int cartItemId) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/cart/remove/$cartItemId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        // Token expired
        await _handleTokenExpired(context);
        throw Exception('Token expired');
      }


      if (response.statusCode != 200) {
        throw Exception('Failed to remove from cart: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error removing from cart: $e');
    }
  }

  Future<void> updateCart(BuildContext context,int cartItemId, int quantity) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/cart/update/$cartItemId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        // Token expired
        await _handleTokenExpired(context);
        throw Exception('Token expired');
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to update cart: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating cart: $e');
    }
  }

  Future<dynamic> checkout(BuildContext context) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/cart/checkout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        // Token expired
        await _handleTokenExpired(context);
        throw Exception('Token expired');
      }

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception('Checkout failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during checkout: $e');
    }
  }

  Future<List<Order>> getOrderHistory(BuildContext context) async {
    try {
      final token = await _tokenManager.getToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/cart/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        await _handleTokenExpired(context);
        throw Exception('Token expired');
      }

      if (response.statusCode == 200) {
        final List<dynamic> orderData = json.decode(response.body);
        return orderData.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception('Failed to load order history');
      }
    } catch (e) {
      throw Exception('Error fetching order history: $e');
    }
  }


}

