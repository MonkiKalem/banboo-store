import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) =>
          const CircularProgressIndicator(),
          errorWidget: (context, url, error) =>
          const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      );
  }
}
