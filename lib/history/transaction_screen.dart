import 'package:flutter/material.dart';
import 'package:mcx/trade/trade_screen.dart';
// Import your data class and list item widget
import 'transaction_item.dart';
import 'transaction_list_item.dart';

class TransactionScreen extends StatelessWidget {
  final List<TransactionItem> transactions = [
    TransactionItem(
      pair: 'RICE',
      type: 'buy, in',
      lotSize: 0.03,
      price: 120000,
      timestamp: '2025.09.02 07:40:28',
    ),
    TransactionItem(
      pair: 'BEAN',
      type: 'sell, out',
      lotSize: 0.03,
      price: 200000,
      timestamp: '2025.09.02 07:42:58',
      profit: 6000,
    ),
    // Add more items here...
    TransactionItem(
      pair: 'RICE',
      type: 'sell, out',
      lotSize: 1.00,
      price: 29000,
      timestamp: '2025.09.02 07:54:30',
      profit: -344444,
    ),
    TransactionItem(
      pair: 'CHILLI',
      type: 'sell, out',
      lotSize: 0.03,
      price: 230000,
      timestamp: '2025.09.02 07:56:59',
      profit: -3449999,
    ),
    TransactionItem(
      pair: 'BEAN',
      type: 'sell, out',
      lotSize: 1.00,
      price: 399999,
      timestamp: '2025.09.02 11:32:29',
      profit: 20000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MCX . History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                AccountStatRow(label: 'Profit:', value: '34000'),
                AccountStatRow(label: 'Deposit', value: '2000'),
                AccountStatRow(label: 'Swap:', value: '5000'),
                AccountStatRow(label: 'Comission:', value: '0'),
                AccountStatRow(label: 'Balance:', value: '100000'),
              ],
            ),
          ),
          Divider(color: Theme.of(context).colorScheme.surfaceContainerHighest),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return TransactionListItem(item: transactions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
