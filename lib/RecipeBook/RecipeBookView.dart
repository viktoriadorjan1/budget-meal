import 'package:budget_meal/main.dart';
import 'package:flutter/material.dart';
import '../UserData/UserData.dart';
import '../ViewElements.dart';
import 'NewRecipeView.dart';

class RecipeBookView extends StatefulWidget {
  final List<String> existingIngredients;
  final UserData userData;
  const RecipeBookView({super.key, required this.existingIngredients, required this.userData});

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
                children: createCategoryTiles(context, widget.existingIngredients, widget.userData),
              )
          ),
        ],
      ),
    );
  }
}

List<Widget> createCategoryTiles(context, existingIngredients, UserData userData) {
  
  if (userData.getRecipeBook().getCategories().isEmpty) {
    List<Widget> list = <Widget>[];
    list.add(ElevatedButton(onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipePage(existingIngredients: existingIngredients, userData: userData,)));
    },
      child: const Text("Add a recipe"),
    ));
    return list;
  } else {
    List<Widget> tiles = [];
    userData.getRecipeBook().getCategories().forEach((c) {
      var categoryTile = ExpansionTile(
        title: Text(c),
        children: createRecipeTiles(c, existingIngredients, context, userData)
      );
      tiles.add(categoryTile);
    });
    return tiles;
  }
}

List<Widget> createRecipeTiles(String category, List<String> existingIngredients, BuildContext context, UserData userData) {
  List<Widget> recipeTiles = [];
  userData.getRecipeBook().getRecipesWithCategory(category).forEach((r) {
    var recipeTile = PopupMenuButton<int>(
        initialValue: null,
        color: const Color(0xFFF3F9F6),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            onTap: () async {
              r.removeFromCategory(category);
              if (r.getCategories().isEmpty) {
                userData.getRecipeBook().removeRecipe(r);
              }
              await userData.saveUserData();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage(existingIngredients: existingIngredients, userData: userData,)));
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
                      builder: (BuildContext context) => NewRecipePage(recipe: r, existingIngredients: existingIngredients, userData: userData,)));
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewRecipePage(existingIngredients: existingIngredients, userData: userData,)));
  },
    child: const Text("Add a recipe"),
  ));
  return recipeTiles;
}