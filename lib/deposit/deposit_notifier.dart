import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mcx/deposit/deposit_screen.dart';
final depositNotifierProvider = NotifierProvider<DepositNotifier, List<Bank>>(DepositNotifier.new);
class DepositNotifier extends Notifier<List<Bank>> {
  @override
  List<Bank> build() {
    return [
      Bank(
        name: 'KBZ',
        account: '1234567890124',
        icon: 'assets/payments/kbz.png',
      ),
      Bank(
        name: 'A BANK',
        account: '9876543210124',
        icon: 'assets/payments/abank.png',
      ),
      Bank(
        name: 'UAB',
        account: '4567891234124',
        icon: 'assets/payments/uab.png',
      ),
      Bank(
        name: 'AYA',
        account: '3216549870124',
        icon: 'assets/payments/aya.png',
      ),
      Bank(
        name: 'CB',
        account: '6549873210124',
        icon: 'assets/payments/cb.png',
      ),
    ];
  }

  void addBank(Bank bank) {
    state = [...state, bank];
  }
}
