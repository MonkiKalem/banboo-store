class Order {
  final int orderId;
  final int totalPrice;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.totalPrice,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      totalPrice: json['totalPrice'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final int orderItemId;
  final int banbooId;
  final String banbooName;
  final int quantity;
  final int price;
  final int banbooPrice;
  final String imageUrl;

  OrderItem({
    required this.orderItemId,
    required this.banbooId,
    required  this.banbooName,
    required this.quantity,
    required this.price,
    required this.banbooPrice,
    required this.imageUrl
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      banbooId: json['banbooId'],
      quantity: json['quantity'],
      banbooName: json['banbooName'],
        banbooPrice: json['banbooPrice'],
      price: json['price'],
      orderItemId: json['orderItemId'],
      imageUrl: json['imageUrl']
    );
  }
}