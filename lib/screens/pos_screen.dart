import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/sale.dart';
import '../services/firebase_service.dart';
import '../widgets/sales_history_widget.dart';
import '../widgets/shopping_cart_widget.dart';
import '../widgets/user_info_widget.dart';

class POSScreen extends StatefulWidget {
  final User? currentUser;
  final VoidCallback? onLogout;
  final Function(User)? onUserAuthenticated;
  final VoidCallback? onAdminAccess;

  const POSScreen({
    super.key,
    this.currentUser,
    this.onLogout,
    this.onUserAuthenticated,
    this.onAdminAccess,
  });

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  User? currentUser;
  List<CartItem> cartItems = [];
  List<Sale> salesHistory = [];

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    _loadFirebaseData();
  }

  Future<void> _loadFirebaseData() async {
    try {
      // Load recent sales from Firebase
      final recentSales = await _firebaseService.getRecentSales(limit: 50);
      setState(() {
        salesHistory = recentSales;
      });
    } catch (e) {
      print('Error loading sales: $e');
      // Continue with empty sales history if Firebase fails
    }
  }

  void _simulateRFIDScan() async {
    // Simulate RFID chip scan - cycle through users
    final allUsers = await _firebaseService.getAllUsers();

    User nextUser;
    if (currentUser == null) {
      // If no user is logged in, start with first user
      nextUser = allUsers.first;
    } else {
      // Cycle to next user
      final currentIndex = allUsers.indexOf(currentUser!);
      final nextIndex = (currentIndex + 1) % allUsers.length;
      nextUser = allUsers[nextIndex];
    }

    setState(() {
      currentUser = nextUser;
      cartItems.clear(); // Clear cart when user changes
    });

    // Notify parent about user authentication
    if (widget.onUserAuthenticated != null) {
      widget.onUserAuthenticated!(nextUser);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome ${nextUser.name}!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _simulateBarcodeScan() async {
    // Only allow barcode scanning when a user is logged in
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please scan your RFID chip first to start shopping'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Simulate barcode scan - add random product
    final allProducts = await _firebaseService.getAllProducts();
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

  void _processOrder() async {
    if (cartItems.isEmpty || currentUser == null) return;

    try {
      // Process each cart item as a separate sale in Firebase
      for (final item in cartItems) {
        final sale = Sale(
          id: '', // Firebase will generate the ID
          itemDescription: item.product.description,
          username: currentUser!.name,
          price: item.totalPrice,
          quantity: item.quantity,
          time: DateTime.now(),
        );

        await _firebaseService.addSale(sale);
      }

      setState(() {
        cartItems.clear();
      });

      // Reload sales history to show the new sales
      _loadFirebaseData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order processed successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Clear current user after successful order
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          currentUser = null;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing order: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _logout() {
    setState(() {
      currentUser = null;
      cartItems.clear(); // Also clear cart on manual logout
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports Club POS'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: widget.onAdminAccess,
            tooltip: 'Admin Panel',
          ),
          const VerticalDivider(),
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
          if (currentUser != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
        ],
      ),
      body: Row(
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
                // User info section or login prompt
                currentUser != null
                    ? UserInfoWidget(user: currentUser!)
                    : Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.nfc,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Scan RFID chip to start...',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                const Divider(),

                // Shopping cart section
                Expanded(
                  child: ShoppingCartWidget(
                    cartItems: cartItems,
                    onRemoveItem: _removeFromCart,
                    onUpdateQuantity: _updateCartItemQuantity,
                    onProcessOrder: currentUser != null ? _processOrder : null,
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
