import 'package:flutter/material.dart';
import 'package:mcx/history/transaction_item.dart';
import 'package:mcx/market/market_screen.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionItem item;

  const TransactionListItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color typeColor = item.type.contains('sell, out')
        ? Colors.red
        : Colors.blue;
    final Color profitColor = (item.profit ?? 0) >= 0
        ? Colors.blue
        : Colors.red;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${item.pair},",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item.type}',
                      style: TextStyle(color: typeColor, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  'in ${item.lotSize} at ${formatCurrencyAmount(item.price)}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
              ],
            ),
          ),
          if (item.profit != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.timestamp,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Text(
                  formatCurrencyAmount(item.profit ?? 0),
                  style: TextStyle(
                    color: profitColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          else
            Text(
              item.timestamp,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
        ],
      ),
    );
  }
}
