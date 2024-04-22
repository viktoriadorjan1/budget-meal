import 'package:flutter/material.dart';

import 'RecipeBook/RecipeBookView.dart';
import 'Pantry/PantryView.dart';
import 'WebStore/ShoppingList.dart';
import 'Settings/SettingsView.dart';
import 'Mealplan/MealplanView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'BudgetMeal Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _currentIndex = 2;

  final List _pages = [
    Recipes(),
    Pantry(),
    Schedule(),
    Shopping(),
    More()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFCFCF),
      body: _pages[_currentIndex],
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF26BDC6),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Recipes'),
        BottomNavigationBarItem(icon: Icon(Icons.bakery_dining_rounded), label: 'Pantry'),
        BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: 'Schedule'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'To buy'),
        BottomNavigationBarItem(icon: Icon(Icons.more_outlined), label: 'More'),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.white,
      onTap: (index) => setState(() {
        _currentIndex = index;
      }),
    ));
  }
}

