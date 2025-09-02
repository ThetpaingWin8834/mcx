import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mcx/data/market_notifier.dart';

const maximumBalance = 1000000;
final userNotifierProvider = NotifierProvider<UserNotifier, UserState>(
  UserNotifier.new,
);

class UserState {
  final int currentBalance;
  final UserPossession possession;
  UserState({
    this.currentBalance = maximumBalance,
    this.possession = const UserPossession(grain: 'RICE', count: 10),
  });
}

class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    return UserState();
  }
}

class UserPossession {
  final String grain;
  final double count;

  const UserPossession({required this.grain, required this.count});
}
