import '../RecipeBook/IngredientModel.dart';
import 'dart:convert';

class Pantry {
  final List<Ingredient> _ingredients = [];

  putInPantry(Ingredient ingredient) {
    if (ingredient.getIngredientName() == "") {
      _ingredients.add(ingredient);
      return;
    }
    for (Ingredient pantryItem in _ingredients) {
      if (ingredient.getIngredientName() == pantryItem.getIngredientName()) {
        int previousQuantity = pantryItem.getQuantity();
        pantryItem.updateQuantity(previousQuantity + ingredient.getQuantity());
        return;
      }
    }
    _ingredients.add(ingredient);
  }

  removeFromPantry(Ingredient ingredient) {
    // check if ingredient exists in pantry.
    if (!_ingredients.contains(
        ingredient)) throw "Pantry does not contain this ingredient";

    _ingredients.remove(ingredient);
  }

  // Use generic ingredient from pantry e.g. "milk"
  Ingredient useGenericFromPantry(String ingredientTag, int amountToUse, String unitToUse) {
    // check if ingredient exists in pantry.
    Iterable<String> ingTags = _ingredients.map((Ingredient i) => i.getIngredientTag());

    if (!ingTags.contains(ingredientTag)) throw "Pantry does not contain this ingredient";

    // retrieve pantry item
    Ingredient? pantryItem;
    for (Ingredient i in _ingredients) {
      if (i.getIngredientTag() == ingredientTag) {
        pantryItem = i;
      }
    }
    if (pantryItem == null) throw "Pantry does not contain this ingredient";

    // check if amount of ingredient in pantry is known.
    String pantryUnit = pantryItem.getUnit();
    if (pantryUnit == "") throw "The amount of this ingredient is Unknown";
    // check if there is enough amount of ingredient in pantry.

    if (pantryUnit != unitToUse) {} // TODO: convert units

    int pantryItemQuantity = pantryItem.getQuantity();
    if (pantryItemQuantity < amountToUse) {
      throw "Pantry does not have enough of this ingredient";
    }

    // update quantity of ingredient in pantry.
    pantryItem.updateQuantity(pantryItemQuantity - amountToUse);
    // remove item completely if ingredient ran out.
    if (pantryItem.getQuantity() == 0) {
      removeFromPantry(pantryItem);
    }
    return pantryItem.copy();
  }

  // Use exact ingredient from pantry e.g. "Cowbelle milk"
  useFromPantry(String ingredientName, int amountToUse, String unitToUse) {
    // check if ingredient exists in pantry.
    Iterable<String> ingNames = _ingredients.map((Ingredient i) => i.getIngredientName());

    if (!ingNames.contains(ingredientName)) throw "Pantry does not contain this ingredient";

    // retrieve pantry item
    Ingredient? pantryItem;
    for (Ingredient i in _ingredients) {
      if (i.getIngredientName() == ingredientName) {
        pantryItem = i;
      }
    }
    if (pantryItem == null) throw "Pantry does not contain this ingredient";

    // check if amount of ingredient in pantry is known.
    String pantryUnit = pantryItem.getUnit();
    if (pantryUnit == "") throw "The amount of this ingredient is Unknown";
    // check if there is enough amount of ingredient in pantry.

    if (pantryUnit != unitToUse) {} // TODO: convert units

    int pantryItemQuantity = pantryItem.getQuantity();
    if (pantryItemQuantity < amountToUse) {
      throw "Pantry does not have enough of this ingredient";
    }

    // update quantity of ingredient in pantry.
    pantryItem.updateQuantity(pantryItemQuantity - amountToUse);
    // remove item completely if ingredient ran out.
    if (pantryItem.getQuantity() == 0) {
      removeFromPantry(pantryItem);
    }
  }

  int length() {
    return _ingredients.length;
  }

  List<Ingredient> getPantryItems() {
    return _ingredients;
  }

  List<Ingredient> getItemsWithCategory(String category) {
    List<Ingredient> ingredientsFound = [];
    for (Ingredient i in _ingredients) {
      if (i.getCategory() == category) {
        ingredientsFound.add(i);
      }
    }
    return ingredientsFound;
  }

  String toJson() {
    Map<String, dynamic> generateJson() => {
      for (Ingredient i in _ingredients) i.getIngredientTag() : {
        "ingredientQuantity": i.getQuantity(),
        "ingredientUnit": i.getUnit(),
        "ingredientCategory": i.getCategory()
      }
    };

    return jsonEncode(generateJson());
  }

  // returns the ingredient from the pantry if exists, null otherwise
  Ingredient? contains(Ingredient ingredient) {
    for (Ingredient i in _ingredients) {
      if (i.getIngredientTag() == ingredient.getIngredientTag()) {
        return i;
      }
    }
    return null;
  }
}