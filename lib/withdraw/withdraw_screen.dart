import 'package:flutter/material.dart';
import 'package:mcx/deposit/deposit_screen.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DepositScreen(isDeposit: false);
  }
}
