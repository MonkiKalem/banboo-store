import 'package:flutter/material.dart';

class BanbooImage extends StatelessWidget {
  const BanbooImage({super.key, required this.imageUrl, required this.height, required this.width});

  final String imageUrl;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.all(4.0),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF76484E),
              Color(0xFFCCA469),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
