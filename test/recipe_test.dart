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
    Recipe cerealRecipe = Recipe("Cereal", 1, [], false);

    recipeBook.addRecipe(cerealRecipe);

    assert (recipeBook.getRecipes().length == 1);
    assert (recipeBook.getRecipeNames().length == 1);

  });

  test('recipe book with one recipe returns singular list for getCategories', () {
    RecipeBook recipeBook = RecipeBook();
    Recipe cerealRecipe = Recipe("Cereal", 1, [], false);

    recipeBook.addRecipe(cerealRecipe);

    assert (recipeBook.getCategories().length == 1);

  });

  test('recipe with undefined category returns Uncategorised category for getCategory', () {
    Recipe cerealRecipe = Recipe("Cereal", 1, [], false);

    assert (cerealRecipe.getCategory() == "Uncategorised");

  });

  test('recipe with breakfast category returns breakfast category for getCategory', () {
    Recipe cerealRecipe = Recipe("Cereal", 1, [], false, "Breakfast");

    assert (cerealRecipe.getCategory() == "Breakfast");

  });

  test('two recipes with the same category returns a singular list for getCategories', () {
    RecipeBook recipeBook = RecipeBook();

    Recipe cerealRecipe = Recipe("Cereal", 1, [], false);
    Recipe sandwichRecipe = Recipe("Sandwich", 1, [], false);

    recipeBook.addRecipe(cerealRecipe);
    recipeBook.addRecipe(sandwichRecipe);

    assert (recipeBook.getCategories().length == 1);
    assert (recipeBook.getCategories().first == "Uncategorised");

  });

  test('two recipes with the different categories returns a list length of two for getCategories', () {
    RecipeBook recipeBook = RecipeBook();

    Recipe cerealRecipe = Recipe("Cereal", 1, [], false, "Breakfast");
    Recipe sandwichRecipe = Recipe("Sandwich", 1, [], false);

    recipeBook.addRecipe(cerealRecipe);
    recipeBook.addRecipe(sandwichRecipe);

    assert (recipeBook.getCategories().length == 2);
    assert (recipeBook.getCategories().first == "Breakfast");
    assert (recipeBook.getCategories().last == "Uncategorised");

  });

  test('empty recipe book returns empty list when searched by category', () {
    RecipeBook recipeBook = RecipeBook();

    assert (recipeBook.getRecipesWithCategory("Uncategorised").isEmpty);

  });

  test('recipe book with one recipe returns correct list when searched by category', () {
    RecipeBook recipeBook = RecipeBook();
    Recipe cerealRecipe = Recipe("Cereal", 1, [], false);

    recipeBook.addRecipe(cerealRecipe);

    assert (recipeBook.getRecipesWithCategory("Uncategorised").length == 1);
    assert (recipeBook.getRecipesWithCategory("Uncategorised").first == cerealRecipe);

    assert (recipeBook.getRecipesWithCategory("Breakfast").isEmpty);

  });

}