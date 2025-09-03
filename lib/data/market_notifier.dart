import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mcx/chart/chart_notifier2.dart';

class Grain {
  final String name;
  final int openPrice;
  final int currentPrice;

  Grain({
    required this.name,
    required this.openPrice,
    required this.currentPrice,
  });

  Grain copyWith({int? currentPrice}) {
    return Grain(
      name: name,
      openPrice: openPrice,
      currentPrice: currentPrice ?? this.currentPrice,
    );
  }
}

class MarketNotifier extends Notifier<List<Grain>> {
  final _random = Random();
  Timer? _timer;

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _updatePrices();
    });
  }

  void _updatePrices() {
    state = state.map((grain) {
      final changeOptions = [500, -500, 1000, -1000];
      return grain.copyWith(
        currentPrice:
            grain.currentPrice +
            changeOptions[_random.nextInt(changeOptions.length)],
      );
    }).toList();
    ref.read(chartNotifierProvider.notifier).onMarketChanged(state);
  }

  @override
  List<Grain> build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    _startSimulation();
    return [
        Grain(name: 'Black Mapte', openPrice: 100000, currentPrice: 100000),
        Grain(name: 'Toor Whole', openPrice: 150000, currentPrice: 150000),
        Grain(name: 'Green Mung Beans', openPrice: 120000, currentPrice: 120000),
        Grain(name: 'Black Eye Beans', openPrice: 90000, currentPrice: 90000),
        Grain(name: 'Chilli', openPrice: 50000, currentPrice: 50000),
        Grain(name: 'Onions', openPrice: 40000, currentPrice: 40000),
        Grain(name: 'A12DPS', openPrice: 110000, currentPrice: 110000),
        Grain(name: 'B12S', openPrice: 130000, currentPrice: 130000),
        Grain(name: '25% Emata', openPrice: 80000, currentPrice: 80000),
    ];
  }
}

final marketProvider = NotifierProvider<MarketNotifier, List<Grain>>(() {
  return MarketNotifier();
});
