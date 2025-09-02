import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      final change = changeOptions[_random.nextInt(changeOptions.length)];
      return grain.copyWith(currentPrice: grain.currentPrice + change);
    }).toList();
  }

  @override
  List<Grain> build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    _startSimulation();
    return [
      Grain(name: 'Rice', openPrice: 100000, currentPrice: 100000),
      Grain(name: 'Bean', openPrice: 150000, currentPrice: 150000),
      Grain(name: 'Chilli', openPrice: 50000, currentPrice: 50000),
    ];
  }
}

final marketProvider = NotifierProvider<MarketNotifier, List<Grain>>(() {
  return MarketNotifier();
});
