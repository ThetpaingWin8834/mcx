import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mcx/data/market_notifier.dart';
import 'package:mcx/home_notifier.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    final market = ref.watch(marketProvider);
    ref.invalidate(selectedGrainNotifierProvider);
    final borderColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Scaffold(
      appBar: AppBar(title: Text('MCX . Market')),
      body: ListView.builder(
        itemCount: market.length,

        itemBuilder: (context, index) {
          final grain = market[index];
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor, width: 0.7),
              ),
            ),
            child: ListTile(
              title: Text(grain.name),
              onTap: () {
                ref.read(selectedGrainNotifierProvider.notifier).state = index;
                ref.read(homeNotifierProvider.notifier).state = 1;
              },
              trailing: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${grain.openPrice} . ',
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    TextSpan(
                      text: '${grain.currentPrice}',
                      style: TextStyle(
                        color: grain.currentPrice >= grain.openPrice
                            ? Colors.green
                            : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
