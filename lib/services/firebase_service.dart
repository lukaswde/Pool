import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/sale.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _productsCollection =>
      _firestore.collection('products');
  CollectionReference get _salesCollection => _firestore.collection('sales');

  // Initialize with sample data (call this once when setting up)
  Future<void> initializeSampleData() async {
    try {
      print('Starting Firebase initialization...');

      // Check if data already exists to avoid duplicate initialization
      final usersSnapshot = await _usersCollection.limit(1).get();
      if (usersSnapshot.docs.isNotEmpty) {
        print('Sample data already exists, skipping initialization');
        return;
      }

      print('Initializing users...');
      await _initializeUsers();
      print('Initializing products...');
      await _initializeProducts();
      print('Initializing sample sales...');
      await _initializeSampleSales();
      print('Firebase initialization completed successfully');
    } catch (e) {
      print('Error during Firebase initialization: $e');
      rethrow;
    }
  }

  // Force re-initialize data (clears existing data first)
  Future<void> reinitializeSampleData() async {
    try {
      print('Starting Firebase re-initialization...');

      print('Clearing existing data...');
      await _clearAllData();

      print('Initializing users...');
      await _initializeUsers();
      print('Initializing products...');
      await _initializeProducts();
      print('Initializing sample sales...');
      await _initializeSampleSales();
      print('Firebase re-initialization completed successfully');
    } catch (e) {
      print('Error during Firebase re-initialization: $e');
      rethrow;
    }
  }

  Future<void> _clearAllData() async {
    // Clear users
    final usersSnapshot = await _usersCollection.get();
    for (var doc in usersSnapshot.docs) {
      await doc.reference.delete();
    }

    // Clear products
    final productsSnapshot = await _productsCollection.get();
    for (var doc in productsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Clear sales
    final salesSnapshot = await _salesCollection.get();
    for (var doc in salesSnapshot.docs) {
      await doc.reference.delete();
    }

    print('All existing data cleared');
  }

  Future<void> _initializeUsers() async {
    final users = [
      // Club Members
      User(id: '1', name: 'John Doe', rfidChip: 'RFID001'),
      User(id: '2', name: 'Jane Smith', rfidChip: 'RFID002'),
      User(id: '3', name: 'Mike Johnson', rfidChip: 'RFID003'),
      User(id: '4', name: 'Sarah Wilson', rfidChip: 'RFID004'),
      User(id: '5', name: 'Tom Brown', rfidChip: 'RFID005'),
      User(id: '6', name: 'Emily Davis', rfidChip: 'RFID006'),
      User(id: '7', name: 'David Miller', rfidChip: 'RFID007'),
      User(id: '8', name: 'Lisa Garcia', rfidChip: 'RFID008'),
      User(id: '9', name: 'Chris Anderson', rfidChip: 'RFID009'),
      User(id: '10', name: 'Amanda Taylor', rfidChip: 'RFID010'),
      User(id: '11', name: 'Robert Martinez', rfidChip: 'RFID011'),
      User(id: '12', name: 'Jessica Rodriguez', rfidChip: 'RFID012'),
      User(id: '13', name: 'Kevin Lee', rfidChip: 'RFID013'),
      User(id: '14', name: 'Nicole White', rfidChip: 'RFID014'),
      User(id: '15', name: 'Steven Clark', rfidChip: 'RFID015'),
      User(id: '16', name: 'Rachel Green', rfidChip: 'RFID016'),
      User(id: '17', name: 'Mark Thompson', rfidChip: 'RFID017'),
      User(id: '18', name: 'Ashley Moore', rfidChip: 'RFID018'),
      User(id: '19', name: 'Daniel Jackson', rfidChip: 'RFID019'),
      User(id: '20', name: 'Megan Hall', rfidChip: 'RFID020'),
    ];

    for (var user in users) {
      await _usersCollection.doc(user.id).set(user.toJson());
    }
  }

  Future<void> _initializeProducts() async {
    final products = [
      // Energy & Sports Drinks
      Product(
        id: '1',
        name: 'Red Bull Energy',
        description: 'Red Bull Energy Drink 250ml',
        price: 2.50,
        barcode: '9002490100018',
      ),
      Product(
        id: '2',
        name: 'Monster Energy',
        description: 'Monster Energy Drink 500ml',
        price: 3.20,
        barcode: '7042690012346',
      ),
      Product(
        id: '3',
        name: 'Powerade Blue',
        description: 'Powerade Isotonic Drink Blue 500ml',
        price: 2.00,
        barcode: '5449000131614',
      ),
      Product(
        id: '4',
        name: 'Gatorade Orange',
        description: 'Gatorade Sports Drink Orange 500ml',
        price: 2.10,
        barcode: '8851019505823',
      ),
      Product(
        id: '5',
        name: 'Rockstar Energy',
        description: 'Rockstar Energy Drink 500ml',
        price: 2.80,
        barcode: '8881019505890',
      ),

      // Protein & Nutrition
      Product(
        id: '6',
        name: 'Protein Bar Chocolate',
        description: 'Whey Protein Bar Chocolate 60g',
        price: 3.00,
        barcode: '4260097431034',
      ),
      Product(
        id: '7',
        name: 'Protein Bar Vanilla',
        description: 'Whey Protein Bar Vanilla 60g',
        price: 3.00,
        barcode: '4260097431041',
      ),
      Product(
        id: '8',
        name: 'Protein Shake',
        description: 'Ready-to-drink Protein Shake 330ml',
        price: 3.50,
        barcode: '8712566441235',
      ),
      Product(
        id: '9',
        name: 'Energy Bar',
        description: 'Oat & Honey Energy Bar 45g',
        price: 1.80,
        barcode: '7622210951465',
      ),
      Product(
        id: '10',
        name: 'Granola Bar',
        description: 'Crunchy Granola Bar with Nuts 40g',
        price: 1.60,
        barcode: '7622210951472',
      ),

      // Water & Hydration
      Product(
        id: '11',
        name: 'Sports Water',
        description: 'Electrolyte Enhanced Water 500ml',
        price: 1.50,
        barcode: '4006381333931',
      ),
      Product(
        id: '12',
        name: 'Sparkling Water',
        description: 'Natural Sparkling Water 500ml',
        price: 1.20,
        barcode: '4006381333948',
      ),
      Product(
        id: '13',
        name: 'Coconut Water',
        description: 'Pure Coconut Water 330ml',
        price: 2.30,
        barcode: '8901030001234',
      ),

      // Fresh Fruits & Snacks
      Product(
        id: '14',
        name: 'Banana',
        description: 'Fresh Banana per piece',
        price: 0.80,
        barcode: '4011200296906',
      ),
      Product(
        id: '15',
        name: 'Apple',
        description: 'Fresh Apple per piece',
        price: 0.70,
        barcode: '4011200296913',
      ),
      Product(
        id: '16',
        name: 'Orange',
        description: 'Fresh Orange per piece',
        price: 0.90,
        barcode: '4011200296920',
      ),
      Product(
        id: '17',
        name: 'Trail Mix',
        description: 'Mixed Nuts & Dried Fruits 50g',
        price: 2.20,
        barcode: '8901234567890',
      ),
      Product(
        id: '18',
        name: 'Protein Crackers',
        description: 'High-Protein Crackers 30g',
        price: 1.90,
        barcode: '8901234567907',
      ),

      // Recovery & Supplements
      Product(
        id: '19',
        name: 'Recovery Drink',
        description: 'Post-Workout Recovery Drink 250ml',
        price: 4.20,
        barcode: '8901234567914',
      ),
      Product(
        id: '20',
        name: 'Electrolyte Powder',
        description: 'Electrolyte Powder Sachet (1 serving)',
        price: 1.50,
        barcode: '8901234567921',
      ),

      // Healthy Snacks
      Product(
        id: '21',
        name: 'Yogurt Cup',
        description: 'Greek Yogurt with Berries 150g',
        price: 2.80,
        barcode: '8901234567938',
      ),
      Product(
        id: '22',
        name: 'Smoothie Bowl',
        description: 'Acai Smoothie Bowl 200g',
        price: 5.50,
        barcode: '8901234567945',
      ),
      Product(
        id: '23',
        name: 'Nut Butter Bar',
        description: 'Almond Butter Energy Bar 40g',
        price: 2.40,
        barcode: '8901234567952',
      ),
      Product(
        id: '24',
        name: 'Keto Bar',
        description: 'Low-Carb Keto Bar 35g',
        price: 3.80,
        barcode: '8901234567969',
      ),
      Product(
        id: '25',
        name: 'Vitamin Water',
        description: 'Vitamin Enhanced Water 500ml',
        price: 1.80,
        barcode: '8901234567976',
      ),
    ];

    for (var product in products) {
      await _productsCollection.doc(product.id).set(product.toJson());
    }
  }

  Future<void> _initializeSampleSales() async {
    final now = DateTime.now();
    final userNames = [
      'John Doe',
      'Jane Smith',
      'Mike Johnson',
      'Sarah Wilson',
      'Tom Brown',
      'Emily Davis',
      'David Miller',
      'Lisa Garcia',
      'Chris Anderson',
      'Amanda Taylor',
      'Robert Martinez',
      'Jessica Rodriguez',
      'Kevin Lee',
      'Nicole White',
      'Steven Clark',
      'Rachel Green',
      'Mark Thompson',
      'Ashley Moore',
      'Daniel Jackson',
      'Megan Hall'
    ];

    final productDescriptions = [
      'Red Bull Energy Drink 250ml',
      'Monster Energy Drink 500ml',
      'Powerade Isotonic Drink Blue 500ml',
      'Gatorade Sports Drink Orange 500ml',
      'Rockstar Energy Drink 500ml',
      'Whey Protein Bar Chocolate 60g',
      'Whey Protein Bar Vanilla 60g',
      'Ready-to-drink Protein Shake 330ml',
      'Oat & Honey Energy Bar 45g',
      'Crunchy Granola Bar with Nuts 40g',
      'Electrolyte Enhanced Water 500ml',
      'Natural Sparkling Water 500ml',
      'Pure Coconut Water 330ml',
      'Fresh Banana per piece',
      'Fresh Apple per piece',
      'Fresh Orange per piece',
      'Mixed Nuts & Dried Fruits 50g',
      'High-Protein Crackers 30g',
      'Post-Workout Recovery Drink 250ml',
      'Electrolyte Powder Sachet (1 serving)',
      'Greek Yogurt with Berries 150g',
      'Acai Smoothie Bowl 200g',
      'Almond Butter Energy Bar 40g',
      'Low-Carb Keto Bar 35g',
      'Vitamin Enhanced Water 500ml'
    ];

    final productPrices = [
      2.50,
      3.20,
      2.00,
      2.10,
      2.80,
      3.00,
      3.00,
      3.50,
      1.80,
      1.60,
      1.50,
      1.20,
      2.30,
      0.80,
      0.70,
      0.90,
      2.20,
      1.90,
      4.20,
      1.50,
      2.80,
      5.50,
      2.40,
      3.80,
      1.80
    ];

    final sampleSales = <Sale>[];
    int saleId = 1;

    // Generate sales for the last 30 days
    for (int day = 0; day < 30; day++) {
      final saleDate = now.subtract(Duration(days: day));

      // Generate 5-15 random sales per day
      final dailySalesCount =
          5 + (day * 2) % 11; // Vary between 5-15 sales per day

      for (int sale = 0; sale < dailySalesCount; sale++) {
        final randomHour =
            8 + (sale * 3) % 12; // Spread sales throughout business hours
        final randomMinute = (sale * 17) % 60;
        final saleTime = DateTime(
          saleDate.year,
          saleDate.month,
          saleDate.day,
          randomHour,
          randomMinute,
        );

        final userIndex = (saleId * 7) % userNames.length;
        final productIndex = (saleId * 11) % productDescriptions.length;
        final quantity = 1 + (saleId % 3); // 1-3 items
        final unitPrice = productPrices[productIndex];
        final totalPrice = unitPrice * quantity;

        sampleSales.add(Sale(
          id: saleId.toString(),
          itemDescription: productDescriptions[productIndex],
          username: userNames[userIndex],
          price: totalPrice,
          quantity: quantity,
          time: saleTime,
        ));

        saleId++;
      }
    }

    // Add some recent sales (last few hours)
    final recentSales = [
      Sale(
        id: saleId.toString(),
        itemDescription: 'Red Bull Energy Drink 250ml',
        username: 'John Doe',
        price: 2.50,
        quantity: 1,
        time: now.subtract(const Duration(minutes: 10)),
      ),
      Sale(
        id: (saleId + 1).toString(),
        itemDescription: 'Whey Protein Bar Chocolate 60g',
        username: 'Jane Smith',
        price: 6.00,
        quantity: 2,
        time: now.subtract(const Duration(minutes: 25)),
      ),
      Sale(
        id: (saleId + 2).toString(),
        itemDescription: 'Fresh Banana per piece',
        username: 'Mike Johnson',
        price: 1.60,
        quantity: 2,
        time: now.subtract(const Duration(minutes: 45)),
      ),
      Sale(
        id: (saleId + 3).toString(),
        itemDescription: 'Electrolyte Enhanced Water 500ml',
        username: 'Sarah Wilson',
        price: 1.50,
        quantity: 1,
        time: now.subtract(const Duration(hours: 1)),
      ),
      Sale(
        id: (saleId + 4).toString(),
        itemDescription: 'Post-Workout Recovery Drink 250ml',
        username: 'Tom Brown',
        price: 4.20,
        quantity: 1,
        time: now.subtract(const Duration(hours: 1, minutes: 30)),
      ),
      Sale(
        id: (saleId + 5).toString(),
        itemDescription: 'Acai Smoothie Bowl 200g',
        username: 'Emily Davis',
        price: 11.00,
        quantity: 2,
        time: now.subtract(const Duration(hours: 2)),
      ),
      Sale(
        id: (saleId + 6).toString(),
        itemDescription: 'Greek Yogurt with Berries 150g',
        username: 'David Miller',
        price: 2.80,
        quantity: 1,
        time: now.subtract(const Duration(hours: 2, minutes: 15)),
      ),
      Sale(
        id: (saleId + 7).toString(),
        itemDescription: 'Monster Energy Drink 500ml',
        username: 'Lisa Garcia',
        price: 3.20,
        quantity: 1,
        time: now.subtract(const Duration(hours: 3)),
      ),
    ];

    sampleSales.addAll(recentSales);

    // Upload all sales to Firebase
    print('Uploading ${sampleSales.length} sample sales...');
    for (var sale in sampleSales) {
      await _salesCollection.doc(sale.id).set(sale.toJson());
    }
    print('Sample sales uploaded successfully');
  }

  // User operations
  Future<User?> authenticateByRFID(String rfidChip) async {
    try {
      final querySnapshot = await _usersCollection
          .where('rfidChip', isEqualTo: rfidChip)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return User.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      print('Error authenticating user: $e');
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await _usersCollection.get();
      return querySnapshot.docs
          .map((doc) => User.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  // Product operations
  Future<Product?> getProductByBarcode(String barcode) async {
    try {
      final querySnapshot = await _productsCollection
          .where('barcode', isEqualTo: barcode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return Product.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final querySnapshot = await _productsCollection.get();
      return querySnapshot.docs
          .map((doc) => Product.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  // Sales operations
  Future<String> addSale(Sale sale) async {
    try {
      final docRef = await _salesCollection.add(sale.toJson());
      return docRef.id;
    } catch (e) {
      print('Error adding sale: $e');
      throw e;
    }
  }

  Future<List<Sale>> getRecentSales({int limit = 50}) async {
    try {
      final querySnapshot = await _salesCollection
          .orderBy('time', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Sale.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      print('Error getting sales: $e');
      return [];
    }
  }

  // Real-time sales stream
  Stream<List<Sale>> getSalesStream({int limit = 50}) {
    return _salesCollection
        .orderBy('time', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Sale.fromJson({
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                }))
            .toList());
  }

  // Process multiple sales (for cart checkout)
  Future<void> processSales(List<Sale> sales) async {
    try {
      final batch = _firestore.batch();

      for (var sale in sales) {
        final docRef = _salesCollection.doc();
        batch.set(docRef, sale.toJson());
      }

      await batch.commit();
    } catch (e) {
      print('Error processing sales: $e');
      throw e;
    }
  }

  // Admin methods for managing users
  Future<void> addUser(User user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toJson());
    } catch (e) {
      print('Error adding user: $e');
      throw e;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toJson());
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
      throw e;
    }
  }

  // Admin methods for managing products
  Future<void> addProduct(Product product) async {
    try {
      await _productsCollection.doc(product.id).set(product.toJson());
    } catch (e) {
      print('Error adding product: $e');
      throw e;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _productsCollection.doc(product.id).update(product.toJson());
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    }
  }
}
