import 'RecipeBook.dart';
import 'ingredient.dart';

class WebShop {
  List<Ingredient> _webShopItems = [];

  // fills up list with ingredients
  fillWebShop(RecipeBook recipeBook) {
    for (final recipe in recipeBook.getRecipes()) {
      // webscrape for all ingredients needed for given recipe: search stores
      // to get all items with prices and nutritional information
      List<Ingredient> webscrapedIngredients = webscrape(recipe.getIngredients());
      _webShopItems.addAll(webscrapedIngredients);
    }
  }

  //TODO: implement webscraper
  List<Ingredient> webscrape(List<Ingredient> ingredients) {
    return ingredients;
  }

  List<Ingredient> getWebShopItems() {
    return _webShopItems;
  }

  void addWebShopItem(Ingredient ingredient) {
    _webShopItems.add(ingredient);
  }
}