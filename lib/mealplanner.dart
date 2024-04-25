import 'dart:convert';

import 'package:budget_meal/RecipeBook/IngredientModel.dart';
import 'package:budget_meal/WebStore/webshop.dart';

import 'Pantry/PantryModel.dart';
import 'RecipeBook/RecipeBookModel.dart';

class MealPlanner {
  // given a pantry (all ingredients owned by user),
  // a recipebook (all recipes owned by user),
  // and a webshop (all ingredients needed for the given recipes)
  //String createMealPlan(Pantry pantry, RecipeBook recipeBook, WebShop webShop) {
  String createMealPlan(RecipeBook recipeBook) {
    // TODO: replace testPantry with real pantry
    Pantry pantry = generateTestPantry();
    // TODO: replace testRecipeBook with real recipeBook
    //RecipeBook recipeBook = generateTestRecipeBook();

    List<String> ingredients = [];
    for (Recipe recipe in recipeBook.getRecipes()) {
      for (Ingredient ingredient in recipe.getIngredients()) {
        if (!ingredients.contains(ingredient.getIngredientName())) {
          ingredients.add(ingredient.getIngredientName());
        }
      }
    }

    Map<String, dynamic> generateJson() => {
      "ingredient": ingredients,
      "recipe": recipeBook.getRecipeNames(normalised: true),
      "pantry_item": {
        for (Ingredient i in pantry.getPantryItems()) i.getIngredientName(normalised: true) : i.getQuantity()
      },
      "nutrient_needed": {
        "protein": [50, 80],
        //"fats": [18, 31],
        //"carbs": [34, 156]
      },
      "has_nutrient": {
        "cereal": {
        //for (Recipe r in recipeBook.getRecipes()) r.getRecipeName(): {
          "protein": 50
        }
      },
      "needs": {
        for (Recipe r in recipeBook.getRecipes()) r.getRecipeName(normalised: true): {
          for (Ingredient i in r.getIngredients()) i.getIngredientName(normalised: true) : i.getQuantity()
        }
      }
    };

    var finalJson = jsonEncode(generateJson());
    print(finalJson);
    return finalJson;

    // TODO: mealplan (as a file)
    
    // TODO: replace testPantry with real pantry
    //pantry = generateTestPantry();
    // TODO: replace testRecipeBook with real recipeBook
    //recipeBook = generateTestRecipeBook();

    //WebShop webShop = WebShop();
    //webShop.fillWebShop(recipeBook);

    // TODO: shopping list
    //List<IngredientBuilder> shopping_list = [];

    //var process = await Process.start('cat', []);
    //print(process.stdout);
    //process.stdin.writeln('clingo --version');

  }

  // TODO: delete once we have a real pantry
  // Testing purposes only!
  Pantry generateTestPantry() {
    Pantry testPantry = Pantry();

    // 200 ml milk stored in fridge
    Ingredient ownMilk = IngredientBuilder().withIngredientName("milk").withAmount(200, 'ml').inStorage('fridge').build();
    // 400 g of cereal flakes
    Ingredient ownCereal = IngredientBuilder().withIngredientName("cereal flakes").withAmount(400, 'g').build();
    // 100g bread in the cupboard
    Ingredient ownBread = IngredientBuilder().withIngredientName("bread").withAmount(100, 'g').inStorage('cupboard').build();

    testPantry.putInPantry(ownMilk);
    testPantry.putInPantry(ownCereal);
    testPantry.putInPantry(ownBread);

    return testPantry;
  }

  // TODO: delete once we have a real recipeBook
  RecipeBook generateTestRecipeBook() {
    RecipeBook testRecipeBook = RecipeBook();

    // cereal recipe
    Ingredient milk = IngredientBuilder().withIngredientName("milk").withAmount(300, 'ml').build();
    Ingredient cerealFlakes = IngredientBuilder().withIngredientName("cereal flakes").withAmount(300, 'g').build();

    List<Ingredient> ceIngredients = [];
    ceIngredients.add(milk);
    ceIngredients.add(cerealFlakes);

    Recipe cerealRecipe = Recipe("cereal", 1, ceIngredients, false);

    // sandwich recipe
    Ingredient bread = IngredientBuilder().withIngredientName("bread").withAmount(200, 'g').build();

    List<Ingredient> saIngredients = [];
    saIngredients.add(bread);

    Recipe sandwichRecipe = Recipe("sandwich", 1, saIngredients, false);

    testRecipeBook.addRecipe(cerealRecipe);
    testRecipeBook.addRecipe(sandwichRecipe);

    return testRecipeBook;
  }

  WebShop generateWebShop() {
    WebShop testWebShop = WebShop();

    Ingredient shopMilk = IngredientBuilder().withIngredientName("milk").withAmount(100, 'g').withTotalPrice(2.00).build();
    Ingredient shopBread = IngredientBuilder().withIngredientName("bread").withAmount(1000, 'g').withTotalPrice(1.00).build();
    Ingredient shopCerealFlakes = IngredientBuilder().withIngredientName("cereal").withAmount(400, 'g').withTotalPrice(4.00).build();

    testWebShop.addWebShopItem(shopMilk);
    testWebShop.addWebShopItem(shopBread);
    testWebShop.addWebShopItem(shopCerealFlakes);

    return testWebShop;
  }

}



