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
    // Only considering relevant recipes based on the schedulable meals
    // e.g. do not include lunch recipes if we wish to schedule breakfast only
    RecipeBook relevantRecipeBookForMeals = RecipeBook();
    for (dynamic m in meals) {
      for (Recipe r in userData.getRecipeBook().getRecipesWithCategory(m)) {
        if (!relevantRecipeBookForMeals.contains(r)) {
          List<dynamic> finalCategories = r.getCategories().where((element) => meals.contains(element)).toList();
          Recipe newRecipe = Recipe(r.getRecipeName(), r.getPortionSize(), r.getIngredients(), finalCategories);
          relevantRecipeBookForMeals.addRecipe(newRecipe);
        }
      }
    }

    // Only consider ingredients from recipes that can be scheduled.
    // e.g. if mushroom is needed for a lunch item only, but we wish to schedule breakfast only, do not include
    List<String> ingredientNames = [];
    List<Ingredient> ingredientsFromRecipes = [];
    for (Recipe recipe in relevantRecipeBookForMeals.getRecipes()) {
      for (Ingredient ingredient in recipe.getIngredients()) {
        if (!ingredientsFromRecipes.contains(ingredient)) {
          ingredientsFromRecipes.add(ingredient);
        }
        if (!ingredientNames.contains(ingredient.getIngredientTag(normalised: true))) {
          ingredientNames.add(ingredient.getIngredientTag(normalised: true));
        }
      }
    }

    Map<String, dynamic> generateJson() => {
      "day": [for (String d in days) d],
      "meals": [for (String m in meals) m],
      "meal": {
        for (Recipe r in relevantRecipeBookForMeals.getRecipes()) r.getRecipeName(normalised: true): r.getCategories()
      },
      "ingredient": ingredientNames,
      "recipe": relevantRecipeBookForMeals.getRecipeNames(normalised: true),
      "pantry_item": {
        // only consider pantry items that are needed for the relevant recipes
        for (Ingredient i in ingredientsFromRecipes) if (userData.getPantry().contains(i) == null) i.getIngredientTag(normalised: true) : [0, "grams"] else userData.getPantry().contains(i)?.getIngredientTag(normalised: true) : [userData.getPantry().contains(i)?.getQuantity().round(), userData.getPantry().contains(i)?.getUnit()],
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
        for (Recipe r in relevantRecipeBookForMeals.getRecipes()) r.getRecipeName(normalised: true): {
          for (Ingredient i in r.getIngredients()) i.getIngredientTag(normalised: true) : [i.getQuantity() / r.getPortionSize(), i.getUnit()]
        }
      }
    };

    Map<String, dynamic> json = generateJson();

    var finalJson = jsonEncode(json);
    return finalJson;
  }

  // Testing purposes only!
  Pantry generateTestPantry() {
    Pantry testPantry = Pantry();

    // 200 ml milk stored in fridge
    Ingredient ownMilk = IngredientBuilder().withIngredientTag("milk").withAmount(200, 'ml').inStorage('fridge').build();
    // 400 g of cereal flakes
    Ingredient ownCereal = IngredientBuilder().withIngredientTag("cereal flakes").withAmount(400, 'g').build();
    // 100g bread in the cupboard
    Ingredient ownBread = IngredientBuilder().withIngredientTag("bread").withAmount(100, 'g').inStorage('cupboard').build();

    testPantry.putInPantry(ownMilk);
    testPantry.putInPantry(ownCereal);
    testPantry.putInPantry(ownBread);

    return testPantry;
  }

  // Testing purposes only!
  RecipeBook generateTestRecipeBook() {
    RecipeBook testRecipeBook = RecipeBook();

    // cereal recipe
    Ingredient milk = IngredientBuilder().withIngredientTag("milk").withAmount(300, 'ml').build();
    Ingredient cerealFlakes = IngredientBuilder().withIngredientTag("cereal flakes").withAmount(300, 'g').build();

    List<Ingredient> ceIngredients = [];
    ceIngredients.add(milk);
    ceIngredients.add(cerealFlakes);

    Recipe cerealRecipe = Recipe("cereal", 1, ceIngredients, ["breakfast"]);

    // sandwich recipe
    Ingredient bread = IngredientBuilder().withIngredientTag("bread").withAmount(200, 'g').build();

    List<Ingredient> saIngredients = [];
    saIngredients.add(bread);

    Recipe sandwichRecipe = Recipe("sandwich", 1, saIngredients, ["breakfast", "lunch"]);

    testRecipeBook.addRecipe(cerealRecipe);
    testRecipeBook.addRecipe(sandwichRecipe);

    return testRecipeBook;
  }

  // Testing purposes only!
  WebShop generateWebShop() {
    WebShop testWebShop = WebShop();

    Ingredient shopMilk = IngredientBuilder().withIngredientTag("milk").withAmount(100, 'g').withTotalPrice(2.00).build();
    Ingredient shopBread = IngredientBuilder().withIngredientTag("bread").withAmount(1000, 'g').withTotalPrice(1.00).build();
    Ingredient shopCerealFlakes = IngredientBuilder().withIngredientTag("cereal").withAmount(400, 'g').withTotalPrice(4.00).build();

    testWebShop.addWebShopItem(shopMilk);
    testWebShop.addWebShopItem(shopBread);
    testWebShop.addWebShopItem(shopCerealFlakes);

    return testWebShop;
  }

}



