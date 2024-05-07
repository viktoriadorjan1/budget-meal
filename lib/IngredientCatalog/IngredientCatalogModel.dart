import 'dart:convert';
import 'package:http/http.dart' as http;

import '../RecipeBook/IngredientModel.dart';

class IngredientCatalog {
  List<Ingredient> _ingredientCatalog = [];

  IngredientCatalog();

  create() async {
    await buildIngredientCatalog().then((list) {
      _ingredientCatalog = list;
    });
  }

  Future<List<Ingredient>> buildIngredientCatalog() async {

    const serverUrl = "https://budget-meal.onrender.com/ingredients";
    const localUrl = "http://146.169.165.75:9674/ingredients"; //"http://10.0.2.2:5000";

    var response = await http.post(Uri.parse(serverUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({})
    );

    if (response.statusCode == 200) {
      return parseCatalogItems(response.body);
    }
    return [];
  }

  List<Ingredient> parseCatalogItems(String jsonBody) {
    final List<Ingredient> ingredients = [];
    final Map<String, dynamic> parsedJson = jsonDecode(jsonBody);
    for (String category in parsedJson.keys) {
      for (String ingredientName in parsedJson[category]) {
          Ingredient i = IngredientBuilder().withCategory(category).withIngredientName(ingredientName).build();
          ingredients.add(i);
      }
    }
    return ingredients;
  }


  List<String> getAllIngredientNames() {
    print("Fetching ingredients...");
    List<String> ingredientNames = [];
    for (Ingredient i in _ingredientCatalog) {
      ingredientNames.add(i.getIngredientName());
    }
    return ingredientNames;
  }

  List<Ingredient> getAllIngredients() {
    print("Fetching ingredients...");
    List<Ingredient> ingredients = [];
    for (Ingredient i in _ingredientCatalog) {
      ingredients.add(i);
    }
    return ingredients;
  }

}