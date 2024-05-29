import 'dart:convert';

import 'package:budget_meal/RecipeBook/IngredientModel.dart';
import 'package:budget_meal/WebStore/webshop.dart';

import 'Pantry/PantryModel.dart';
import 'RecipeBook/RecipeBookModel.dart';
import 'UserData/UserData.dart';

class MealPlanner {
  // given a pantry (all ingredients owned by user),
  // and a recipe book (all recipes owned by user),
  // create a meal plan.
  String createMealPlan(UserData userData, List<String> days, List<dynamic> meals) {

    List<String> ingredientNames = [];
    List<Ingredient> ingredientsFromRecipes = [];
    for (Recipe recipe in userData.getRecipeBook().getRecipes()) {
      for (Ingredient ingredient in recipe.getIngredients()) {
        if (!ingredientsFromRecipes.contains(ingredient)) {
          ingredientsFromRecipes.add(ingredient);
        }
        if (!ingredientNames.contains(ingredient.getIngredientName(normalised: true))) {
          ingredientNames.add(ingredient.getIngredientName(normalised: true));
        }
      }
    }

    Map<String, dynamic> generateJson() => {
      "day": [for (String d in days) d],
      "meals": [for (String m in meals) m],
      "meal": {
        for (Recipe r in userData.getRecipeBook().getRecipes()) r.getRecipeName(normalised: true): r.getCategories()
      },
      "ingredient": ingredientNames,
      "recipe": userData.getRecipeBook().getRecipeNames(normalised: true),
      "pantry_item": {
        for (Ingredient i in ingredientsFromRecipes) if (!userData.getPantry().getPantryItems().contains(i)) i.getIngredientName(normalised: true) : [0, "grams"] else i.getIngredientName(normalised: true) : [i.getQuantity().round(), i.getUnit()],
        // only consider pantry items that are needed for recipes
        //for (Ingredient i in userData.getPantry().getPantryItems()) i.getIngredientName(normalised: true) : [i.getQuantity().round(), i.getUnit()]
      },
      "nutrient_needed": {
        "energy": [userData.getDailyCalories(), userData.getDailyCalories()],
        "protein": [userData.getNutritionalInformation()!.getProtein().getLowerLimit(), userData.getNutritionalInformation()!.getProtein().getUpperLimit()],
        "fat": [userData.getNutritionalInformation()!.getFats().getLowerLimit(), userData.getNutritionalInformation()!.getFats().getUpperLimit()],
        "saturates": [userData.getNutritionalInformation()!.getSaturates().getLowerLimit(), userData.getNutritionalInformation()!.getSaturates().getUpperLimit()],
        "carbs": [userData.getNutritionalInformation()!.getCarbs().getLowerLimit(), userData.getNutritionalInformation()!.getCarbs().getUpperLimit()],
        "sugar": [userData.getNutritionalInformation()!.getSugars().getLowerLimit(), userData.getNutritionalInformation()!.getSugars().getUpperLimit()],
        "salt": [userData.getNutritionalInformation()!.getSalt().getLowerLimit(), userData.getNutritionalInformation()!.getSalt().getUpperLimit()]
      },
      // this is useful when this specific ingredient is NOT in the web store but is in the pantry and a meal can be scheduled with it
      /*"ing_has_nutrient": [
        {
          "ingName": "milk",
          "ingAmount": 300,
          "nutrName": "protein",
          "nutrAmount": 5000
        }
      ],*/
      "needs": {
        for (Recipe r in userData.getRecipeBook().getRecipes()) r.getRecipeName(normalised: true): {
          for (Ingredient i in r.getIngredients()) i.getIngredientName(normalised: true) : [i.getQuantity() / r.getPortionSize(), i.getUnit()]
        }
      }
    };

    var finalJson = jsonEncode(generateJson());
    print(finalJson);
    return finalJson;

    // TODO: meal plan (as a file)

    // TODO: shopping list
    //List<IngredientBuilder> shopping_list = [];

    //var process = await Process.start('cat', []);
    //print(process.stdout);

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

    Recipe cerealRecipe = Recipe("cereal", 1, ceIngredients, false, ["breakfast"]);

    // sandwich recipe
    Ingredient bread = IngredientBuilder().withIngredientName("bread").withAmount(200, 'g').build();

    List<Ingredient> saIngredients = [];
    saIngredients.add(bread);

    Recipe sandwichRecipe = Recipe("sandwich", 1, saIngredients, false, ["breakfast", "lunch"]);

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



