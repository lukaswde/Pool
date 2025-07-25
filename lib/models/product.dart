class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String barcode;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.barcode,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      barcode: json['barcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'barcode': barcode,
    };
  }
}
