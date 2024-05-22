import 'package:http/http.dart' as http;
import '../UserData/UserData.dart';
import '../mealplanner.dart';

MealPlanner _mealPlanner = MealPlanner();

Future<String> generateMealPlan(UserData userData, List<String> days, List<dynamic> meals) async {
  String results = "";
  const serverUrl = "https://budget-meal.onrender.com/meal_plan";
  const localUrl = "http://192.168.0.34:9674/meal_plan"; //"http://10.0.2.2:5000";

  http.Response response = http.Response("ERROR: Could not connect to host", 500);
  try {
    response = await http.post(Uri.parse(localUrl),
        headers: {"Content-Type": "application/json"},
        body: _mealPlanner.createMealPlan(userData, days, meals)
    );
  } catch (e) {
    print(e);
  }

  print("Code: ${response.statusCode}");
  print("Body: ${response.body}");
  results = response.body;

  return results;
}