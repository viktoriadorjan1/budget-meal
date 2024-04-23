import 'IngredientModel.dart';

class RecipeBook {
  List<Recipe> _recipes = [];

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

  List<String> getCategories() {
    List<String> categories = [];
    for (Recipe r in _recipes) {
      String c = r.getCategory();
      if (!categories.contains(c)) {
        categories.add(c);
      }
    }
    return categories;
  }
}

class Recipe {
  String _recipeName = "";
  int _portions = 0;
  List<Ingredient> _ingredients = [];
  bool _isFreezable = false;
  String _category = "Uncategorised";
  double _totalPrice = 0;
  NutritionalInformation _totalNutritionalInfo = NutritionalInformation();

  Recipe(String recipeName, int portions, List<Ingredient> ingredients, bool isFreezable, [String category = "Uncategorised"]) {
    _recipeName = recipeName;
    _portions = portions;
    _ingredients = ingredients;
    _isFreezable = isFreezable;
    _category = category!;
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

  String getCategory() {
    return _category;
  }

}