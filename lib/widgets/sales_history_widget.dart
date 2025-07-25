import 'package:flutter/material.dart';
import '../models/sale.dart';
import 'package:intl/intl.dart';

class SalesHistoryWidget extends StatelessWidget {
  final List<Sale> sales;

  const SalesHistoryWidget({
    super.key,
    required this.sales,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Sales',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: sales.isEmpty
                ? const Center(
                    child: Text(
                      'No sales yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: DataTable(
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Item Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Quantity',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Username',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Price',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Time',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: sales.map((sale) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                sale.itemDescription,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DataCell(
                              Text(
                                '${sale.quantity}x',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(Text(sale.username)),
                            DataCell(
                              Text(
                                '€${sale.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                DateFormat('HH:mm').format(sale.time),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
