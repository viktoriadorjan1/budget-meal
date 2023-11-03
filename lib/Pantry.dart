import 'ingredient.dart';

class Pantry {
  final List<Ingredient> _ingredients = [];

  putInPantry(Ingredient ingredient) {
    ingredient.buy();
    _ingredients.add(ingredient);
  }

  removeFromPantry(Ingredient ingredient) {
    // check if ingredient exists in pantry.
    if (!_ingredients.contains(
        ingredient)) throw "Pantry does not contain this ingredient";

    _ingredients.remove(ingredient);
  }

  useFromPantry(Ingredient ingredient, double amountToUse, String unitToUse) {
    // check if ingredient exists in pantry.
    if (!_ingredients.contains(
        ingredient)) throw "Pantry does not contain this ingredient";
    // check if amount of ingredient in pantry is known.
    Ingredient pantryItem = _ingredients.elementAt(
        _ingredients.indexOf(ingredient));
    String pantryUnit = pantryItem.getUnit();
    if (pantryUnit == "") throw "The amount of this ingredient is Unknown";
    // check if there is enough amount of ingredient in pantry.

    if (pantryUnit != unitToUse) {} // TODO: convert units

    double pantryItemQuantity = pantryItem.getQuantity();
    if (pantryItemQuantity < amountToUse) {
      throw "Pantry does not have enough of this ingredient";
    }

    // update quantity of ingredient in pantry.
    pantryItem.updateQuantity(pantryItemQuantity - amountToUse);
    // remove item completely if ingredient ran out.
    if (pantryItem.getQuantity() == 0) removeFromPantry(pantryItem);
  }

  int length() {
    return _ingredients.length;
  }

  List<Ingredient> getPantryItems() {
    return _ingredients;
  }
}