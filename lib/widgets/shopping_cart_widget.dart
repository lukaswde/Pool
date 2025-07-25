import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class ShoppingCartWidget extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(CartItem) onRemoveItem;
  final Function(CartItem, int) onUpdateQuantity;
  final VoidCallback? onProcessOrder;

  const ShoppingCartWidget({
    super.key,
    required this.cartItems,
    required this.onRemoveItem,
    required this.onUpdateQuantity,
    this.onProcessOrder,
  });

  double get totalAmount {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shopping Cart',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Cart items list
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Scan items to add them to your cart',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Product info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.product.description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '€${item.product.price.toStringAsFixed(2)} each',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Quantity controls
                              Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => onUpdateQuantity(
                                          item,
                                          item.quantity - 1,
                                        ),
                                        icon: const Icon(Icons.remove),
                                        iconSize: 20,
                                      ),
                                      Container(
                                        width: 40,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          '${item.quantity}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => onUpdateQuantity(
                                          item,
                                          item.quantity + 1,
                                        ),
                                        icon: const Icon(Icons.add),
                                        iconSize: 20,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '€${item.totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),

                              // Delete button
                              IconButton(
                                onPressed: () => onRemoveItem(item),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Total and checkout section
          if (cartItems.isNotEmpty) ...[
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '€${totalAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onProcessOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      onProcessOrder != null ? Colors.green : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  onProcessOrder != null
                      ? 'Process Order'
                      : 'Please scan RFID to continue',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
