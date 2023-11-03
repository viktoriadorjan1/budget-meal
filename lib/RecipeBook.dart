import 'ingredient.dart';

class RecipeBook {
  List<Recipe> _recipes = [];

  List<Recipe> getRecipes() {
    return _recipes;
  }

  void addRecipe(Recipe newRecipe) {
    _recipes.add(newRecipe);
  }
}

class Recipe {
  String _recipeName = "";
  int _portions = 0;
  List<Ingredient> _ingredients = [];
  bool _isFreezable = false;

  double _totalPrice = 0;
  NutritionalInformation _totalNutritionalInfo = NutritionalInformation();

  Recipe(String recipeName, int portions, List<Ingredient> ingredients, bool isFreezable) {
    _recipeName = recipeName;
    _portions = portions;
    _ingredients = ingredients;
    _isFreezable = isFreezable;
  }

  List<Ingredient> getIngredients() {
    return _ingredients;
  }

  String getRecipeName() {
    return _recipeName;
  }

}