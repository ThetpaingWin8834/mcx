// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:mcx/chart/chart_notifier.dart';
// import 'package:mcx/chart/chart_notifier2.dart';
// import 'package:mcx/data/market_notifier.dart';
// import 'package:mcx/home_notifier.dart';

// class ChartScreen2 extends ConsumerWidget {
//   const ChartScreen2({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentGrainIndex = ref.watch(selectedGrainNotifierProvider);
//     final currentGrain = ref.read(marketProvider)[currentGrainIndex];
//     final candles = ref.watch(chartNotifierProvider);
//     final colorScheme = Theme.of(context).colorScheme;

//     // Convert candles to FlSpot for LineChart
//     List<FlSpot> spots = [];
//     if (candles.isNotEmpty) {
//       spots = candles.map((e) => FlSpot(e.time.toDouble(), e.close)).toList();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("MCX . Chart2 [${currentGrain.name}]"),
//         actions: [CurrentPrice2(), SizedBox(width: 32)],
//       ),
//       body: candles.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: LineChart(
//                 LineChartData(
//                   gridData: FlGridData(show: true),
//                   titlesData: FlTitlesData(
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         reservedSize: 30,
//                         interval: (spots.length > 1)
//                             ? (spots.last.x - spots.first.x) / 4
//                             : 1,
//                         getTitlesWidget: (value, meta) {
//                           final date =
//                               DateTime.fromMillisecondsSinceEpoch(value.toInt());
//                           return Text('${date.month}/${date.day}');
//                         },
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//                     ),
//                     rightTitles: AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     topTitles: AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                   ),
//                   borderData: FlBorderData(show: true),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: spots,
//                       isCurved: true,
//                       color: colorScheme.primary,
//                       barWidth: 2,
//                       dotData: FlDotData(show: false),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

// class CurrentPrice2 extends ConsumerWidget {
//   const CurrentPrice2({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final candles = ref.watch(chartNotifierProvider);
//     if (candles.isEmpty) return SizedBox();

//     final price = candles.last.close;

//     return Container(
//       alignment: Alignment.center,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: Text(
//         price.toStringAsFixed(2),
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }