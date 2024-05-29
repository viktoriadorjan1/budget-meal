import 'dart:convert';
import 'dart:io';

import 'package:budget_meal/Mealplan/MealPlanCollectionModel.dart';
import 'package:budget_meal/Pantry/PantryModel.dart';
import 'package:budget_meal/RecipeBook/RecipeBookModel.dart';
import 'package:budget_meal/ShoppingList/ShoppingListModel.dart';
import 'package:path_provider/path_provider.dart';

import '../Mealplan/MealPlanModel.dart';
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
  final List<Ingredient> _ownIngredients = [];
  Pantry _pantry = Pantry();
  RecipeBook _recipeBook = RecipeBook();
  MealPlanCollection _mealPlanCollection = MealPlanCollection();
  NutritionalInformation? _nutritionalInformation;
  ShoppingList _shoppingList = ShoppingList();

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
    _mealPlanCollection = parseMealPlanCollection(parsedJson["mealPlanCollection"]);
    _nutritionalInformation = parseNutritionalInformation(parsedJson["nutritionalTargets"]);
    _shoppingList = parseShoppingList(parsedJson["shoppingList"]);
  }

  ShoppingList parseShoppingList(Map<String, dynamic> parsedJson) {
    ShoppingList shoppingList = ShoppingList();
    for (String ingredientTag in parsedJson.keys) {
      Map<String, dynamic> entry = parsedJson[ingredientTag];
      String intendedRecipeName = entry["intendedRecipeName"];
      int amountToBuy = entry["amountToBuy"];
      String storeName = entry["storeName"];
      int price = entry["price"];
      String ingredientName = entry["ingredientName"];
      ShoppingListItem i = ShoppingListItem(intendedRecipeName, ingredientTag, amountToBuy, storeName, price, ingredientName);
      shoppingList.addItem(i);
    }
    return shoppingList;
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

  NutritionalInformation? parseNutritionalInformation(Map<String, dynamic> parsedJson) {
    Fats? fats;
    Saturates? saturates;
    Carbs? carbs;
    Sugars? sugars;
    Protein? protein;
    Salt? salt;

    NutritionalInformation? nutritionalInformation;

    for (String nutritionName in parsedJson.keys) {
      Map<String, dynamic> entry = parsedJson[nutritionName];
      int lowerLimit = entry["lower_limit"];
      int upperLimit = entry["upper_limit"];
      switch (nutritionName) {
        case "fats":
          fats = Fats(lowerLimit, upperLimit);
          break;
        case "saturates":
          saturates = Saturates(lowerLimit, upperLimit);
          break;
        case "carbs":
          carbs = Carbs(lowerLimit, upperLimit);
          break;
        case "sugars":
          sugars = Sugars(lowerLimit, upperLimit);
          break;
        case "protein":
          protein = Protein(lowerLimit, upperLimit);
          break;
        case "salt":
          salt = Salt(lowerLimit, upperLimit);
          break;
      }
    }

    if (fats != null && saturates != null && carbs != null && sugars != null && protein != null && salt != null) {
      nutritionalInformation = NutritionalInformation(fats, saturates, carbs, sugars, protein, salt);
    }


    return nutritionalInformation;
  }

  MealPlanCollection parseMealPlanCollection(Map<String, dynamic> parsedJson) {
    MealPlanCollection mealPlanCollection = MealPlanCollection();
    for (String mealPlanName in parsedJson.keys) {
      Map<String, dynamic> entry = parsedJson[mealPlanName];
      DateTime start = DateTime.parse(entry["start"]);
      DateTime end = DateTime.parse(entry["end"]);
      List<dynamic> meals = entry["meals"];
      Map<String, dynamic> plan = entry["plan"];
      MealPlan mealPlan = MealPlan(start, end, plan, meals, name: mealPlanName);
      mealPlanCollection.addMealPlan(mealPlan);
    }
    return mealPlanCollection;
  }

  Pantry parsePantry(Map<String, dynamic> parsedJson) {
    Pantry pantry = Pantry();
    for (String ingredientName in parsedJson.keys) {
      Map<String, dynamic> entry = parsedJson[ingredientName];
      int ingredientQuantity = entry["ingredientQuantity"];
      String ingredientUnit = entry["ingredientUnit"];
      String ingredientCategory = entry["ingredientCategory"];
      Ingredient i = IngredientBuilder().withIngredientName(ingredientName).withAmount(ingredientQuantity, ingredientUnit).withCategory(ingredientCategory).build();
      pantry.putInPantry(i);
    }
    return pantry;
  }

  RecipeBook parseRecipeBook(Map<String, dynamic> parsedJson) {
    RecipeBook recipeBook = RecipeBook();

    for (String recipeName in parsedJson.keys) {
      Map<String, dynamic> entry = parsedJson[recipeName];
      List<dynamic> categories = entry["categories"];
      int portions = entry["portions"];
      List<Ingredient> ingredients = [];
      for (Map<String, dynamic> needed_ing in entry["needed_ingredients"]) {
        String ingredientName = needed_ing["ingredientName"].toString().replaceAll("_", " ");
        int ingredientQuantity = needed_ing["ingredientQuantity"];
        String ingredientUnit = needed_ing["ingredientUnit"];
        Ingredient i = IngredientBuilder().withIngredientName(ingredientName).withAmount(ingredientQuantity, ingredientUnit).build();
        ingredients.add(i);
      }
      Recipe r = Recipe(recipeName, portions, ingredients, false, categories);
      recipeBook.addRecipe(r);
      // TODO: implement freezable.
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
                "recipeBook": ${_recipeBook.toJson()},
                "mealPlanCollection": ${_mealPlanCollection.toJson()},
                "nutritionalTargets": ${_nutritionalInformation?.toJson()},
                "shoppingList": ${_shoppingList.toJson()}
              }
          ''');
    print("Saved shoppingList $_shoppingList");
    print("Saved.");
  }

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

  MealPlanCollection getMealPlanCollection() {
    return _mealPlanCollection;
  }

  NutritionalInformation? getNutritionalInformation() {
    return _nutritionalInformation;
  }

  ShoppingList? getShoppingList() {
    return _shoppingList;
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

  void setNutritionalInformation(NutritionalInformation n) {
    _nutritionalInformation = n;
  }

  void setShoppingList(ShoppingList shoppingList) {
    _shoppingList = shoppingList;
  }

}