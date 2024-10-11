class ServiceItem {
  final String name;
  final int price;
  final String imagePath;

  ServiceItem({
    required this.name,
    required this.price,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imagePath': imagePath,
    };
  }

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      name: map['name'] ?? '',
      price: map['price'] ?? 0,
      imagePath: map['imagePath'] ?? '',
    );
  }
}
