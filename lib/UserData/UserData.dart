import 'dart:convert';
import 'dart:io';

import 'package:budget_meal/Pantry/PantryModel.dart';
import 'package:budget_meal/RecipeBook/RecipeBookModel.dart';
import 'package:path_provider/path_provider.dart';

import '../RecipeBook/IngredientModel.dart';

class UserData {
  String _userName = "";
  String _sex = "";
  int _age = 0;
  int _height = 0;
  int _weight = 0;
  String _activityLevel = "";
  int _dailyCalories = 0;
  List<Ingredient> _unwantedIngredients = [];
  List<Ingredient> _ownIngredients = [];
  Pantry _pantry = Pantry();
  RecipeBook _recipeBook = RecipeBook();

  UserData();

  Future<bool> init() async {
    bool userExists = await fetchUserData();
    return userExists;
  }

  Future<bool> fetchUserData() async {
    bool userExists = false;

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final userDataFile = File('$path/userData.txt');

    bool fileExists = await userDataFile.exists();

    if (fileExists) {
      // user exists!
      final userDataFileContents = await userDataFile.readAsString();
      parseUserDataFromJson(userDataFileContents);
      userExists = true;
    } else {
      // new user
      print("File does not exists = user does not exists");
      userExists = false;
    }

    return userExists;
  }

  void parseUserDataFromJson(String json) {
    final Map<String, dynamic> parsedJson = jsonDecode(json);

    _userName = parsedJson['userName'];
    _sex = parsedJson["sex"];
    _age = parsedJson["age"];
    _height = parsedJson["height"];
    _weight = parsedJson["weight"];
    _activityLevel = parsedJson["activityLevel"];
    _dailyCalories = parsedJson["dailyCalories"];
    _unwantedIngredients = parseUnwantedIngredients(parsedJson["unwantedIngredients"]);
    _pantry = parsePantry(parsedJson["pantry"]);
    _recipeBook = parseRecipeBook(parsedJson["recipeBook"]);
  }

  List<Ingredient> parseUnwantedIngredients(Map<String, dynamic> parsedJson) {
    List<Ingredient> unwantedIngs = [];
    for (String category in parsedJson.keys) {
      for (String ingredientName in parsedJson[category]) {
        Ingredient i = IngredientBuilder().withCategory(category).withIngredientName(ingredientName).build();
        unwantedIngs.add(i);
      }
    }
    return unwantedIngs;
  }

  Pantry parsePantry(Map<String, dynamic> parsedJson) {
    Pantry pantry = Pantry();
    for (String ingredientName in parsedJson.keys) {
      int ingredientAmount = parsedJson[ingredientName];
      // TODO: implement unit.
      // TODO: implement ingredient category.
      Ingredient i = IngredientBuilder().withIngredientName(ingredientName).withAmount(ingredientAmount, "g").withCategory("other").build();
      pantry.putInPantry(i);
    }
    return pantry;
  }

  RecipeBook parseRecipeBook(Map<String, dynamic> parsedJson) {
    RecipeBook recipeBook = RecipeBook();

    for (String recipeName in parsedJson.keys) {
      List<Ingredient> ingredients = [];
      for (MapEntry entry in parsedJson[recipeName].entries) {
        String ingredientName = entry.key;
        int ingredientAmount = entry.value;
        // TODO: implement unit.
        Ingredient i = IngredientBuilder().withIngredientName(ingredientName).withAmount(ingredientAmount, "g").build();
        ingredients.add(i);
      }
      // TODO: implement portion size.
      // TODO: implement freezable.
      // TODO: implement recipe category.
      Recipe r = Recipe(recipeName, 1, ingredients, false, ["breakfast"]);
      recipeBook.addRecipe(r);
    }
    return recipeBook;
  }

  // save user data to storage
  Future<void> saveUserData() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final userDataFile = File('$path/userData.txt');

    await userDataFile.writeAsString('''
              {
                "userName": "$_userName",
                "sex": "$_sex",
                "age": $_age,
                "height": $_height,
                "weight": $_weight,
                "activityLevel": "$_activityLevel",
                "dailyCalories": $_dailyCalories,
                "unwantedIngredients": {
                    "vegetables": [
                      "tomato",
                      "potato",
                      "carrot"
                    ],
                    "bakery": [
                      "bread",
                      "baguette"
                    ],
                    "fruit": [
                      "lemon"
                    ]
                },
                "pantry": ${_pantry.toJson()},
                "recipeBook": ${_recipeBook.toJson()}
              }
          ''');
    print("Saved.");
  }

  //"pantry": {
  //                     ${_pantry.toJson()}
  //                     "milk": 200,
  //                     "cereal_flakes": 400,
  //                     "bread": 100
  //                 },

  //"recipeBook": {
  //                     "cereal": {
  //                         "cereal_flakes": 300,
  //                         "milk": 300
  //                     },
  //                     "sandwich": {
  //                         "bread": 200
  //                     }
  //                 }

  // GETTERS

  String getUsername() {
    return _userName;
  }

  int getAge() {
    return _age;
  }

  String getSex() {
    return _sex;
  }

  int getHeight() {
    return _height;
  }

  int getWeight() {
    return _weight;
  }

  String getActivityLevel() {
    return _activityLevel;
  }

  int getDailyCalories() {
    return _dailyCalories;
  }

  Pantry getPantry() {
    return _pantry;
  }

  RecipeBook getRecipeBook() {
    return _recipeBook;
  }

  // SETTERS

  void setUsername(String name) {
    _userName = name;
  }

  void setAge(int age) {
    _age = age;
  }

  void setHeight(int height) {
    _height = height;
  }

  void setWeight(int weight) {
    _weight = weight;
  }

  void setDailyCalories(int c) {
    _dailyCalories = c;
  }

  void setSex(String sex) {
    _sex = sex;
  }

  void setActivityLevel(String l) {
    _activityLevel = l;
  }

}