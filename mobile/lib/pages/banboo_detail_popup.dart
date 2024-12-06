import 'package:banboostore/constants.dart';
import 'package:flutter/material.dart';
import 'package:banboostore/model/banboo.dart';

class BanbooDetailDialog extends StatefulWidget {
  final Banboo banboo;

  const BanbooDetailDialog({super.key, required this.banboo});

  @override
  State<BanbooDetailDialog> createState() => _BanbooDetailDialogState();
}

class _BanbooDetailDialogState extends State<BanbooDetailDialog> {
  // Variabel untuk jumlah barang dan total harga
  int quantity = 1;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    totalPrice = widget.banboo.price; // Set totalPrice awal
  }

  // Fungsi untuk menambah item ke keranjang
  void addToCart() {
    // Simulasi menambah barang ke keranjang
    print('Item Added to Cart: ${widget.banboo.name}');
    print('Quantity: $quantity');
    print('Total Price: \$${totalPrice.toStringAsFixed(2)}');
    // Bisa tambahkan logika untuk menyimpan ke keranjang atau state global
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
        width: 400,
        height: 750,
        child: Column(
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
            Text(widget.banboo.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Level: ${widget.banboo.level}',
                style: const TextStyle(fontSize: 18)),
            Text('Price: \$${widget.banboo.price}',
                style: const TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.banboo.description),
            ),
            const SizedBox(height: 16),

            // Kontrol jumlah barang (Stepper atau tombol plus/minus)
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
                Text('$quantity', style: const TextStyle(fontSize: 20)),
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

            const SizedBox(height: 16),
            // Menampilkan total harga
            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Tombol untuk menambah ke keranjang
            ElevatedButton(
              onPressed: () {
                addToCart(); // Menambah barang ke keranjang
                Navigator.of(context).pop(); // Menutup dialog setelah menambah
              },
              child: const Text("Add to Cart"),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
