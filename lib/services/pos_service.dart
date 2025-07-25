import '../models/user.dart';
import '../models/product.dart';

class POSService {
  static final POSService _instance = POSService._internal();
  factory POSService() => _instance;
  POSService._internal();

  // Mock users database
  final List<User> _users = [
    User(id: '1', name: 'John Doe', rfidChip: 'RFID001'),
    User(id: '2', name: 'Jane Smith', rfidChip: 'RFID002'),
    User(id: '3', name: 'Mike Johnson', rfidChip: 'RFID003'),
    User(id: '4', name: 'Sarah Wilson', rfidChip: 'RFID004'),
    User(id: '5', name: 'Tom Brown', rfidChip: 'RFID005'),
  ];

  // Mock products database
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Energy Drink',
      description: 'Red Bull Energy Drink 250ml',
      price: 2.50,
      barcode: '9002490100018',
    ),
    Product(
      id: '2',
      name: 'Protein Bar',
      description: 'Protein Bar Chocolate 60g',
      price: 3.00,
      barcode: '4260097431034',
    ),
    Product(
      id: '3',
      name: 'Sports Water',
      description: 'Mineral Water 500ml',
      price: 1.50,
      barcode: '4006381333931',
    ),
    Product(
      id: '4',
      name: 'Isotonic Drink',
      description: 'Powerade Isotonic Drink 500ml',
      price: 2.00,
      barcode: '5449000131614',
    ),
    Product(
      id: '5',
      name: 'Protein Shake',
      description: 'Vanilla Protein Shake 330ml',
      price: 3.50,
      barcode: '8712566441235',
    ),
    Product(
      id: '6',
      name: 'Energy Bar',
      description: 'Oat & Honey Energy Bar 45g',
      price: 1.80,
      barcode: '7622210951465',
    ),
    Product(
      id: '7',
      name: 'Banana',
      description: 'Fresh Banana per piece',
      price: 0.80,
      barcode: '4011200296906',
    ),
    Product(
      id: '8',
      name: 'Apple',
      description: 'Fresh Apple per piece',
      price: 0.70,
      barcode: '4011200296913',
    ),
  ];

  /// Simulate RFID chip scanning
  User? authenticateByRFID(String rfidChip) {
    try {
      return _users.firstWhere((user) => user.rfidChip == rfidChip);
    } catch (e) {
      return null;
    }
  }

  /// Simulate barcode scanning
  Product? getProductByBarcode(String barcode) {
    try {
      return _products.firstWhere((product) => product.barcode == barcode);
    } catch (e) {
      return null;
    }
  }

  /// Get all users (for testing purposes)
  List<User> getAllUsers() => List.unmodifiable(_users);

  /// Get all products (for testing purposes)
  List<Product> getAllProducts() => List.unmodifiable(_products);

  /// Add a new user (for testing purposes)
  void addUser(User user) {
    _users.add(user);
  }

  /// Add a new product (for testing purposes)
  void addProduct(Product product) {
    _products.add(product);
  }

  /// Simulate processing a payment
  Future<bool> processPayment(String userId, double amount) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real implementation, this would integrate with a payment system
    // For now, we'll just return true to simulate successful payment
    return true;
  }

  /// Simulate saving a sale record
  Future<bool> saveSaleRecord({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real implementation, this would save to a database
    // For now, we'll just return true to simulate successful save
    return true;
  }
}
