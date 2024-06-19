import 'package:budget_meal/RecipeBook/RecipeBookModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('empty recipe book returns empty list for getRecipes', () {
    RecipeBook recipeBook = RecipeBook();

    assert (recipeBook.getRecipes().isEmpty);
  });

  test('empty recipe book returns empty list for getCategories', () {
    RecipeBook recipeBook = RecipeBook();

    assert (recipeBook.getCategories().isEmpty);
  });

  test('recipe book with one recipe returns singular list for getRecipes', () {
    RecipeBook recipeBook = RecipeBook();
    Recipe cerealRecipe = Recipe("Cereal", 1, [], ["breakfast"]);

    recipeBook.addRecipe(cerealRecipe);

    assert (recipeBook.getRecipes().length == 1);
    assert (recipeBook.getRecipeNames().length == 1);

  });

  test('recipe book with one-category-recipe returns singular list for getCategories', () {
    RecipeBook recipeBook = RecipeBook();
    Recipe cerealRecipe = Recipe("Cereal", 1, [], ["breakfast"]);

    recipeBook.addRecipe(cerealRecipe);

    assert (recipeBook.getCategories().length == 1);

  });

  test('recipe book with multi-category-recipe returns multi-list for getCategories', () {
    RecipeBook recipeBook = RecipeBook();
    Recipe cerealRecipe = Recipe("Cereal", 1, [], ["breakfast", "lunch"]);

    recipeBook.addRecipe(cerealRecipe);

    assert (recipeBook.getCategories().length == 2);

  });

  test('recipe with breakfast category returns breakfast category for getCategory', () {
    Recipe cerealRecipe = Recipe("Cereal", 1, [], ["breakfast"]);

    assert (cerealRecipe.getCategories().length == 1);
    assert (cerealRecipe.getCategories().contains("breakfast"));

  });

  test('two recipes with the same category returns a singular list for getCategories', () {
    RecipeBook recipeBook = RecipeBook();

    Recipe cerealRecipe = Recipe("Cereal", 1, [], ["breakfast"]);
    Recipe sandwichRecipe = Recipe("Sandwich", 1, [], ["breakfast"]);

    recipeBook.addRecipe(cerealRecipe);
    recipeBook.addRecipe(sandwichRecipe);

    assert (recipeBook.getCategories().length == 1);
    assert (recipeBook.getCategories().contains("breakfast"));

  });

  test('two recipes with the different categories returns a list length of two for getCategories', () {
    RecipeBook recipeBook = RecipeBook();

    Recipe cerealRecipe = Recipe("Cereal", 1, [], ["breakfast"]);
    Recipe sandwichRecipe = Recipe("Sandwich", 1, [], ["lunch"]);

    recipeBook.addRecipe(cerealRecipe);
    recipeBook.addRecipe(sandwichRecipe);

    assert (recipeBook.getCategories().length == 2);
    assert (recipeBook.getCategories().first == "breakfast");
    assert (recipeBook.getCategories().last == "lunch");

  });

  test('empty recipe book returns empty list when searched by category', () {
    RecipeBook recipeBook = RecipeBook();

    assert (recipeBook.getRecipesWithCategory("breakfast").isEmpty);

  });

  test('recipe book with one recipe returns correct list when searched by category', () {
    RecipeBook recipeBook = RecipeBook();
    Recipe cerealRecipe = Recipe("Cereal", 1, [], ["breakfast"]);

    recipeBook.addRecipe(cerealRecipe);

    assert (recipeBook.getRecipesWithCategory("breakfast").length == 1);
    assert (recipeBook.getRecipesWithCategory("breakfast").first == cerealRecipe);

    assert (recipeBook.getRecipesWithCategory("lunch").isEmpty);

  });

}