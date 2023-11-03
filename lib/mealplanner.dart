import 'package:budget_meal/ingredient.dart';
import 'package:budget_meal/webshop.dart';

import 'Pantry.dart';
import 'RecipeBook.dart';

class MealPlanner {
  // given a pantry (all ingredients owned by used),
  // a recipebook (all recipes owned by user),
  // and a webshop (all ingredients needed for the given recipes)
  void createMealPlan(Pantry pantry, RecipeBook recipeBook, WebShop webShop) async {
    // TODO: mealplan (as a file)
    
    // TODO: replace testPantry with real pantry
    pantry = generateTestPantry();
    // TODO: replace testRecipeBook with real recipeBook
    recipeBook = generateTestRecipeBook();

    WebShop webShop = WebShop();
    webShop.fillWebShop(recipeBook);

    // TODO: shopping list
    List<IngredientBuilder> shopping_list = [];

  }

  // TODO: delete once we have a real pantry
  // Testing purposes only!
  Pantry generateTestPantry() {
    Pantry testPantry = Pantry();

    // 250g mushroom from Tesco, stored in fridge, for £1.1
    Ingredient ownMushroom = IngredientBuilder().withIngredientName("mushroom").fromStore("Tesco").withAmount(250, 'grams').withTotalPrice(1.1).inStorage('fridge').build();
    // 6 eggs from Tesco, stored in fridge, for £1.5
    Ingredient ownEgg = IngredientBuilder().withIngredientName("egg").fromStore("Tesco").withAmount(6, 'pieces').withTotalPrice(1.5).inStorage('fridge').build();
    // 100g salt we found in the cupboard
    Ingredient ownSalt = IngredientBuilder().withIngredientName("salt").inStorage('cupboard').build();

    testPantry.putInPantry(ownMushroom);
    testPantry.putInPantry(ownEgg);
    testPantry.putInPantry(ownSalt);

    return testPantry;
  }

  // TODO: delete once we have a real recipeBook
  RecipeBook generateTestRecipeBook() {
    RecipeBook testRecipeBook = RecipeBook();

    // mushroom soup recipe
    Ingredient mushroom = IngredientBuilder().withIngredientName("mushroom").withAmount(300, 'grams').build();
    Ingredient rice = IngredientBuilder().withIngredientName("rice").withAmount(500, 'grams').build();
    Ingredient onion = IngredientBuilder().withIngredientName("onion").withAmount(1, 'pieces').build();
    Ingredient flour = IngredientBuilder().withIngredientName("flour").withAmount(1, 'tablespoons').build();
    Ingredient parsley = IngredientBuilder().withIngredientName("parsley").withAmount(0, 'to taste').build();
    Ingredient oil = IngredientBuilder().withIngredientName("oil").withAmount(1, 'tablespoons').build();
    Ingredient mustard = IngredientBuilder().withIngredientName("mustard").withAmount(0, 'to taste').build();
    Ingredient blackPepper = IngredientBuilder().withIngredientName("black pepper").withAmount(0, 'to taste').build();
    Ingredient salt = IngredientBuilder().withIngredientName("mustard").withAmount(0, 'to taste').build();

    List<Ingredient> msIngredients = [];
    msIngredients.add(mushroom);
    msIngredients.add(rice);
    msIngredients.add(onion);
    msIngredients.add(flour);
    msIngredients.add(parsley);
    msIngredients.add(oil);
    msIngredients.add(mustard);
    msIngredients.add(blackPepper);
    msIngredients.add(salt);

    Recipe mushroomSoupRecipe = Recipe("mushroom soup", 4, msIngredients, false);

    // fried egg recipe
    Ingredient egg = IngredientBuilder().withIngredientName("egg").withAmount(2, 'pieces').build();

    List<Ingredient> feIngredients = [];
    feIngredients.add(egg);
    feIngredients.add(salt);
    feIngredients.add(blackPepper);
    feIngredients.add(oil);

    Recipe friedEggRecipe = Recipe("fried egg", 1, feIngredients, false);

    // peanutbutter and jam sandwich
    Ingredient bread = IngredientBuilder().withIngredientName("bread").withAmount(1, 'slices').build();
    Ingredient pb = IngredientBuilder().withIngredientName("peanut butter").withAmount(0, "to taste").build();
    Ingredient jam = IngredientBuilder().withIngredientName("jam").withAmount(0, "to taste").build();

    List<Ingredient> pbjIngredients = [];
    pbjIngredients.add(bread);
    pbjIngredients.add(pb);
    pbjIngredients.add(jam);

    Recipe pbAndJamSandwichRecipe = Recipe("peanutbutter and jam sandwich", 1, pbjIngredients, false);

    testRecipeBook.addRecipe(mushroomSoupRecipe);
    testRecipeBook.addRecipe(friedEggRecipe);
    testRecipeBook.addRecipe(pbAndJamSandwichRecipe);

    return testRecipeBook;
  }
}



