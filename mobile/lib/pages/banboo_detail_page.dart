import 'package:flutter/material.dart';
import 'package:banboostore/model/banboo.dart';

class BanbooDetailPage extends StatelessWidget {
  final Banboo banboo;

  const BanbooDetailPage({super.key, required this.banboo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(banboo.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Hero(
            tag: 'banboo-${banboo.banbooId}', // Pastikan tag ini sama
            child: Image.network(
              banboo.imageUrl,
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Text(banboo.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('Level: ${banboo.level}', style: const TextStyle(fontSize: 18)),
          Text('Price: \$${banboo.price}', style: const TextStyle(fontSize: 18)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(banboo.description),
          ),
        ],
      ),
    );
  }
}
