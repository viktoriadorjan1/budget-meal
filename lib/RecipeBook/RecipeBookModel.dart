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
        "categories": r.getCategories(),
        "portions": r.getPortionSize(),
        "needed_ingredients": [
          for (Ingredient i in r.getIngredients()) {
            "ingredientName": i.getIngredientTag(normalised: true),
            "ingredientQuantity": i.getQuantity(),
            "ingredientUnit": i.getUnit()
          }
        ]
      }
    };

    return jsonEncode(generateJson());
  }

  bool contains(Recipe r) {
    for (Recipe rec in _recipes) {
      if (rec.getRecipeName() == r.getRecipeName()) {
        return true;
      }
    }
    return false;
  }

  Recipe? getRecipe(String recipeName) {
    for (Recipe r in _recipes) {
      if (r.getRecipeName() == recipeName) {
        return r;
      }
    }
    return null;
  }
}

class Recipe {
  String _recipeName = "";
  int _portions = 0;
  List<Ingredient> _ingredients = [];
  //bool _isFreezable = false;
  List<dynamic> _categories = [];

  Recipe(String recipeName, int portions, List<Ingredient> ingredients, List<dynamic> categories) {
    _recipeName = recipeName;
    _portions = portions;
    _ingredients = ingredients;
    //_isFreezable = isFreezable;
    _categories = categories;
  }

  List<Ingredient> getIngredients() {
    return _ingredients;
  }

  String getRecipeName({bool? normalised}) {
    if (normalised == null || !normalised) {
      return _recipeName;
    } else {
      return _recipeName.replaceAll(' ', '_').toLowerCase();
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

  void setCategories(List newCategories) {
    _categories = newCategories;
  }

}