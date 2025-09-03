import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mcx/home_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: Colors.blueAccent,
      brightness: Brightness.light,
    );
    return MaterialApp(
      title: 'MCX',
      theme: ThemeData(
        appBarTheme: AppBarTheme(surfaceTintColor: Colors.transparent),
        colorScheme: scheme,
      ),
      home: HomeScreen(),
    );
  }
}
