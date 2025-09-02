import 'package:flutter_riverpod/flutter_riverpod.dart';
const maximumBalance = 1000000;
final userNotifierProvider = NotifierProvider<UserNotifier, UserState>(UserNotifier.new);
class UserState {
  final int currentBalance;

  UserState({ this.currentBalance = maximumBalance});
}
class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    return UserState();
  }
}