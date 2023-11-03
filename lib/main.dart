import 'package:budget_meal/Pantry.dart';
import 'package:budget_meal/RecipeBook.dart';
import 'package:budget_meal/mealplanner.dart';
import 'package:budget_meal/webshop.dart';
import 'package:flutter/material.dart';

MealPlanner _mealPlanner = MealPlanner();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _mealPlanner.createMealPlan(Pantry(), RecipeBook(), WebShop());

    return MaterialApp(
      title: 'BudgetMeal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'BugetMeal Home Page'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'This is my new text',
            ),
          ],
        ),
      ),
    );
  }
}
