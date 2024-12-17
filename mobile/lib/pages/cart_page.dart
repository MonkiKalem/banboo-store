import 'package:banboostore/screens/order_detail_screen.dart';
import 'package:banboostore/widgets/layout/banboo_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/cart.dart';
import '../model/order.dart';
import '../screens/order_success_screen.dart';
import '../services/cart_service.dart';
import '../utils/constants.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Cart _cart = Cart();
  bool _isLoading = true;
  String? _errorMessage;
  bool _isCartView = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadCart();
    _isLoading = false;
  }

  Future<void> _refreshCart() async {
    await _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      //_isLoading = true;
      _errorMessage = null;
    });

    try {
      final cart = await CartService().getCart(context);
      setState(() {
        _cart = cart;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateQuantity(int cartItemId, int quantity) async {
    try {
      await CartService().updateCart(context, cartItemId, quantity);
      await _loadCart();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeFromCart(int cartItemId) async {
    try {
      await CartService().removeFromCart(context, cartItemId);
      await _loadCart();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _performCheckout() async {
    final cartService = CartService();

    setState(() {
      _isLoading = true;
    });

    try {
      final checkoutResult = await cartService.checkout(context);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrderSuccessScreen(
            orderId: checkoutResult['orderId'],
          ),
        ),
      );
    } catch (e) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Checkout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 75,
        title: const Text(
          'My Cart',
          style: TextStyle(color: AppColors.textColorDark),
        ),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Column(
        children: [
          // Section untuk tombol Cart dan Order History
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCartView = true;
                      });
                    },
                    child: Card(
                      elevation: 4,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: const CachedNetworkImageProvider(
                                'https://upload-os-bbs.hoyolab.com/upload/2023/11/15/369285726/fe6f361715d2e479c9333aa4eb56debd_5228699759752292298.jpg?x-oss-process=image%2Fresize%2Cs_1000%2Fauto-orient%2C0%2Finterlace%2C1%2Fformat%2Cwebp%2Fquality%2Cq_70'),
                            fit: BoxFit.cover,
                            colorFilter: _isCartView
                                ? ColorFilter.mode(Colors.black.withOpacity(0.2),
                                BlendMode.darken)
                                : ColorFilter.mode(Colors.black.withOpacity(0.5),
                                    BlendMode.darken),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'My Cart',
                            style: TextStyle(
                              color:_isCartView ? AppColors.secondaryColor : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCartView = false;
                      });
                    },
                    child: Card(
                      elevation: 4,
                      color: AppColors.backgroundGreyColor,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: const NetworkImage(
                                'https://upload-os-bbs.hoyolab.com/upload/2023/11/15/369285726/fe6f361715d2e479c9333aa4eb56debd_5228699759752292298.jpg?x-oss-process=image%2Fresize%2Cs_1000%2Fauto-orient%2C0%2Finterlace%2C1%2Fformat%2Cwebp%2Fquality%2Cq_70'), // Ganti dengan path image Anda
                            fit: BoxFit.cover,
                            colorFilter: !_isCartView
                                ?ColorFilter.mode(Colors.black.withOpacity(0.2),
                          BlendMode.darken)
                                : ColorFilter.mode(Colors.black.withOpacity(0.5),
                                    BlendMode.darken),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Order History',
                            style: TextStyle(
                              color: !_isCartView ? AppColors.secondaryColor : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isCartView ? _buildCartView() : _buildOrderHistoryView(),
          ),
        ],
      ),
    );
  }

  Widget _buildCartView() {
    return RefreshIndicator(
        onRefresh: _refreshCart,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Error Loading Cart',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        Text(_errorMessage!),
                        ElevatedButton(
                          onPressed: _loadCart,
                          child: Text('Retry'),
                        )
                      ],
                    ),
                  )
                : _cart.items.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 100,
                              color: Colors.grey,
                            ),
                            Text(
                              'Your cart is empty',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: const Text(
                            "Swipe to remove item from cart",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _cart.items.length,
                            itemBuilder: (context, index) {
                              final item = _cart.items[index];
                              return Dismissible(
                                  key: Key(item.cartItemId.toString()),
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    _removeFromCart(item.cartItemId);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 0.3)),
                                    ),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // Image
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: BanbooImage(
                                            imageUrl: item.imageUrl,
                                            height: 100,
                                            width: 80,
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        // Product Details and Quantity Control
                                        Expanded(
                                          child: SizedBox(
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 21,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Rp${NumberFormat('#,###').format(item.price)}',
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(height: 1),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Quantity Control
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]!),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove,
                                                    size: 20),
                                                onPressed: () {
                                                  if (item.quantity == 1) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              "Quantity Minimun 1 to buy, if wanna delete please swipe")),
                                                    );
                                                  } else if (item.quantity >
                                                      1) {
                                                    _updateQuantity(
                                                        item.cartItemId,
                                                        item.quantity - 1);
                                                  }
                                                },
                                              ),
                                              Text(
                                                item.quantity.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add,
                                                    size: 20),
                                                onPressed: () {
                                                  _updateQuantity(
                                                      item.cartItemId,
                                                      item.quantity + 1);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, -3),
                              ),
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 72),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      'Rp${NumberFormat('#,###').format(_cart.totalPrice)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    minimumSize: const Size(150, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: _cart.items.isNotEmpty
                                      ? () async {
                                          await _performCheckout();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Checkout process'),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: const Text(
                                    'Checkout',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]));
  }

  // Tambahkan method untuk menampilkan order history
  Widget _buildOrderHistoryView() {
    return FutureBuilder(
      future: CartService().getOrderHistory(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Error Loading Order History',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
                Text(snapshot.error.toString()),
              ],
            ),
          );
        }

        final orders = snapshot.data;

        if (orders == null || orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 100,
                  color: Colors.grey,
                ),
                Text(
                  'No order history',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.orderId}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            Text(
                              order.createdAt.toString().split(' ')[0],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${order.items.length} Banboo type',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Total: Rp${NumberFormat('#,###').format(order.totalPrice)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Mini item preview
                        _buildMiniItemPreview(order.items),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMiniItemPreview(List<OrderItem> items) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: EdgeInsets.only(right: 8),
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Stack(children: [
                Center(
                    child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                )),
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                Center(
                  child: Text(
                    '${item.quantity}x',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
