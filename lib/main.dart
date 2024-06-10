import 'package:flutter/material.dart';
import 'package:shop/screens/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ColorScheme appTheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: const Color.fromARGB(255, 146, 230, 249),
      surface: const Color.fromARGB(255, 44, 50, 60),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: appTheme,
      scaffoldBackgroundColor: const Color.fromARGB(255, 49, 47, 59),
      ),
      home: const GroceryList(),
    );
  }
}
