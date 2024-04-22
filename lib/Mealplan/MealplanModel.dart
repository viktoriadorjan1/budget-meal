import 'package:http/http.dart' as http;
import '../mealplanner.dart';

MealPlanner _mealPlanner = MealPlanner();

void generateMealPlan() async {
  const serverUrl = "https://budget-meal.onrender.com/";
  const localUrl = "http://10.0.2.2:7900";

  var response = await http.post(Uri.parse(serverUrl),
      headers: {"Content-Type": "application/json"},
      body: _mealPlanner.createMealPlan()
  );

  print("Code: ${response.statusCode}");

  if (response.statusCode == 200) {
    print("Body: ${response.body}");
  }
}