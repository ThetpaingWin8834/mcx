import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_chart_plus/chart_style.dart';
import 'package:k_chart_plus/k_chart_widget.dart';
import 'package:mcx/chart/chart_notifier.dart';
import 'package:mcx/chart/chart_notifier2.dart';
import 'package:mcx/data/market_notifier.dart';
import 'package:mcx/home_notifier.dart';

class ChartScreen extends ConsumerWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGrainIndex = ref.watch(selectedGrainNotifierProvider);
    final currentGrain = ref.read(marketProvider)[currentGrainIndex];
    final candles = ref.watch(chartNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text("MCX . Chart [${currentGrain.name}]")),
      body: candles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : KChartWidget(
              candles.map((e) => e.toKLineEntity()).toList(),
              ChartStyle(),
              ChartColors(),
              isLine: false,

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
