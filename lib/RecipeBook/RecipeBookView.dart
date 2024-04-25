import 'package:budget_meal/main.dart';
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: createCategoryTiles(context, recipeBook),
            )
          ),
        ],
      ),
    );
  }

List<Widget> createCategoryTiles(context, testRecipeBook) {
  
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
    var recipeTile = PopupMenuButton<int>(
        initialValue: null,
        color: const Color(0xFFF3F9F6),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            onTap: () {
              testRecipeBook.removeRecipe(r);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage(recipeBook: testRecipeBook)));
            },
            value: 0,
            child: const Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Delete"),
                  Icon(Icons.delete)
                ]
            ),
          ),
          const PopupMenuItem(
            value: 1,
            child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Edit"),
                  Icon(Icons.edit)
                ]
            ),
          ),
        ],
        child: MyListTile(title: r.getRecipeName())
      //Text(title, style: const TextStyle(color: Color(0xFF26BDC6), fontWeight: FontWeight.bold, fontSize: 18))
    );
    recipeTiles.add(recipeTile);
  });
  recipeTiles.add(ElevatedButton(onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipePage(recipeBook: testRecipeBook,)));
  },
    child: const Text("Add a recipe"),
  ));
  return recipeTiles;
}