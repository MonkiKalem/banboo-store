class CartItem{
  int cartItemId;
  int banbooId;
  String name;
  String imageUrl;
  double price;
  int quantity;
  String? elementName;

  CartItem({
    required this.cartItemId,
    required this.banbooId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.elementName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'],
      banbooId: json['banbooId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      elementName: json['elementName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItemId': cartItemId,
      'banbooId': banbooId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'elementName': elementName,
    };
  }
}