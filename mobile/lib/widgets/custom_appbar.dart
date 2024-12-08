import 'package:flutter/material.dart';

import '../constants.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, required this.titleText});
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: AppColors.secondaryColor,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        titleText,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor),
      ),

    );
  }
}
