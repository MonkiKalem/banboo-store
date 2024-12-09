class Banboo {
  final String banbooId;
  final String name;
  final int price;
  final String description;
  final String elementId;
  final String level;
  final String imageUrl;

  Banboo({
    required this.banbooId,
    required this.name,
    required this.price,
    required this.description,
    required this.elementId,
    required this.level,
    required this.imageUrl,
  });

  factory Banboo.fromJson(Map<String, dynamic> json) {
    return Banboo(
      banbooId: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      price: json['price'],
      level: json['level'].toString(),
      elementId: json['elementId'],
      imageUrl: json['imageUrl'],
    );
  }

  // Method untuk mengonversi objek ke Map (untuk keperluan JSON)
  Map<String, dynamic> toMap() {
    return {
      'banbooId': banbooId,
      'name': name,
      'price': price,
      'description': description,
      'elementId': elementId,
      'level': level,
      'imageUrl': imageUrl,
    };
  }

  // Method untuk mengonversi Map ke objek Banboo (untuk parsing JSON)
  factory Banboo.fromMap(Map<String, dynamic> map) {
    return Banboo(
      banbooId: map['banbooId'] ?? '',
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      elementId: map['elementId'] ?? '',
      level: map['level'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  // Optional: Method untuk mengonversi objek ke JSON string
  String toJson() {
    final map = toMap();
    return map.toString();
  }

}
