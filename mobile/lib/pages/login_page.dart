import 'package:banboostore/utils/constants.dart';
import 'package:banboostore/model/banboo.dart';
import 'package:banboostore/widgets/background.dart';
import 'package:banboostore/widgets/custom_appbar.dart';
import 'package:banboostore/widgets/layout/carousel.dart';
import 'package:flutter/material.dart';
import '../services/user_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(); // Updated from username
  final _passwordController = TextEditingController();
  bool _passwordIsObscured = true;

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await UserApiService.loginWithEmail(
        _emailController.text,
        _passwordController.text,
      );

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Text("Welcome ${response['user']['name']}!"),
          ),

        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Login failed: ${response['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text("Login failed: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        const Background(
          imageUrl:
              "https://fastcdn.hoyoverse.com/content-v2/nap/102026/37198ce9c5ee13abb2c49f1bd1c3ca97_7846165079824928446.png",
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomAppbar(titleText: "Sign In"),
              Form(
                key: _formKey,
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Please sign in to continue",
                        style:
                            TextStyle(fontSize: 16, color: AppColors.textColor),
                      ),
                      const SizedBox(height: 20),
                      // Email input field
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: AppColors.textColor),
                        decoration: InputDecoration(
                          focusColor: AppColors.secondaryColor,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: AppColors.secondaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          label: const Text("Email"),
                          labelStyle:
                              const TextStyle(color: AppColors.textColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Password input field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _passwordIsObscured,
                        style: const TextStyle(color: AppColors.textColor),
                        decoration: InputDecoration(
                          focusColor: AppColors.secondaryColor,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: AppColors.secondaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          label: const Text("Password"),
                          labelStyle:
                              const TextStyle(color: AppColors.textColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          suffixIconColor: AppColors.primaryColor,
                          suffixIcon: IconButton(
                            focusColor: Colors.white,
                            icon: Icon(_passwordIsObscured
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passwordIsObscured = !_passwordIsObscured;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Login button
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  elevation: 22,
                  backgroundColor: AppColors.secondaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColorDark)),
              ),
              const SizedBox(height: 20),
              // Optional navigation to register page
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  "Don't have an account? Register here",
                  style: TextStyle(color: AppColors.secondaryColor),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
