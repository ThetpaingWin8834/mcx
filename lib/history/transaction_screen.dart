import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mcx/data/market_notifier.dart';
import 'package:mcx/trade/trade_screen.dart';
// Import your data class and list item widget
import 'transaction_item.dart';
import 'transaction_list_item.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  String getRandomName() {
    final grainList = ref.read(marketProvider);
    return grainList[Random().nextInt(grainList.length)].name;
  }

  late final List<TransactionItem> transactions = [
    TransactionItem(
      pair: getRandomName(),
      type: 'buy, in',
      lotSize: 0.03,
      price: 120000,
      profit: 36000,
      timestamp: '2025.09.02 07:40:28',
    ),
    TransactionItem(
      pair: getRandomName(),
      type: 'sell, out',
      lotSize: 0.03,
      price: 200000,
      timestamp: '2025.09.02 07:42:58',
      profit: 6000,
    ),
    // Add more items here...
    TransactionItem(
      pair: getRandomName(),
      type: 'sell, out',
      lotSize: 1.00,
      price: 29000,
      timestamp: '2025.09.02 07:54:30',
      profit: -344444,
    ),
    TransactionItem(
      pair: getRandomName(),
      type: 'sell, out',
      lotSize: 0.03,
      price: 230000,
      timestamp: '2025.09.02 07:56:59',
      profit: -34000,
    ),
    TransactionItem(
      pair: getRandomName(),
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
              children: [AccountStatRow(label: 'Profit:', value: '34,000')],
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
