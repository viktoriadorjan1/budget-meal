import 'package:budget_meal/Pantry/PantryModel.dart';
import 'package:budget_meal/RecipeBook/IngredientModel.dart';
import 'package:flutter_test/flutter_test.dart';

Ingredient egg = IngredientBuilder().withIngredientName("egg").withTotalPrice(1.5).withAmount(6, 'pieces').build();
Ingredient tomato = IngredientBuilder().withIngredientName("tomato").build();
Ingredient mushroom = IngredientBuilder().withIngredientName("mushroom").withAmount(300, 'grams').build();

void main() {
  test('putInPantry puts item to pantry', () {
    Pantry pantry = Pantry();

    assert (pantry.length() == 0);

    pantry.putInPantry(egg);

    assert (pantry.length() == 1);

    pantry.putInPantry(egg);

    assert (pantry.length() == 2);

  });

  test('putInPantry deletes price of ingredient', () {
    Pantry pantry = Pantry();

    Ingredient bacon = IngredientBuilder().withIngredientName("bacon").withTotalPrice(1.5).withAmount(6, 'pieces').build();

    assert (pantry.length() == 0);
    assert (bacon.getTotalPrice() == 1.5);
    //assert (bacon.getPerUnitPrice() == (1.5 / 6));

    pantry.putInPantry(bacon);

    assert (pantry.length() == 1);
    assert (bacon.getTotalPrice() == 0);
    //assert (bacon.getPerUnitPrice() == 0);

  });

  test('removeFromPantry throws error for empty pantry', () {
    Pantry pantry = Pantry();
    expect(() => pantry.removeFromPantry(egg), throwsA("Pantry does not contain this ingredient"));
  });

  test('removeFromPantry throws error for removing non-existent item', () {
    Pantry pantry = Pantry();
    pantry.putInPantry(egg);

    assert (pantry.length() == 1);

    expect(() => pantry.removeFromPantry(tomato), throwsA("Pantry does not contain this ingredient"));

    assert (pantry.length() == 1);

    Ingredient otherEgg = IngredientBuilder().withIngredientName("egg").withTotalPrice(5).build();
    expect(() => pantry.removeFromPantry(otherEgg), throwsA("Pantry does not contain this ingredient"));

    assert (pantry.length() == 1);
  });

  test('removeFromPantry removes item from pantry', () {
    Pantry pantry = Pantry();

    assert (pantry.length() == 0);

    pantry.putInPantry(egg);
    assert (pantry.length() == 1);

    pantry.removeFromPantry(egg);

    assert (pantry.length() == 0);
  });

  test('useFromPantry throws error for empty pantry', () {
    Pantry pantry = Pantry();
    expect (() => pantry.useFromPantry(egg, 1, "piece"), throwsA("Pantry does not contain this ingredient"));
    assert (pantry.length() == 0);
  });

  test('useFromPantry throws error for using non-existent item', () {
    Pantry pantry = Pantry();
    pantry.putInPantry(tomato);

    assert (pantry.length() == 1);

    expect (() => pantry.useFromPantry(egg, 1, "piece"), throwsA("Pantry does not contain this ingredient"));

    assert (pantry.length() == 1);

  });

  test('useFromPantry throws error for unknown quantity item', () {
    Pantry pantry = Pantry();
    pantry.putInPantry(tomato);

    assert (pantry.length() == 1);

    expect (() => pantry.useFromPantry(tomato, 1, "piece"), throwsA("The amount of this ingredient is Unknown"));

    assert (pantry.length() == 1);
  });

  test('useFromPantry throws error for using too much of an item', () {
    Pantry pantry = Pantry();
    pantry.putInPantry(mushroom);

    assert (pantry.length() == 1);
    assert (mushroom.getQuantity() == 300);

    expect (() => pantry.useFromPantry(mushroom, 400, "grams"), throwsA("Pantry does not have enough of this ingredient"));

    assert (pantry.length() == 1);
    assert (mushroom.getQuantity() == 300);

  });

  // TODO
  test('convertUnit converts 0.5kg to 500g correctly', () {});

  // TODO
  test('useFromPantry throws error for using too much of an item with convertUnit', () {});

  // TODO
  test('useFromPantry updates amount in pantry with convertUnit', () {});

  // TODO
  test('useFromPantry removes item from pantry if all used up with convertUnit', () {});

  test('useFromPantry updates amount in pantry', () {
    Pantry pantry = Pantry();

    assert (pantry.length() == 0);

    pantry.putInPantry(mushroom);
    assert (pantry.length() == 1);
    assert (mushroom.getQuantity() == 300);
    assert (mushroom.getUnit() == 'grams');

    pantry.useFromPantry(mushroom, 250, 'grams');
    assert (pantry.length() == 1);
    assert (mushroom.getQuantity() == 50);
    assert (mushroom.getUnit() == 'grams');

  });

  test('useFromPantry removes item from pantry if all used up', () {
    Pantry pantry = Pantry();

    assert (pantry.length() == 0);

    Ingredient cucumber = IngredientBuilder().withIngredientName("cucumber").withAmount(300, 'grams').build();

    pantry.putInPantry(cucumber);
    assert (pantry.length() == 1);
    assert (cucumber.getQuantity() == 300);
    assert (cucumber.getUnit() == 'grams');

    pantry.useFromPantry(cucumber, 300, 'grams');
    assert (pantry.length() == 0);
    assert (cucumber.getQuantity() == 0);
    assert (cucumber.getUnit() == 'grams');

  });

  test('length returns 0 for empty pantry', () {
    Pantry pantry = Pantry();
    assert (pantry.length() == 0);
  });

  test('getPantryItems() returns empty list for empty pantry', () {
    Pantry pantry = Pantry();
    assert (pantry.getPantryItems().isEmpty);
  });

  test('getPantryItems() returns correct list for pantry', () {
    Pantry pantry = Pantry();

    pantry.putInPantry(mushroom);
    pantry.putInPantry(egg);

    List<Ingredient> pantryItems = pantry.getPantryItems();
    assert (pantryItems[0] == mushroom);
    assert (pantryItems[1] == egg);
  });

  test('getCategory returns other for undefined category', () {
    Ingredient milk = IngredientBuilder().withIngredientName("milk").build();
    assert (milk.getCategory() == "other");
  });

  test('getCategory returns correct category for defined category', () {
    Ingredient milk = IngredientBuilder().withIngredientName("milk").withCategory("dairy").build();
    assert (milk.getCategory() == "dairy");
  });

  test('getItemsWithCategory returns empty list for empty category', () {
    Pantry pantry = Pantry();
    assert (pantry.getItemsWithCategory("vegetables").isEmpty);

    pantry.putInPantry(mushroom);
    assert (pantry.getItemsWithCategory("vegetables").isEmpty);
  });

  test('getItemsWithCategory returns correct list for category', () {
    Pantry pantry = Pantry();

    pantry.putInPantry(mushroom);
    assert (pantry.getItemsWithCategory("other").isNotEmpty);
    assert (pantry.getItemsWithCategory("other").first.getIngredientName() == "mushroom");

    Ingredient milk = IngredientBuilder().withIngredientName("milk").withCategory("dairy").build();
    pantry.putInPantry(milk);

    assert (pantry.getItemsWithCategory("dairy").isNotEmpty);
    assert (pantry.getItemsWithCategory("dairy").first.getIngredientName() == "milk");
  });

}