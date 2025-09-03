import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mcx/data/market_notifier.dart';
import 'package:mcx/home_notifier.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  @override
  void didUpdateWidget(covariant MarketScreen oldWidget) {
    print('diiiiiiî');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.invalidate(selectedGrainNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    final market = ref.watch(marketProvider);
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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.grass,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        grain.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          // letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'per TON',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              onTap: () {
                ref.read(selectedGrainNotifierProvider.notifier).state = index;
                ref.read(homeNotifierProvider.notifier).state = 1;
              },
              trailing: Column(
                spacing: 2,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${formatCurrencyAmount(grain.openPrice)} . ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: '${formatCurrencyAmount(grain.currentPrice)} ',
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
                  Text(
                    '${(((grain.currentPrice - grain.openPrice) / grain.openPrice) * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: grain.currentPrice >= grain.openPrice
                          ? Colors.green
                          : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String formatCurrencyAmount(num number) {
  final numberFormat = NumberFormat('###,###,###,###,###,###.##');
  return numberFormat.format(number);
}
