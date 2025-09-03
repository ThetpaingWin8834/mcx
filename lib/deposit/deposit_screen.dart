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
      body: SizedBox(
        height: 140,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          scrollDirection: Axis.horizontal,
          itemCount: banks.length,
          itemBuilder: (context, index) {
            final bank = banks[index];
            final isSelected = _selectedBankIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selectedBankIndex = index),
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: Colors.blue, width: 2)
                        : Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bank['icon'] ?? '',
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bank['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _maskAccountNumber(bank['account'] ?? ''),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      if (isSelected)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(Icons.check_circle, color: Colors.blue),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
