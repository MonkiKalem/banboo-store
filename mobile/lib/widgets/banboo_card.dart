import 'package:banboostore/constants.dart';
import 'package:flutter/material.dart';
import 'package:banboostore/constants.dart';


class BanbooCard extends StatelessWidget {
  final String banbooId;
  final String name;
  final int price;
  final String description;
  final String elementId;
  final String level;
  final String imageUrl;

  const BanbooCard({super.key, required this.banbooId, required this.name, required this.price, required this.description, required this.elementId, required this.level, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundCardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 185,
              width: double.infinity,
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Level: $level',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Text('Rp$price', style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
