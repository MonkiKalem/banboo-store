import 'package:banboostore/model/banboo.dart';
import 'package:banboostore/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/banboo_api_service.dart';

class BanbooAdminCard extends StatelessWidget {
  const BanbooAdminCard({super.key, required this.banboo, required this.context, required this.onBanbooDeleted});

  final Banboo banboo;
  final BuildContext context;
  final VoidCallback onBanbooDeleted;

  void _showDeleteConfirmation(Banboo banboo) {
    final banbooApiService = BanbooApiService();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bamboo'),
        content: Text('Are you sure you want to delete ${banboo.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await banbooApiService.deleteBanboo(context, banboo.banbooId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bamboo deleted successfully!')),
              );
              onBanbooDeleted();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.backgroundCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12)),
            child: Image.network(
              banboo.imageUrl,
              height: 225,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              },
              errorBuilder: (context, error, stackTrace) =>
                  Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_outlined,
                        size: 50, color: Colors.grey),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        banboo.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red),
                      onPressed: () =>
                      _showDeleteConfirmation(banboo),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          banboo.elementIcon,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        Text(
                          banboo.elementName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                      "Level: ${banboo.level.toString()}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  banboo.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp${NumberFormat('#,###').format(banboo.price)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
