// ignore_for_file: public_member_api_docs, sort_constructors_first
// lib/data/order_entry.dart
import 'package:flutter/material.dart';

import 'package:mcx/market/market_screen.dart';

class OrderSellAndBuy extends StatelessWidget {
  final VoidCallback onBuyClick;
  final VoidCallback onSellClick;
  OrderSellAndBuy({
    Key? key,
    required this.onBuyClick,
    required this.onSellClick,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    OrderBook orderBook = OrderBook(
      sellOrders: [
        OrderEntry(price: 45300, amount: 8.2),
        OrderEntry(price: 45250, amount: 10.5),
        OrderEntry(price: 45200, amount: 6.3),
      ],
      buyOrders: [
        OrderEntry(price: 45190, amount: 12.4),
        OrderEntry(price: 45150, amount: 9.8),
        OrderEntry(price: 45100, amount: 14.7),
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: OrderColumn(
                  title: 'Sell Orders',
                  orders: orderBook.sellOrders,
                  priceColor: Colors.red, // Sell prices often red
                ),
              ),
              // A vertical divider to separate columns
              Container(
                width: 0.3,
                height: 140, // Adjust height as needed
                color: Theme.of(context).colorScheme.primary,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              Expanded(
                child: OrderColumn(
                  title: 'Buy Orders',
                  orders: orderBook.buyOrders,
                  priceColor: Colors.green, // Buy prices often green
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              ActionButton(
                text: 'Buy',
                color: Colors.green,
                onPressed: onBuyClick,
              ),
              const SizedBox(width: 20),
              ActionButton(
                text: 'Sell',
                color: Colors.red,
                onPressed: onSellClick,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderEntry {
  final int price;
  final double amount;

  OrderEntry({required this.price, required this.amount});
}

// lib/data/order_book.dart
class OrderBook {
  final List<OrderEntry> sellOrders;
  final List<OrderEntry> buyOrders;

  OrderBook({required this.sellOrders, required this.buyOrders});
}
// Import the OrderRow widget

class OrderColumn extends StatelessWidget {
  final String title;
  final List<OrderEntry> orders;
  final Color priceColor; // Color for the prices in this column

  const OrderColumn({
    Key? key,
    required this.title,
    required this.orders,
    this.priceColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: color, width: 0.5)),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              // color: color,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...orders.map(
          (order) => OrderRow(
            price: order.price,
            amount: order.amount,
            priceColor: priceColor,
          ),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,

        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color), // Border color
          overlayColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}

class OrderRow extends StatelessWidget {
  final int price;
  final double amount;
  final Color priceColor; // To allow different colors for sell/buy prices

  const OrderRow({
    Key? key,
    required this.price,
    required this.amount,
    this.priceColor = Colors.black, // Default to black
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formatCurrencyAmount(price),
            style: TextStyle(
              fontSize: 15,
              color: priceColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(amount.toString(), style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
