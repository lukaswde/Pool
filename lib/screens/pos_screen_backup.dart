import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/sale.dart';
import '../services/pos_service.dart';
import '../widgets/sales_history_widget.dart';
import '../widgets/shopping_cart_widget.dart';
import '../widgets/user_info_widget.dart';

class POSScreen extends StatefulWidget {
  final User? currentUser;
  final VoidCallback? onLogout;

  const POSScreen({
    super.key,
    this.currentUser,
    this.onLogout,
  });

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final POSService _posService = POSService();
  User? currentUser;
  List<CartItem> cartItems = [];
  List<Sale> salesHistory = [];

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    _loadMockData();
  }

  void _loadMockData() {
    // Use the passed current user or simulate login with first user
    final allUsers = _posService.getAllUsers();
    currentUser ??= allUsers.first;

    // Add some mock sales history
    salesHistory = [
      Sale(
        id: '1',
        itemDescription: 'Energy Drink',
        username: 'John Doe',
        price: 2.50,
        quantity: 1,
        time: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Sale(
        id: '2',
        itemDescription: 'Protein Bar',
        username: 'Jane Smith',
        price: 3.00,
        quantity: 1,
        time: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Sale(
        id: '3',
        itemDescription: 'Sports Water',
        username: 'Mike Johnson',
        price: 1.50,
        quantity: 2,
        time: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  void _simulateRFIDScan() {
    // Simulate RFID chip scan - cycle through users
    final allUsers = _posService.getAllUsers();
    final currentIndex = allUsers.indexOf(currentUser!);
    final nextIndex = (currentIndex + 1) % allUsers.length;

    setState(() {
      currentUser = allUsers[nextIndex];
      cartItems.clear(); // Clear cart when user changes
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome ${currentUser!.name}!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _simulateBarcodeScan() {
    // Simulate barcode scan - add random product
    final allProducts = _posService.getAllProducts();
    final product =
        allProducts[DateTime.now().millisecond % allProducts.length];
    _addToCart(product);
  }

  void _addToCart(Product product) {
    setState(() {
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingItemIndex >= 0) {
        cartItems[existingItemIndex].quantity++;
      } else {
        cartItems.add(CartItem(product: product));
      }
    });
  }

  void _removeFromCart(CartItem item) {
    setState(() {
      cartItems.remove(item);
    });
  }

  void _updateCartItemQuantity(CartItem item, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        cartItems.remove(item);
      } else {
        item.quantity = newQuantity;
      }
    });
  }

  void _processOrder() {
    if (cartItems.isEmpty || currentUser == null) return;

    final now = DateTime.now();
    final newSales = cartItems
        .map((item) => Sale(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              itemDescription: item.product.description,
              username: currentUser!.name,
              price: item.totalPrice,
              quantity: item.quantity,
              time: now,
            ))
        .toList();

    setState(() {
      salesHistory.insertAll(0, newSales);
      cartItems.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Order processed successfully! You have been logged out.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // Log out user after successful order
    Future.delayed(const Duration(seconds: 1), () {
      if (widget.onLogout != null) {
        widget.onLogout!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports Club POS'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.nfc),
            onPressed: _simulateRFIDScan,
            tooltip: 'Simulate RFID Scan',
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _simulateBarcodeScan,
            tooltip: 'Simulate Barcode Scan',
          ),
          if (widget.onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: widget.onLogout,
              tooltip: 'Logout',
            ),
        ],
      ),
      body: currentUser == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.nfc, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Please scan your RFID chip to log in',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                // Left side - Sales History
                Expanded(
                  flex: 3,
                  child: SalesHistoryWidget(sales: salesHistory),
                ),

                const VerticalDivider(width: 1),

                // Right side - User info and shopping cart
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // User info section
                      UserInfoWidget(user: currentUser!),

                      const Divider(),

                      // Shopping cart section
                      Expanded(
                        child: ShoppingCartWidget(
                          cartItems: cartItems,
                          onRemoveItem: _removeFromCart,
                          onUpdateQuantity: _updateCartItemQuantity,
                          onProcessOrder: _processOrder,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
