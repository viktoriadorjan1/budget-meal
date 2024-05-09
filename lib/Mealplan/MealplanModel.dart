import 'package:http/http.dart' as http;
import '../UserData/UserData.dart';
import '../mealplanner.dart';

MealPlanner _mealPlanner = MealPlanner();

Future<String> generateMealPlan(UserData userData) async {
  String results = "";
  const serverUrl = "https://budget-meal.onrender.com/meal_plan";
  const localUrl = "http://146.169.170.164:9674/meal_plan"; //"http://10.0.2.2:5000";

  var response = await http.post(Uri.parse(serverUrl),
      headers: {"Content-Type": "application/json"},
      body: _mealPlanner.createMealPlan(userData)
  );

  print("Code: ${response.statusCode}");

  if (response.statusCode == 200) {
    print("Body: ${response.body}");
    results = response.body;
  }

  return results;
}