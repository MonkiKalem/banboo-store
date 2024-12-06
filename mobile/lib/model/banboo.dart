class Banboo {
  final String banbooId;
  final String name;
  final double price;
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

  // Optional: Method untuk mengonversi JSON string ke objek
  factory Banboo.fromJson(String source) {
    final map = Map<String, dynamic>.from(source as Map);
    return Banboo.fromMap(map);
  }
}
