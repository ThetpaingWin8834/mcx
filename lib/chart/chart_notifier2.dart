// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k_chart_plus/entity/k_line_entity.dart';

import 'package:mcx/data/market_notifier.dart';
import 'package:mcx/home_notifier.dart';

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
    NotifierProvider<ChartNotifier2, List<CandleModel>>(ChartNotifier2.new);

class ChartNotifier2 extends Notifier<List<CandleModel>> {
  DateTime? _currentCandleStart;

  @override
  List<CandleModel> build() {
    ref.listen(marketProvider, (previous, next) {
      final currentIndex = ref.read(selectedGrainNotifierProvider);
      _sync(
        previous == null ? null : previous[currentIndex],
        next[currentIndex],
      );
    });
    return [];
  }

  _sync(Grain? previous, Grain next) {
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

    // If this is the first tick or we've moved into a new minute, start a new candle
    if (_currentCandleStart == null ||
        minuteStart.isAfter(_currentCandleStart!)) {
      _currentCandleStart = minuteStart;

      final entity = CandleModel(
        open: price,
        close: price,
        high: price,
        low: price,
        vol: 1.0,
        time: minuteStart.millisecondsSinceEpoch,
      );

      // append new candle
      state = [...state, entity];
      return;
    }

    // Otherwise we're still within the current minute: update the last candle in place
    if (state.isEmpty) {
      // Safety: if for some reason state is empty, create the initial candle
      final entity = CandleModel(
        open: price,
        close: price,
        high: price,
        low: price,
        vol: 1.0,
        time: _currentCandleStart!.millisecondsSinceEpoch,
      );
      state = [entity];
      return;
    }

    final last = state.last;
    final updated = CandleModel(
      open: last.open,
      close: price,
      high: price > last.high ? price : last.high,
      low: price < last.low ? price : last.low,
      vol: (last.vol) + 1.0,
      time: _currentCandleStart!.millisecondsSinceEpoch,
    );

    // Replace the last candle with the updated one so UI updates immediately on each tick
    state = [...state.sublist(0, state.length - 1), updated];
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
