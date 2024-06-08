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
      seedColor: Colors.green,
      surface: Colors.green,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: appTheme,
        scaffoldBackgroundColor: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.green,
        ).surface, // Uses the background color from the generated ColorScheme
      ),
      home: const GroceryList(),
    );
  }
}
