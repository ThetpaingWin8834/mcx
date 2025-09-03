import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mcx/chart/buy_grain_sheet.dart';

import 'package:mcx/data/market_notifier.dart';
import 'package:mcx/home_notifier.dart';
import 'package:mcx/user_notifier.dart';

class SellGrainSheet extends ConsumerStatefulWidget {
  static show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) => SellGrainSheet(),
    );
  }

  const SellGrainSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SellGrainSheetState();
}

class _SellGrainSheetState extends ConsumerState<SellGrainSheet> {
  TradeOptions tradeOptions = TradeOptions.market;
  final priceController = TextEditingController();
  final amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    priceController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentGrainIndex = ref.read(selectedGrainNotifierProvider);
    final grain = ref.read(marketProvider)[currentGrainIndex];
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ref.listen(marketProvider, (previous, next) {
      if (tradeOptions == TradeOptions.limit) {
        return;
      }
      final index = ref.read(selectedGrainNotifierProvider);
      final grain = next[index];
      priceController.text = ThousandsSeparatorInputFormatter.formatNumber(
        grain.currentPrice,
      );
    });
    final user = ref.watch(userNotifierProvider);
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SheetHandleIndicator(),
              Text(
                "SELL ${grain.name}",
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Balance: ${user.currentBalance}',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              DropdownSelector(
                tradeOptions: tradeOptions,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      tradeOptions = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              PriceInputRow(
                tradeOptions: tradeOptions,
                priceController: priceController,
              ),
              const SizedBox(height: 20),
              AmountInputRow(
                formKey: formKey,
                tradeOptions: tradeOptions,
                amountController: amountController,
              ),
              ValueListenableBuilder(
                valueListenable: amountController,
                builder: (context, value, child) {
                  final amount =
                      int.tryParse(value.text.replaceAll(',', '')) ?? 0;
                  final percent = (amount / user.currentBalance)
                      .clamp(0, 1)
                      .toDouble();
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: percent,
                              onChanged: (value) {
                                amountController.text =
                                    ThousandsSeparatorInputFormatter.formatNumber(
                                      (user.currentBalance * value).round(),
                                    );
                              },
                            ),
                          ),
                          Text('${(percent * 100).round()}%'),
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: priceController,
                        builder: (context, value, child) {
                          final price =
                              (num.tryParse(value.text.replaceAll(',', '')) ??
                                      0)
                                  .round();
                          final available = amount / price;
                          return Text(
                            'Available: ${available.toStringAsFixed(1)}',
                            style: textTheme.labelLarge?.copyWith(
                              color: Colors.green,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              SellButton(onPressed: () {}),
              SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
            ],
          ),
        ),
      ),
    );
  }
}

class SheetHandleIndicator extends StatelessWidget {
  const SheetHandleIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 5,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class DropdownSelector extends StatelessWidget {
  final TradeOptions tradeOptions;
  final ValueChanged<TradeOptions?> onChanged;

  const DropdownSelector({
    super.key,
    required this.tradeOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<TradeOptions>(
        value: tradeOptions,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        style: textTheme.titleMedium?.copyWith(
          fontSize: 16,
          color: Colors.black87,
        ),
        items: TradeOptions.values
            .map(
              (e) => DropdownMenuItem<TradeOptions>(
                value: e,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(e.displayName),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        dropdownColor: Theme.of(context).canvasColor,
        iconEnabledColor: colorScheme.primary,
      ),
    );
  }
}

class SellButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SellButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          elevation: 4,
          shadowColor: colorScheme.primary.withOpacity(0.4),
        ),
        child: const Text('Sell'),
      ),
    );
  }
}
