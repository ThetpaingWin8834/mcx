// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mcx/deposit/deposit_screen.dart';

class AddBankScreen extends StatefulWidget {
  const AddBankScreen({super.key});

  @override
  State<AddBankScreen> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final phController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    phController.dispose();
    super.dispose();
  }

  Bank? selectedBank;
  final banks = [
    Bank(
      name: 'MTB',
      account: '4567891234124',
      icon: 'assets/payments/mtb.png',
    ),
  ];

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  final GlobalKey _key = LabeledGlobalKey("dropdown_button");

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    // Use CompositedTransformFollower for positioning
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss when tapping outside
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.translucent,
              child: Container(),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 5),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: banks
                        .map(
                          (bank) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedBank = bank;
                              });
                              _closeDropdown();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    bank.icon,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    bank.name,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Bank')),
      body: Column(
        children: [
          const SizedBox(height: 24),
          CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              key: _key,
              onTap: _toggleDropdown,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (selectedBank != null)
                      Row(
                        children: [
                          Image.asset(
                            selectedBank!.icon,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            selectedBank!.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    else
                      const Text(
                        'Select Bank',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    Icon(
                      _isDropdownOpen
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      key: ValueKey<bool>(_isDropdownOpen),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Divider(),
          FieldRow(
            title: 'Account Name',
            keyboardType: TextInputType.name,
            controller: nameController,
          ),
          FieldRow(
            title: 'Account Number',
            keyboardType: TextInputType.numberWithOptions(),
            controller: numberController,
          ),
          FieldRow(
            title: 'Phone Number',
            keyboardType: TextInputType.numberWithOptions(),
            controller: phController,
          ),
          SizedBox(height: 32),
          FilledButton(
            onPressed: onConfirm,
            style: FilledButton.styleFrom(minimumSize: Size(120, 45)),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void onConfirm() {
    if (selectedBank == null) {
      showSnackBar('Choose bank');
      return;
    }
    if (nameController.text.isEmpty) {
      showSnackBar('Name empty!');
      return;
    }
    if (numberController.text.isEmpty) {
      showSnackBar('Account number empty!');
      return;
    }
    if (numberController.text.length < 12) {
      showSnackBar('Invalid account number!');
      return;
    }
    if (phController.text.isEmpty) {
      showSnackBar('Please enter your phone number!');
      return;
    }
    Navigator.pop(
      context,
      Bank(
        account: numberController.text,
        name: selectedBank!.name,
        icon: selectedBank!.icon,
      ),
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class FieldRow extends StatelessWidget {
  final String title;
  final TextInputType keyboardType;
  final TextEditingController controller;
  const FieldRow({
    Key? key,
    required this.title,
    required this.keyboardType,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            flex: 3,
            child: Text('$title : ', style: TextStyle(fontSize: 15)),
          ),
          Expanded(
            flex: 5,
            child: TextField(
              keyboardType: keyboardType,
              controller: controller,
              decoration: InputDecoration(),
            ),
          ),
        ],
      ),
    );
  }
}
