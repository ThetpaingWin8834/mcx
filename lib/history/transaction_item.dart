class TransactionItem {
  final String pair;
  final String type;
  final double lotSize;
  final double price;
  final String timestamp;
  final double? profit;

  TransactionItem({
    required this.pair,
    required this.type,
    required this.lotSize,
    required this.price,
    required this.timestamp,
    this.profit,
  });
}