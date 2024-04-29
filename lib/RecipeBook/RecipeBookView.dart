import 'package:budget_meal/main.dart';
import 'package:flutter/material.dart';
import '../Pantry/PantryModel.dart';
import '../ViewElements.dart';
import 'NewRecipeView.dart';
import 'RecipeBookModel.dart';

class RecipeBookView extends StatefulWidget {
  final RecipeBook recipeBook;
  final Pantry pantry;
  final List<String> existingIngredients;
  const RecipeBookView({super.key, required this.recipeBook, required this.pantry, required this.existingIngredients});

  @override
  State<RecipeBookView> createState() => _RecipeBookViewState();
}

class _RecipeBookViewState extends State<RecipeBookView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 50),
          TitleBar("My recipes"),
          Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: createCategoryTiles(context, widget.recipeBook, widget.pantry, widget.existingIngredients),
              )
          ),
        ],
      ),
    );
  }
}

List<Widget> createCategoryTiles(context, testRecipeBook, pantry, existingIngredients) {
  
  if (testRecipeBook.getCategories().isEmpty) {
    List<Widget> list = <Widget>[];
    list.add(ElevatedButton(onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipePage(recipeBook: testRecipeBook, pantry: pantry, existingIngredients: existingIngredients,)));
    },
      child: const Text("Add a recipe"),
    ));
    return list;
  } else {
    List<Widget> tiles = [];
    testRecipeBook.getCategories().forEach((c) {
      var categoryTile = ExpansionTile(
        title: Text(c),
        children: createRecipeTiles(testRecipeBook, c, pantry, existingIngredients, context)
      );
      tiles.add(categoryTile);
    });
    return tiles;
  }
}

List<Widget> createRecipeTiles(RecipeBook testRecipeBook, String category, Pantry pantry, List<String> existingIngredients, BuildContext context) {
  List<Widget> recipeTiles = [];
  testRecipeBook.getRecipesWithCategory(category).forEach((r) {
    var recipeTile = PopupMenuButton<int>(
        initialValue: null,
        color: const Color(0xFFF3F9F6),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            onTap: () {
              r.removeFromCategory(category);
              if (r.getCategories().isEmpty) {
                testRecipeBook.removeRecipe(r);
              }
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage(recipeBook: testRecipeBook, pantry: pantry, existingIngredients: existingIngredients,)));
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
          PopupMenuItem(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => NewRecipePage(recipeBook: testRecipeBook, recipe: r, pantry: pantry, existingIngredients: existingIngredients,)));
            },
            value: 1,
            child: const Row (
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipePage(recipeBook: testRecipeBook, pantry: pantry, existingIngredients: existingIngredients,)));
  },
    child: const Text("Add a recipe"),
  ));
  return recipeTiles;
}