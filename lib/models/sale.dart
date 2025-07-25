class Sale {
  final String id;
  final String itemDescription;
  final String username;
  final double price;
  final int quantity;
  final DateTime time;

  Sale({
    required this.id,
    required this.itemDescription,
    required this.username,
    required this.price,
    required this.quantity,
    required this.time,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      itemDescription: json['itemDescription'],
      username: json['username'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemDescription': itemDescription,
      'username': username,
      'price': price,
      'quantity': quantity,
      'time': time.toIso8601String(),
    };
  }
}
