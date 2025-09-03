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
      title: 'Flutter Demo',
      theme: ThemeData(
        // appBarTheme: AppBarTheme(
        //   backgroundColor: scheme.surfaceContainer,
        //   titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        // ),
        colorScheme: scheme,
      ),
      home: HomeScreen(),
    );
  }
}
