import 'package:flutter/material.dart';
import '../ViewElements.dart';
import 'NewRecipeView.dart';
import 'RecipeBookModel.dart';

Widget Recipes(BuildContext context, RecipeBook recipeBook) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 50),
          TitleBar("My recipes"),
          Expanded(child: ListView(
            padding: const EdgeInsets.all(8),
            children: createCategoryTiles(context, recipeBook),
          )),
        ],
      ),
    );
  }

List<Widget> createCategoryTiles(context, testRecipeBook) {
  //Recipe cerealRecipe = Recipe("Cereal", 1, [], false);
  //Recipe sandwichRecipe = Recipe("Sandwich", 1, [], false, "Breakfast");
  //testRecipeBook.addRecipe(cerealRecipe);
  //testRecipeBook.addRecipe(sandwichRecipe);
  
  if (testRecipeBook.getCategories().isEmpty) {
    List<Widget> list = <Widget>[];
    list.add(ElevatedButton(onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipePage(recipeBook: testRecipeBook,)));
    },
      child: const Text("Add a recipe"),
    ));
    return list;
  } else {
    List<Widget> tiles = [];
    testRecipeBook.getCategories().forEach((c) {
      var categoryTile = ExpansionTile(
        title: Text(c),
        children: createRecipeTiles(testRecipeBook, c, context)
      );
      tiles.add(categoryTile);
    });
    return tiles;
  }
}

List<Widget> createRecipeTiles(RecipeBook testRecipeBook, String category, BuildContext context) {
  List<Widget> recipeTiles = [];
  testRecipeBook.getRecipesWithCategory(category).forEach((r) {
    var recipeTile = MyListTile(r.getRecipeName());
    recipeTiles.add(recipeTile);
  });
  recipeTiles.add(ElevatedButton(onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipePage(recipeBook: testRecipeBook,)));
  },
    child: const Text("Add a recipe"),
  ));
  return recipeTiles;
}