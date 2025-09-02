// import 'dart:math';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:k_chart_plus/entity/k_line_entity.dart';
// import 'package:mcx/data/market_notifier.dart';

// class ChartNotifier extends StateNotifier<List<KLineEntity>> {
//   ChartNotifier(this.ref, {required this.grainIndex}) : super([]) {
//     _init();
//   }

//   final Ref ref;
//   final int grainIndex;
//   double _lastPrice = 0;
//   final _random = Random();

//   void _init() {
//     // Initialize lastPrice with the grain's currentPrice
//     final grains = ref.read(marketProvider);
//     _lastPrice = grains[grainIndex].currentPrice.toDouble();

//     // Listen to MarketNotifier changes
//     ref.listen<List<Grain>>(marketProvider, (previous, next) {
//       final newPrice = next[grainIndex].currentPrice.toDouble();
//       if (newPrice != _lastPrice) {
//         _addCandle(newPrice);
//       }
//     });
//   }

//   void _addCandle(double newPrice) {
//     double open = _lastPrice;
//     double close = newPrice;

//     double fluctuation = 0;
//     if (open != close) {
//       fluctuation = ((close - open).abs() / 2); // simple example
//     }

//     final high = max(max(open, close), max(open, close) + fluctuation);
//     final low = min(min(open, close), min(open, close) - fluctuation);

//     final candle = KLineEntity.fromCustom(
//       open: open,
//       close: close,
//       high: high,
//       low: low,
//       vol: _random.nextDouble() * 100,
//       time: DateTime.now().millisecondsSinceEpoch,
//     );

//     _lastPrice = newPrice;

//     final updatedCandles = [...state, candle];
//     state = updatedCandles.length > 50
//         ? updatedCandles.sublist(updatedCandles.length - 50)
//         : updatedCandles;
//   }
// }

// final chartProvider =
//     StateNotifierProvider.family<ChartNotifier, List<KLineEntity>, int>((
//       ref,
//       grainIndex,
//     ) {
//       return ChartNotifier(ref, grainIndex: grainIndex);
//     });
