import 'dart:convert';
import 'package:http/http.dart' as http;

import '../RecipeBook/IngredientModel.dart';

class IngredientCatalog {
  List<Ingredient> _ingredientCatalog = [];

  IngredientCatalog();

  create() {
  //create() async {
    /*await buildIngredientCatalog().then((list) {
      _ingredientCatalog = list;
    });*/
    _ingredientCatalog = buildIngredientCatalog();
  }

  List<Ingredient> buildIngredientCatalog() {
    var ingredientCatalog = generateIngredientCatalog();
    return parseCatalogItems(ingredientCatalog);
  }

  /*Future<List<Ingredient>> buildIngredientCatalog() async {

    const serverUrl = "https://budget-meal.onrender.com/ingredients";
    const localUrl = "http://146.169.165.75:9674/ingredients"; //"http://10.0.2.2:5000";

    http.Response response;

    try {
      response = await http.post(Uri.parse(serverUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({})
      );
    } catch (e) {
      response = http.Response("No Internet connection", 503);
    }

    if (response.statusCode == 200) {
      return parseCatalogItems(response.body);
    }
    return [];
  }*/

  List<Ingredient> parseCatalogItems(String jsonBody) {
    final List<Ingredient> ingredients = [];
    final Map<String, dynamic> parsedJson = jsonDecode(jsonBody);
    for (String category in parsedJson.keys) {
      for (String ingredientName in parsedJson[category]) {
          Ingredient i = IngredientBuilder().withCategory(category).withIngredientTag(ingredientName).build();
          ingredients.add(i);
      }
    }
    return ingredients;
  }


  List<String> getAllIngredientNames() {
    print("Fetching ingredients...");
    List<String> ingredientNames = [];
    for (Ingredient i in _ingredientCatalog) {
      ingredientNames.add(i.getIngredientTag());
    }
    return ingredientNames;
  }

  List<Ingredient> getAllIngredients() {
    print("Fetching ingredients...");
    List<Ingredient> ingredients = [];
    for (Ingredient i in _ingredientCatalog) {
      ingredients.add(i);
    }
    return ingredients;
  }

