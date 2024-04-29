import 'package:flutter/material.dart';

import 'Pantry/PantryModel.dart';
import 'RecipeBook/RecipeBookModel.dart';
import 'RecipeBook/RecipeBookView.dart';
import 'Pantry/PantryView.dart';
import 'RecipeBook/WishList.dart';
import 'WebStore/ShoppingList.dart';
import 'Settings/SettingsView.dart';
import 'Mealplan/MealplanView.dart';

Future<void> main() async {
  RecipeBook recipeBook = RecipeBook();
  Pantry pantry = Pantry();
  final List<String> existingIngredients = await WishList.getAllExistingIngredientNames();

  runApp(MyApp(recipeBook: recipeBook, pantry: pantry, existingIngredients: existingIngredients));
}

class MyApp extends StatelessWidget {
  final List<String> existingIngredients;
  const MyApp({required this.recipeBook, super.key, required this.pantry, required this.existingIngredients});
  final RecipeBook recipeBook;
  final Pantry pantry;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(recipeBook: recipeBook, pantry: pantry, existingIngredients: existingIngredients,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<String> existingIngredients;
  const MyHomePage({required this.recipeBook, super.key, required this.pantry, required this.existingIngredients});
  final RecipeBook recipeBook;
  final Pantry pantry;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List _pages = [
      RecipeBookView(recipeBook: widget.recipeBook, pantry: widget.pantry, existingIngredients: widget.existingIngredients,),
      PantryView(widget.pantry),
      Schedule(widget.pantry, widget.recipeBook),
      Shopping(),
      More()
    ];

    return PopScope(
        canPop: false,
    child: Scaffold(
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
    )));
  }
}

