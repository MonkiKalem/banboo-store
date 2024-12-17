import 'package:banboostore/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:banboostore/model/banboo.dart';
import 'package:intl/intl.dart';

import '../../services/cart_service.dart';

class BanbooDetailDialog extends StatefulWidget {
  final Banboo banboo;

  const BanbooDetailDialog({super.key, required this.banboo});

  @override
  State<BanbooDetailDialog> createState() => _BanbooDetailDialogState();
}

class _BanbooDetailDialogState extends State<BanbooDetailDialog> {
  int quantity = 1;
  late int totalPrice;
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    totalPrice = widget.banboo.price; // Set totalPrice awal
  }

  void addToCart() async {
    try {
      if (widget.banboo.banbooId == null) {
        throw Exception('Invalid Banboo: No ID found');
      }

      await _cartService.addToCart(context,widget.banboo, quantity);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.banboo.name} added to cart'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Log error
      print('Add to Cart Error: $e');

      // Tampilkan snackbar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add item to cart: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        width: 500,
        height: 800,
        child: Column(
          children: [
            Container(
              height: 575,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 500,
                      height: 300,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)) ,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF76484E),
                            Color(0xFFCCA469),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Hero(
                        tag: 'banboo-${widget.banboo.banbooId}', // Tag harus sama
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            widget.banboo.imageUrl,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      child:
                        Text(
                            widget.banboo.name,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                        ),

                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                          'Rp${NumberFormat('#,###').format(widget.banboo.price)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'Level: ${widget.banboo.level}',
                            style: const TextStyle(fontSize: 18)
                        ),
                        Row(
                          children: [
                            Text(
                                'Element: ${widget.banboo.elementName}',
                                style: const TextStyle(fontSize: 18)
                            ),
                            Image.network(
                              widget.banboo.elementIcon,
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
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(4),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all( color: Colors.grey, width: 0.3, ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 150,
                      child: Text(
                            widget.banboo.description, style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.start,
                          ),
                    ),

                  ],
                ),
              ),
            ),
            Column(
              children: [
                const Divider(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                            totalPrice = widget.banboo.price * quantity;
                          }
                        });
                      },
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                          totalPrice = widget.banboo.price * quantity;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Text(
                  'Total Price: Rp${NumberFormat('#,###').format(totalPrice)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    addToCart();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close", style: TextStyle(color: AppColors.primaryColor),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}