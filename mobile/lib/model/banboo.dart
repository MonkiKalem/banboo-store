class Banboo {
  final int banbooId;
  final String name;
  final String imageUrl;
  final int price;
  final int elementId;
  final String elementName;
  final String elementIcon;
  final String description;
  final int level;

  Banboo({
    required this.banbooId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.elementName,
    required this.elementIcon,
    required this.description,
    required this.level,
    required this.elementId,
  });

  factory Banboo.fromJson(Map<String, dynamic> json) {
    return Banboo(
      banbooId: json['banbooId'],
      name: json['name'],
      price: int.parse(json['price'].toString()),
      description: json['description'],
      level: json['level'],
      imageUrl: json['imageUrl'] ?? '',
      elementId: json['elementId'] ?? '',
      elementName: json['elementName'] ?? 'Unknown',
      elementIcon: json['elementIcon'] ?? 'Unknown'
    );
  }
}