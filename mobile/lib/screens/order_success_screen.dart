// order_success_screen.dart
import 'package:banboostore/pages/home_page.dart';
import 'package:banboostore/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/background.dart';

class OrderSuccessScreen extends StatelessWidget {
  final int orderId;

  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDarkColor,
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
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.secondaryColor,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Order Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Order ID: $orderId',
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePageWithBottomBar()),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    color: AppColors.textColorDark,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),


    );
  }
}