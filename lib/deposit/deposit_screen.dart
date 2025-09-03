import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deposit')),
      body: Column(),
    );
  }
}
