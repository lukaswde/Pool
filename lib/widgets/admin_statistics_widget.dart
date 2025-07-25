import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/sale.dart';

class AdminStatisticsWidget extends StatefulWidget {
  final List<User> users;
  final List<Product> products;
  final List<Sale> sales;
  final VoidCallback onRefresh;

  const AdminStatisticsWidget({
    super.key,
    required this.users,
    required this.products,
    required this.sales,
    required this.onRefresh,
  });

  @override
  State<AdminStatisticsWidget> createState() => _AdminStatisticsWidgetState();
}

class _AdminStatisticsWidgetState extends State<AdminStatisticsWidget> {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  final DateFormat _dayFormat = DateFormat('dd/MM/yyyy');

  Map<String, double> _getTopProducts() {
    final productSales = <String, double>{};

    for (final sale in widget.sales) {
      productSales[sale.itemDescription] =
          (productSales[sale.itemDescription] ?? 0) + sale.price;
    }

    final sorted = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sorted.take(5));
  }

  Map<String, double> _getTopCustomers() {
    final customerSales = <String, double>{};

    for (final sale in widget.sales) {
      customerSales[sale.username] =
          (customerSales[sale.username] ?? 0) + sale.price;
    }

    final sorted = customerSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sorted.take(5));
  }

  Map<String, double> _getDailySales() {
    final dailySales = <String, double>{};

    for (final sale in widget.sales) {
      final day = _dayFormat.format(sale.time);
      dailySales[day] = (dailySales[day] ?? 0) + sale.price;
    }

    final sorted = dailySales.entries.toList()
      ..sort(
          (a, b) => _dayFormat.parse(b.key).compareTo(_dayFormat.parse(a.key)));

    return Map.fromEntries(sorted.take(7));
  }

  double get _totalRevenue {
    return widget.sales.fold(0.0, (sum, sale) => sum + sale.price);
  }

  int get _totalTransactions {
    return widget.sales.length;
  }

  double get _averageTransactionValue {
    return _totalTransactions > 0 ? _totalRevenue / _totalTransactions : 0.0;
  }

  List<Sale> get _todaysSales {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return widget.sales.where((sale) => sale.time.isAfter(startOfDay)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final topProducts = _getTopProducts();
    final topCustomers = _getTopCustomers();
    final dailySales = _getDailySales();
    final todayRevenue =
        _todaysSales.fold(0.0, (sum, sale) => sum + sale.price);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Statistics Overview',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ElevatedButton.icon(
                  onPressed: widget.onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Revenue',
                    value: '€${_totalRevenue.toStringAsFixed(2)}',
                    icon: Icons.euro,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Today\'s Revenue',
                    value: '€${todayRevenue.toStringAsFixed(2)}',
                    icon: Icons.today,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Sales',
                    value: _totalTransactions.toString(),
                    icon: Icons.shopping_cart,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Avg. Transaction',
                    value: '€${_averageTransactionValue.toStringAsFixed(2)}',
                    icon: Icons.analytics,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Users',
                    value: widget.users.length.toString(),
                    icon: Icons.people,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Total Products',
                    value: widget.products.length.toString(),
                    icon: Icons.inventory,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Top Products
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Selling Products',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (topProducts.isEmpty)
                      const Center(child: Text('No sales data available'))
                    else
                      ...topProducts.entries.map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  '€${entry.value.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Top Customers
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Customers',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (topCustomers.isEmpty)
                      const Center(child: Text('No sales data available'))
                    else
                      ...topCustomers.entries.map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  '€${entry.value.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Daily Sales
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Sales (Last 7 Days)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (dailySales.isEmpty)
                      const Center(child: Text('No sales data available'))
                    else
                      ...dailySales.entries.map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '€${entry.value.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recent Sales
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Sales',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (widget.sales.isEmpty)
                      const Center(child: Text('No sales data available'))
                    else
                      ...widget.sales.take(10).map((sale) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    sale.itemDescription,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    sale.username,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '€${sale.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _dateFormat.format(sale.time),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
