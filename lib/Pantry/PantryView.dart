import 'package:flutter/material.dart';
import '../ViewElements.dart';
import 'PantryModel.dart';

Widget PantryView(Pantry pantry) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(height: 50),
        TitleBar("My pantry"),
        Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: createCategoryTiles(pantry),
            )
        ),
      ],
    ),
  );
}

List<Widget> createCategoryTiles(pantry) {
  List<String> categories = ["vegetables", "bakery", "mushrooms", "fruit", "seeds", "cheese", "dairy", "meat items", "fish", "spices", "cupboard", "other"];

  List<Widget> tiles = [];
  for (var c in categories) {
    var categoryTile = ExpansionTile(
        title: Text(c),
        children: [
          CreatePantryItemTiles(pantry: pantry, category: c)
        ]
    );
    tiles.add(categoryTile);
  }
  return tiles;
}

class CreatePantryItemTiles extends StatefulWidget {
  final Pantry pantry;
  final String category;

  const CreatePantryItemTiles({super.key, required this.pantry, required this.category});
  
  @override
  State<CreatePantryItemTiles> createState() => _CreatePantryItemTilesState();
}

class _CreatePantryItemTilesState extends State<CreatePantryItemTiles>{
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: createPantryItemTilesFunc(widget.pantry, widget.category),
    );
  }
}

List<Widget> createPantryItemTilesFunc(Pantry pantry, String category) {
  List<Widget> pantryItemTiles = [];
  pantry.getItemsWithCategory(category).forEach((i) {
    var pantryItemTile = const Text("This is an instance");
    pantryItemTiles.add(pantryItemTile);
  });
  pantryItemTiles.add(ElevatedButton(
    onPressed: () {
      //setState(() {});
    },
    child: Text("Add $category"),
  ));
  return pantryItemTiles;
}