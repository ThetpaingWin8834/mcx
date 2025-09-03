import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_chart_plus/chart_style.dart';
import 'package:k_chart_plus/k_chart_widget.dart';
import 'package:mcx/chart/buy_grain_sheet.dart';
import 'package:mcx/chart/chart_notifier2.dart';
import 'package:mcx/chart/sell_grain_sheet.dart';
import 'package:mcx/data/market_notifier.dart';
import 'package:mcx/home_notifier.dart';

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({super.key});

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  bool useCandle = true;
  @override
  Widget build(BuildContext context) {
    final currentGrainIndex = ref.watch(selectedGrainNotifierProvider);
    final currentGrain = ref.read(marketProvider)[currentGrainIndex];
    final candles = ref.watch(chartNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("MCX . Chart [${currentGrain.name}]"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                useCandle = !useCandle;
              });
            },
            icon: Icon(Icons.stacked_line_chart),
          ),
        ],
      ),
      body: candles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      button(
                        name: 'SELL',
                        color: Colors.redAccent,
                        onClick: onSellClick,
                      ),
                      button(name: 'BUY', onClick: onBuyClick),
                    ],
                  ),
                ),
                KChartWidget(
                  candles[currentGrainIndex]
                      .map((e) => e.toKLineEntity())
                      .toList(),
                  ChartStyle(),
                  ChartColors(bgColor: colorScheme.surface),
                  isLine: !useCandle,

                  hideGrid: false,
                  showNowPrice: true,
                  showInfoDialog: true,
                  volHidden: true,
                  isTrendLine: false,
                  timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                ),
              ],
            ),
    );
  }

  onBuyClick() {
    BuyGrainSheet.show(context);
  }

  onSellClick() {
    SellGrainSheet.show(context);
  }

  Widget button({
    required String name,
    VoidCallback? onClick,
    Color color = Colors.blue,
  }) {
    return FilledButton(
      onPressed: onClick,
      child: Text(name),
      style: FilledButton.styleFrom(
        minimumSize: Size(120, 45),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),

      child: Material(
        child: InkWell(
          onTap: onClick,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 12),

            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color,
            ),
            child: Text(name, style: TextStyle(color: getContrastColor(color))),
          ),
        ),
      ),
    );
  }
}

Color getContrastColor(Color background) {
  // Compute relative luminance (0 = dark, 1 = light)
  final double luminance = background.computeLuminance();

  // Return black for light backgrounds, white for dark backgrounds
  return luminance > 0.5 ? Colors.black : Colors.white;
}
