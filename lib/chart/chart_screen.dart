import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_chart_flutter/k_chart_flutter.dart';
import 'package:mcx/chart/chart_notifier.dart';
import 'package:mcx/data/market_notifier.dart';
import 'package:mcx/home_notifier.dart';

class ChartScreen extends ConsumerWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGrainIndex = ref.watch(selectedGrainNotifierProvider);
    final currentGrain = ref.read(marketProvider)[currentGrainIndex];
    final candles = ref.watch(chartProvider(currentGrainIndex));
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text("MCX . Chart [${currentGrain.name}]")),
      body: candles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : KChartWidget(
              data: candles,
              style: ChartStyle(
                depth: DepthColors(),
                colors: ChartColors(
                  background: [colorScheme.surface, colorScheme.surface],
                ),
              ),
              isLine: false,
              mainState: MainState.NONE,
              secondaryState: SecondaryState.NONE,
              hideGrid: false,
              showNowPrice: true,
              showInfoDialog: true,
              volHidden: true,
              isTrendLine: false,
              timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
            ),
    );
  }
}

class MyChartColors extends ChartColors {
  @override
  Color get upColor => Colors.green;

  @override
  Color get downColor => Colors.red;

  // Add any other color overrides you need
}