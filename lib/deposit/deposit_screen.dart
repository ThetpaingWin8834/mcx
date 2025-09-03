// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mcx/deposit/add_bank_screen.dart';
import 'package:mcx/deposit/deposit_notifier.dart';

class Bank {
  final String name;
  final String account;
  final String icon;

  Bank({required this.name, required this.account, required this.icon});
}

class DepositScreen extends ConsumerStatefulWidget {
  final bool isDeposit;
  const DepositScreen({this.isDeposit = true});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  int _selectedBankIndex = 0;
  // Bank get  => banks[_selectedBankIndex];

  String _maskAccountNumber(String account) {
    if (account.length <= 3) return account;

    return '*' * (account.length - 3) + account.substring(account.length - 3);
  }

  @override
  Widget build(BuildContext context) {
    final banks = ref.watch(depositNotifierProvider);
    Bank selectedBank = banks[_selectedBankIndex];
    return Scaffold(
      key: ValueKey(banks.length),
      appBar: AppBar(
        title: widget.isDeposit
            ? const Text('Deposit')
            : const Text('Withdraw'),
        actions: [
          if (widget.isDeposit)
            TextButton.icon(
              onPressed: () async {
                final result = await Navigator.push<Bank>(
                  context,
                  CupertinoPageRoute(builder: (context) => AddBankScreen()),
                );
                if (result != null) {
                  ref.read(depositNotifierProvider.notifier).addBank(result);
                }
              },
              label: Text('Add Bank'),
              icon: Icon(Icons.add),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text('100,000 MMK'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 7,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: banks.length,
                itemBuilder: (context, index) {
                  final bank = banks[index];
                  final isSelected = _selectedBankIndex == index;
                  return BankCard(
                    bank: bank,
                    isSelected: isSelected,
                    maskAccount: _maskAccountNumber,
                    onTap: () => setState(() => _selectedBankIndex = index),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bank Info
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          selectedBank.icon,
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedBank.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _maskAccountNumber(selectedBank.account),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Amount Field
                  Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          width: 0.7,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          width: 0.7,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 0.7,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      hintText: 'Enter amount',
                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Continue Button
                  Container(
                    margin: EdgeInsets.only(
                      // bottom: MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    height: 52,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
          ],
        ),
      ),
    );
  }
}

class BankCard extends StatelessWidget {
  final Bank bank;
  final bool isSelected;
  final VoidCallback onTap;
  final String Function(String) maskAccount;

  const BankCard({
    super.key,
    required this.bank,
    required this.isSelected,
    required this.onTap,
    required this.maskAccount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        foregroundDecoration: BoxDecoration(
          color: isSelected ? colorScheme.primary.withValues(alpha: .1) : null,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: colorScheme.primary, width: 2)
              : Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: .2),
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
            Expanded(
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      bank.icon,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Spacer(),
                  if (isSelected)
                    Icon(Icons.check_circle, color: colorScheme.primary),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Text(
              bank.name,
              style: const TextStyle(
                // fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              maskAccount(bank.account),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
