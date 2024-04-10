import 'package:budget_meal/mealplanner.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


MealPlanner _mealPlanner = MealPlanner();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //_mealPlanner.createMealPlan(Pantry(), RecipeBook(), WebShop());

    return MaterialApp(
      title: 'BudgetMeal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'BudgetMeal Home Page'),
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
          children: <Widget>[
            const Text(
              'This is my new text',
            ),
            ElevatedButton(
              onPressed: () {
                generateMealPlan();
              },
              child: const Text("Generate meal plan"),
            )
          ],
        ),
      ),
    );
  }

  void generateMealPlan() async {
    const serverUrl = "https://budget-meal.onrender.com/";
    const localUrl = "http://10.0.2.2:3306";

    var response = await http.post(Uri.parse(localUrl),
        headers: {"Content-Type": "application/json"},
        body: _mealPlanner.createMealPlan()
        );

    print("Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      print("Body: ${response.body}");
    }
  }
}