  String generateIngredientCatalog() {
    var catalog = {
      "vegetables": [
    "tomato",
    "cherry tomato",
    "onion",
    "cucumber",
    "broccoli",
    "pepper",
    "brussels sprout",
    "radish",
    "beetroot",
    "bell pepper",
    "zucchini",
    "pumpkin",
    "asparagus",
    "carrot",
    "baby carrot",
    "parsnip",
    "spring onion",
    "potato",
    "spinach",
    "cauliflower",
    "red onion",
    "courgette",
    "celery",
    "green beans",
    "garlic",
    "sweet potato",
    "aubergine",
    "kale",
    "jalapeno",
    "avocado",
    "sweet corn",
    "cabbage",
    "leek",
    "lettuce",
    "olive",
    "green olive",
    "black olive",
    "pickle",
    ],
    "legumes": [
    "peas",
    "lentils",
    "green bean",
    "chickpea",
    "kidney beans",
    "red lentils",
    "green lentils",
    "edamame",
    "red beans",
    "beans",
    "soybeans",
    ],
    "fruit": [
    "fruit",
    "dried fruit",
    "apple",
    "lemon",
    "lime",
    "banana",
    "orange",
    "mandarin",
    "tangerine",
    "nectarine",
    "pineapple",
    "mango",
    "peach",
    "date",
    "coconut",
    "pear",
    "pomegranate",
    "grape",
    "melon",
    "watermelon",
    "apricot",
    "kiwi",
    "grapefruit",
    "plum",
    "fig",
    "currant",
    "raisin",
    "prune",
    "papaya",
    ],
    "berries": [
    "berries",
    "strawberry",
    "blueberry",
    "raspberry",
    "cranberry",
    "cherry",
    "sour cherry",
    "blackberry",
    "elderberry",
    ],
    "nuts": [
    "nuts",
    "chestnut",
    "walnut",
    "hazelnut",
    "pecan",
    "peanut",
    "almond",
    "cashew",
    "pistachio",
    "sesame seed",
    "chia seed",
    "pumpkin seed",
    "sunflower seed",
    "poppy seed",
    ],
    "mushroom": [
    "mushroom",
    "shiitake mushroom",
    "wild mushroom",
    "chestnut mushroom",
    ],
    "grains": [
    "rice",
    "white rice",
    "brown rice",
    "cereal flakes",
    "risotto rice",
    "jasmine rice",
    "bulgur",
    "grits",
    "sushi rice",
    ],
    "dairy": [
    "milk",
    "goat milk",
    "egg",
    "duck egg",
    "yogurt",
    "greek yogurt",
    "cream",
    "kefir",
    "butter",
    "sour cream",
    "whipped cream",
    "margarine",
    "custard",
    ],
    "substitutes": [
    "coconut milk",
    "almond milk",
    "soy milk",
    "oat milk",
    "rice milk",
    "cashew milk",
    "non-dairy milk",
    "almond butter",
    "vegan butter",
    "coconut butter",
    "tofu",
    "vegan mayo",
    "non-dairy yogurt",
    "vegan cheese",
    "vegan sausage",
    "vegan bacon",
    "quorn",
    ],
    "bakery": [
    "bread",
    "tortilla",
    "baguette",
    "pita",
    "sourdough",
    "brioche",
    "bagel",
    "croissant",
    "garlic bread",
    "crumpet",
    ],
    "cheese": [
    "cheese",
    "parmesan",
    "cream cheese",
    "cheddar",
    "mozzarella",
    "feta",
    "goat cheese",
    "mascarpone",
    "cottage cheese",
    "quark",
    "halloumi",
    "camambert",
    "sot cheese",
    "edam",
    ],
    "pasta": [
    "pasta",
    "macaroni",
    "penne",
    "spaghetti",
    "angel hair pasta",
    "lasagna sheets",
    "noodles",
    "rice noodles",
    "gnocchi",
    ],
    "fish": [
    "fish",
    "salmon",
    "smoked salmon",
    "cod",
    "tuna",
    "sea bass",
    "fish fillet",
    "fish fingers",
    "catfish",
    "haddock",
    "caviar",
    "herring",
    ],
    "seafood": [
    "prawns",
    "shrimp",
    "eel",
    "crab",
    "scallop",
    "squid",
    "lobster",
    "oyster",
    "octopus",
    "seaweed",
    "nori",
    "kelp",
    "crab stick",
    ],
    "meat items": [
    "chicken breast",
    "turkey breast",
    "duck breast",
    "chicken thighs",
    "chicken wings",
    "whole chicken",
    "whole turkey",
    "whole duck",
    "bacon",
    "minced meat",
    "minced beef",
    "minced pork",
    "minced lamb",
    "minced turkey",
    "beef steak",
    "pork shoulder",
    "lamb shoulder",
    "pork loin",
    "lamb loin",
    "pork chops",
    "lamb chops",
    "leg of lamb",
    "pulled pork",
    "ribs",
    "pork ribs",
    "beef ribs",
    "pork belly",
    "sausage",
    "frankfurter",
    "bratwurst",
    "chorizo",
    "pancetta",
    "chicken nuggets",
    "meatballs",
    "pepperoni",
    "salami",
    "ham",
    "burger patty",
    "rabbit",
    "beef",
    "chicken",
    "lamb",
    "duck",
    "goose",
    ],
    "spices": [
    "salt",
    "pepper",
    "cinnamon",
    "parsley",
    "cumin",
    "basil",
    "thyme",
    "ginger",
    "garlic powder",
    "oregano",
    "chili flakes",
    "chili powder",
    "paprika",
    "rosemary",
    "bay leaf",
    "mint",
    "all season",
    "white pepper",
    "nutmeg",
    "cayenne",
    "turmeric",
    "coriander",
    "marjoram",
    ],
    "baking": [
    "sugar",
    "brown sugar",
    "granulated sugar",
    "maple syrup",
    "caramel syrup",
    "chocolate syrup",
    "golden syrup",
    "strawberry syrup",
    "demerara sugar",
    "yeast",
    "flour",
    "self-raising flour",
    "whole wheat flour",
    "vanilla",
    "honey",
    "baking powder",
    "baking soda",
    "chocolate chips",
    "cocoa powder",
    "white chocolate",
    "white chocolate chips",
    "dark chocolate chips",
    "mint extract",
    "rum extract",
    "almond extract",
    ],
    "cupboard": [
    "breadcrumbs",
    "peanut butter",
    "jam",
    "raspberry jam",
    "apricot jam",
    "peach jam",
    "strawberry jam",
    "blueberry jam",
    "lady fingers",
    "waffles",
    ],
    "drinks": [
    "coffee",
    "instant coffee",
    "decaf coffee",
    "tea",
    "green tea",
    "chamomile tea",
    "jasmine tea",
    "english breakfast tea",
    "earl grey tea",
    "peppermint tea",
    "herbal tea",
    "juice",
    "orange juice",
    "cranberry juice",
    "pineapple juice",
    "apple juice",
    "matcha powder",
    "lemonade",
    "coke",
    "sprite",
    ],
    "oils": [
    "oil",
    "olive oil",
    "extra virgin olive oil",
    "vegetable oil",
    "sunflower oil",
    "rapeseed oil",
    "coconut oil",
    "cooking spray",
    "sesame oil",
    "pork fat",
    "beef fat",
    "duck fat",
    "lamb fat",
    "goose fat",
    ],
    "dressing": [
    "mayo",
    "ketchup",
    "bbq sauce",
    "mustard",
    "vinegar",
    "white vinegar",
    "balsamic vinegar",
    "red_wine vinegar",
    "white wine vinegar",
    "rice wine vinegar",
    "malt vinegar",
    "soy sauce",
    "wholegrain mustard",
    "tomato paste",
    "tomato sauce",
    "salsa",
    "pesto",
    "hummus",
    "gravy",
    "vegetable gravy",
    "beef gravy",
    "liver pate",
    "curry sauce",
    "lemon juice",
    "lime juice",
    ],
    "soups": [
    "stock",
    "chicken stock",
    "beef stock",
    "vegetable stock"
    ],
  };

  return jsonEncode(catalog);
  }

}