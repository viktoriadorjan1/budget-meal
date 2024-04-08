import 'dart:convert';

import 'package:budget_meal/ingredient.dart';
import 'package:budget_meal/webshop.dart';

import 'Pantry.dart';
import 'RecipeBook.dart';

class MealPlanner {
  // given a pantry (all ingredients owned by user),
  // a recipebook (all recipes owned by user),
  // and a webshop (all ingredients needed for the given recipes)
  //String createMealPlan(Pantry pantry, RecipeBook recipeBook, WebShop webShop) {
  String createMealPlan() {
    String json = "";

    // TODO: replace testPantry with real pantry
    //Pantry pantry = generateTestPantry();
    // TODO: replace testRecipeBook with real recipeBook
    RecipeBook recipeBook = generateTestRecipeBook();
    // TODO: replace testWebShop with real WebShop
    //WebShop webShop = generateWebShop();

    List<String> recipeNames = recipeBook.getRecipeNames();


    json += jsonEncode({
      "recipe": recipeNames
    });

    print(json);

    // TODO: Replace with real json
    return jsonEncode({
      "recipe": ["cereal", "sandwich"],
      "ingredient": ["milk", "cereal_flakes", "bread"],
      "nutrient": ["protein", "carbs"],
      "pantry_item": {
        "milk": 200,
        "cereal_flakes": 400,
        "bread": 100
      },
      "i_costs": {
        "milk": [100, 2.00],
        "cereal_flakes": [400, 4.00],
        "bread": [1000, 1.00]
      },
      "nutrient_needed": {
        "protein": [50, 80]
      },
      "has_nutrient": {
        "cereal": {
          "protein": 50
        }
      },
      "needs": {
        "cereal": {
          "cereal_flakes": 300,
          "milk": 300
        },
        "sandwich": {
          "bread": 200
        }
      }
    });



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
    Ingredient cereal_flakes = IngredientBuilder().withIngredientName("cereal flakes").withAmount(300, 'g').build();

    List<Ingredient> ceIngredients = [];
    ceIngredients.add(milk);
    ceIngredients.add(cereal_flakes);

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

    Ingredient shopMilk = IngredientBuilder().withIngredientName("milk").withAmount(100, 'g').withTotalPrice(200).build();
    Ingredient shopBread = IngredientBuilder().withIngredientName("bread").withAmount(1000, 'g').withTotalPrice(100).build();
    Ingredient shopCerealFlakes = IngredientBuilder().withIngredientName("cereal flakes").withAmount(400, 'g').withTotalPrice(400).build();

    testWebShop.addWebShopItem(shopMilk);
    testWebShop.addWebShopItem(shopBread);
    testWebShop.addWebShopItem(shopCerealFlakes);

    return testWebShop;
  }

}



