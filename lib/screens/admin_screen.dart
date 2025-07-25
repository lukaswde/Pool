import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/sale.dart';
import '../services/firebase_service.dart';
import '../widgets/admin_users_widget.dart';
import '../widgets/admin_products_widget.dart';
import '../widgets/admin_statistics_widget.dart';

class AdminScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const AdminScreen({
    super.key,
    this.onLogout,
  });

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseService _firebaseService = FirebaseService();

  List<User> _users = [];
  List<Product> _products = [];
  List<Sale> _sales = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await _firebaseService.getAllUsers();
      final products = await _firebaseService.getAllProducts();
      final sales = await _firebaseService.getRecentSales(limit: 100);

      setState(() {
        _users = users;
        _products = products;
        _sales = sales;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
            tooltip: 'Back to POS',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.inventory), text: 'Products'),
            Tab(icon: Icon(Icons.analytics), text: 'Statistics'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading admin data...'),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                AdminUsersWidget(
                  users: _users,
                  onRefresh: _refreshData,
                ),
                AdminProductsWidget(
                  products: _products,
                  onRefresh: _refreshData,
                ),
                AdminStatisticsWidget(
                  users: _users,
                  products: _products,
                  sales: _sales,
                  onRefresh: _refreshData,
                ),
              ],
            ),
    );
  }
}
