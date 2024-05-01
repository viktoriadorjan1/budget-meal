import 'dart:convert';

import 'IngredientModel.dart';

class RecipeBook {
  final List<Recipe> _recipes = [];

  List<Recipe> getRecipes() {
    return _recipes;
  }

  List<String> getRecipeNames({bool? normalised}) {
    List<String> recipeNames = [];
    for (Recipe r in _recipes) {
      if (normalised == null || !normalised) {
        recipeNames.add(r.getRecipeName());
      } else {
        recipeNames.add(r.getRecipeName(normalised: true));
      }
    }
    return recipeNames;
  }

  void addRecipe(Recipe newRecipe) {
    _recipes.add(newRecipe);
  }

  void removeRecipe(Recipe recipe) {
    _recipes.remove(recipe);
  }

  List<String> getCategories() {
    List<String> categories = [];
    for (Recipe r in _recipes) {
      for (String c in r.getCategories()) {
        if (!categories.contains(c)) {
          categories.add(c);
        }
      }
    }
    return categories;
  }

  List<Recipe> getRecipesWithCategory(String category) {
    List<Recipe> recipesFound = [];
    for (Recipe r in _recipes) {
      if (r.getCategories().contains(category)) {
        recipesFound.add(r);
      }
    }
    return recipesFound;
  }

  String toJson() {
    Map<String, dynamic> generateJson() => {
      for (Recipe r in _recipes) r.getRecipeName(normalised: true) : {
        for (Ingredient i in r.getIngredients()) i.getIngredientName(normalised: true) : i.getQuantity()
      }
    };

    return jsonEncode(generateJson());
  }
}

class Recipe {
  String _recipeName = "";
  int _portions = 0;
  List<Ingredient> _ingredients = [];
  bool _isFreezable = false;
  List<dynamic> _categories = [];
  double _totalPrice = 0;
  NutritionalInformation _totalNutritionalInfo = NutritionalInformation();

  Recipe(String recipeName, int portions, List<Ingredient> ingredients, bool isFreezable, List<dynamic> categories) {
    _recipeName = recipeName;
    _portions = portions;
    _ingredients = ingredients;
    _isFreezable = isFreezable;
    _categories = categories;
  }

  List<Ingredient> getIngredients() {
    return _ingredients;
  }

  String getRecipeName({bool? normalised}) {
    if (normalised == null || !normalised) {
      return _recipeName;
    } else {
      return _recipeName.replaceAll(' ', '_');
    }
  }

  List<dynamic> getCategories() {
    return _categories;
  }

  int getPortionSize() {
    return _portions;
  }

  void removeFromCategory(String category) {
    _categories.remove(category);
  }

}