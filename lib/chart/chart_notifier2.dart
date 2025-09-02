// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_chart_plus/entity/k_line_entity.dart';

import 'package:mcx/data/market_notifier.dart';

class CandleModel {
  final double open;
  final double close;
  final double high;
  final double low;
  final double vol;
  final int time;

  CandleModel({
    required this.open,
    required this.close,
    required this.high,
    required this.low,
    required this.vol,
    required this.time,
  });

  @override
  String toString() {
    return 'CandleModel(open: $open, close: $close, high: $high, low: $low, vol: $vol, time: $time)';
  }
}

final chartNotifierProvider =
    NotifierProvider<ChartNotifier2, List<List<CandleModel>>>(ChartNotifier2.new);

class ChartNotifier2 extends Notifier<List<List<CandleModel>>> {
  final Map<String, List<CandleModel>> _grainCandles = {};
  final Map<String, DateTime?> _grainCandleStarts = {};

  @override
  List<List<CandleModel>> build() {
    return [];
  }

  void onMarketChanged(List<Grain> grains) {
    for (final grain in grains) {
      _sync(grain, grain.name);
    }
    state = _grainCandles.values.toList();
  }

  _sync(Grain next, String grainName) {
    final double price = next.currentPrice.toDouble();
    final now = DateTime.now();
    // Floor current time to the start of this minute (e.g., 10:03:45 -> 10:03:00)
    final minuteStart = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );

    DateTime? currentCandleStart = _grainCandleStarts[grainName];
    List<CandleModel> candles = _grainCandles[grainName] ?? [];

    // If this is the first tick or we've moved into a new minute, start a new candle
    if (currentCandleStart == null || minuteStart.isAfter(currentCandleStart)) {
      _grainCandleStarts[grainName] = minuteStart;

      final entity = CandleModel(
        open: price,
        close: price,
        high: price,
        low: price,
        vol: 1.0,
        time: minuteStart.millisecondsSinceEpoch,
      );

      candles = [...candles, entity];
      _grainCandles[grainName] = candles;
      return;
    }

    // Otherwise we're still within the current minute: update the last candle in place
    if (candles.isEmpty) {
      // Safety: if for some reason candles is empty, create the initial candle
      final entity = CandleModel(
        open: price,
        close: price,
        high: price,
        low: price,
        vol: 1.0,
        time: currentCandleStart!.millisecondsSinceEpoch,
      );
      candles = [entity];
      _grainCandles[grainName] = candles;
      return;
    }

    final last = candles.last;
    final updated = CandleModel(
      open: last.open,
      close: price,
      high: price > last.high ? price : last.high,
      low: price < last.low ? price : last.low,
      vol: (last.vol) + 1.0,
      time: currentCandleStart!.millisecondsSinceEpoch,
    );

    candles = [...candles.sublist(0, candles.length - 1), updated];
    _grainCandles[grainName] = candles;
  }
}

extension CandleModelX on CandleModel {
  KLineEntity toKLineEntity() {
    return KLineEntity.fromCustom(
      open: open,
      close: close,
      high: high,
      low: low,
      vol: vol,
      time: time,
    );
  }
}
