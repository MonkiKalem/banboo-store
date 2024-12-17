import 'cart_item.dart';

class Cart {
  int? cartId;
  double totalPrice;
  List<CartItem> items;
  int totalItems;

  Cart({
    this.cartId,
    this.totalPrice = 0.0,
    this.items = const [],
    this.totalItems = 0,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cartId'],
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      items: json['items'] != null
          ? (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList()
          : [],
      totalItems: json['totalItems'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'totalPrice': totalPrice,
      'items': items.map((item) => item.toJson()).toList(),
      'totalItems': totalItems,
    };
  }
}

