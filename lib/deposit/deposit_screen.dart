import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  int? _selectedBankIndex;

  final List<Map<String, String>> banks = [
    {'name': 'Bank of America', 'account': '1234567890124', 'icon': '🏦'},
    {'name': 'Chase Bank', 'account': '9876543210124', 'icon': '🏛️'},
    {'name': 'Wells Fargo', 'account': '4567891234124', 'icon': '🏤'},
    {'name': 'Citibank', 'account': '3216549870124', 'icon': '🏢'},
    {'name': 'HSBC', 'account': '6549873210124', 'icon': '🏰'},
  ];

  String _maskAccountNumber(String account) {
    if (account.length <= 3) return account;
    return '*' * (account.length - 3) + account.substring(account.length - 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deposit')),
      body: ListView.builder(
        itemCount: banks.length,
        itemBuilder: (context, index) {
          final bank = banks[index];
          final isSelected = _selectedBankIndex == index;
          return InkWell(
            onTap: () {
              setState(() {
                _selectedBankIndex = index;
              });
            },
            child: Container(
              color: isSelected ? Colors.blue.shade100 : null,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Text(
                    bank['icon'] ?? '',
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bank['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _maskAccountNumber(bank['account'] ?? ''),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Colors.blue),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
