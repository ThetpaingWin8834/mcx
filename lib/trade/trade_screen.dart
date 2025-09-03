// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mcx/data/market_notifier.dart';
import 'package:mcx/home_notifier.dart';

class Position {
  final String symbol;
  final String action;
  final String fromTo;
  final String profit;

  const Position({
    required this.symbol,
    required this.action,
    required this.fromTo,
    required this.profit,
  });
}

class Order {
  final String symbol;
  final String type;
  final String size;
  final String state;

  const Order({
    required this.symbol,
    required this.type,
    required this.size,
    required this.state,
  });
}

class TradeScreen extends ConsumerStatefulWidget {
  const TradeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TradeScreenState();
}

class _TradeScreenState extends ConsumerState<TradeScreen> {
  final account = const {'balance': '100000'};
  String getRandomName() {
    final grainList = ref.read(marketProvider);
    return grainList[Random().nextInt(grainList.length)].name;
  }

  late final positions = [
    Position(
      symbol: getRandomName(),
      action: 'buy 1',
      fromTo: '100,000 → 1500,00',
      profit: '50,000',
    ),
    Position(
      symbol: getRandomName(),
      action: 'buy 2',
      fromTo: '150,000 → 100,000',
      profit: '-50000',
    ),
    Position(
      symbol: getRandomName(),
      action: 'buy 3',
      fromTo: '50,000 → 10,000',
      profit: '50,000',
    ),
    Position(
      symbol: getRandomName(),
      action: 'buy 1',
      fromTo: '100,000 → 200,000',
      profit: '100,000',
    ),
  ];

  late final orders = [
    Order(
      symbol: getRandomName(),
      type: 'sell limit',
      size: '1.00 / 0.00 at 0.85000',
      state: 'placed',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MCX . Trade')),
      body: Column(
        children: [
          Column(
            children: [
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AccountStatRow(
                  label: 'Balance:',
                  value: account['balance']!,
                  isValueBold: true,
                ),
              ),
              const SizedBox(height: 24),

              // const Divider(height: 1),
            ],
          ),

          // positions and orders - scrollable area
          Expanded(
            child: ListView(
              children: [
                const SectionHeader(title: 'Positions'),
                const SizedBox(height: 6),
                ...positions.map((p) => PositionListItem(position: p)),
                const SizedBox(height: 12),
                const SectionHeader(title: 'Orders'),
                const SizedBox(height: 6),
                ...orders.map((o) => OrderListItem(order: o)),
                const SizedBox(
                  height: 80,
                ), // spacing so content isn't hidden by bottom bar
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountStatRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isValueBold;

  const AccountStatRow({
    super.key,
    required this.label,
    required this.value,
    this.isValueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle = TextStyle(
      fontWeight: isValueBold ? FontWeight.w700 : FontWeight.w500,
      fontSize: 15,
    );
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        // dotted/separator flexible area
        const Expanded(child: DottedLine()),
        const SizedBox(width: 8),
        Text(value, style: valueStyle),
      ],
    );
  }
}

/// Simple dotted line: draws many small dots horizontally
class DottedLine extends StatelessWidget {
  final double height;
  final double dotSpacing;
  final double dotSize;

  const DottedLine({
    super.key,
    this.height = 4,
    this.dotSpacing = 6,
    this.dotSize = 2,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / dotSpacing).floor();
        return Row(
          children: List.generate(count, (i) {
            return Container(
              width: dotSize,
              height: dotSize,
              margin: EdgeInsets.only(right: dotSpacing - dotSize),
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class PositionListItem extends StatelessWidget {
  final Position position;

  const PositionListItem({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    final profitNum =
        double.tryParse(position.profit.replaceAll(',', '')) ?? 0.0;
    final profitColor = profitNum < 0
        ? Colors.red.shade700
        : Colors.blue.shade700;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(),
          builder: (context) => PositionDetailWidget(position: position),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        position.symbol,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          position.action,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    position.fromTo,
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
            ),
            // profit
            Text(
              position.profit,
              style: TextStyle(color: profitColor, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final Order order;

  const OrderListItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isPlaced = order.state.toLowerCase() == 'placed';
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(),
          builder: (context) => OrderDetailWidget(order: order),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        order.symbol,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.type,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    order.size,
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
            ),
            Text(
              order.state,
              style: TextStyle(
                color: isPlaced ? Colors.black54 : Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailWidget extends ConsumerWidget {
  final Order order;
  const OrderDetailWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shrinkWrap: true,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        order.symbol,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order.type,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${order.size}",
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
            Text(
              order.state,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade200,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "2025.09.01 11:12:03",
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "S / L: –",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            Text(
              "Swap: -0.02",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "T / P: –",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            Text(
              "#150833428666",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),

        const SizedBox(height: 20),
        const Divider(height: 1),

        // --- Actions ---
        const _ActionItem(title: "Delete order"),
        const _ActionItem(title: "New order"),
        _ActionItem(
          title: "Chart",
          onClick: () {
            ref.read(homeNotifierProvider.notifier).state = 1;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class PositionDetailWidget extends ConsumerWidget {
  final Position position;
  const PositionDetailWidget({Key? key, required this.position})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profit = int.parse(position.profit);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shrinkWrap: true,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        position.symbol,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        position.action,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${position.fromTo}",
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
            Text(
              profit.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: profit < 0 ? Colors.red : Colors.blue.shade700,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "2025.09.01 11:12:03",
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "S / L: –",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            Text(
              "Swap: -0.02",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "T / P: –",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            Text(
              "#150833428666",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),

        const SizedBox(height: 20),
        const Divider(height: 1),

        // --- Actions ---
        const _ActionItem(title: "Close position"),
        const _ActionItem(title: "New order"),
        _ActionItem(
          title: "Chart",
          onClick: () {
            ref.read(homeNotifierProvider.notifier).state = 1;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final String title;
  final VoidCallback? onClick;
  const _ActionItem({Key? key, required this.title, this.onClick})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Text(title, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}
