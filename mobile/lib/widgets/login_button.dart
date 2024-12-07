import 'package:banboostore/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginButton extends StatelessWidget {
  final FaIcon icon;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.icon, required this.text, required this.backgroundColor, required this.textColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryColor,
          elevation: 2,
          maximumSize: const Size(345, 65),
          minimumSize: const Size(200, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 10,),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorDark
                ),
              ),
            )
          ],

        ));
  }
}
