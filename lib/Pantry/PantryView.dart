import 'package:flutter/material.dart';
import '../RecipeBook/IngredientModel.dart';
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
              children: [
                CreateCategoryTiles(pantry: pantry)
              ],
            )
        ),
      ],
    ),
  );
}

class CreateCategoryTiles extends StatefulWidget {
  final Pantry pantry;

  const CreateCategoryTiles({super.key, required this.pantry});

  @override
  State<CreateCategoryTiles> createState() => _CreateCategoryTilesState();
}

class _CreateCategoryTilesState extends State<CreateCategoryTiles>{
  List<String> categories = ["vegetables", "bakery", "mushrooms", "fruit", "seeds", "cheese", "dairy", "meat items", "fish", "spices", "cupboard", "other"];
  Widget? editIngredientTile;

  // Inserted ingredient properties
  String ingredientName = "";
  String ingredientAmount = "";
  String ingredientUnit = "";

  final _pantryItemKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [];
    for (var c in categories) {
      var categoryTile = ExpansionTile(
          title: Text(c),
          children: [
            Form(
              key: _pantryItemKey,
              child: CreatePantryItemTiles(pantry: widget.pantry, category: c, editIngredientTile: editIngredientTile),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                if (_pantryItemKey.currentState!.validate()) {
                  if (editIngredientTile != null) {
                    Ingredient i = IngredientBuilder().withIngredientName(ingredientName).withAmount(int.parse(ingredientAmount), ingredientUnit).withCategory(c).build();
                    widget.pantry.putInPantry(i);
                  }
                  _pantryItemKey.currentState?.reset();
                  editIngredientTile = EditIngredientTile();
                }
              },
              child: const Text("Add ingredient"),
            ),
          ]
      );
      tiles.add(categoryTile);
    }
    return Column(children: tiles,);
  }
  Widget EditIngredientTile() {
    List<String> units = ['grams', 'milliliters', 'pieces'];
    List<String> existingIngredients = ['milk', 'bread', 'cereal flakes'];

    String? selectedIngredient;
    var selectedUnit = units.first;
    return Container(
      width: getScreenWidth(),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      color: const Color(0xFFF3F9F6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 118,
            height: 80,
            child: DropdownButtonFormField(
              value: selectedIngredient,
              validator: (name) {
                if (name == null) return "Required *";
                ingredientName = name;
                return null;
              },
              hint: const Text("Select..."),
              items: existingIngredients.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => {selectedIngredient = value},
            ),
          ),
          SizedBox(
            width: 60,
            height: 80,
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (quantity) {
                if (quantity == null || quantity.isEmpty || int.parse(quantity) == 0) return "Required *";
                ingredientAmount = quantity;
                return null;
              },
            ),
          ),
          SizedBox(
            width: 100,
            height: 80,
            child: DropdownButtonFormField(
              validator: (unit) {
                ingredientUnit = unit!;
                return null;
              },
              value: selectedUnit,
              items: units.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => {selectedIngredient = value},
            ),
          ),
          IconButton(
              onPressed: () {
                editIngredientTile = null;
                setState(() {});
              },
              icon: const Icon(Icons.delete)
          ),
        ],),
    );
  }
}

class CreatePantryItemTiles extends StatefulWidget {
  final Pantry pantry;
  final String category;
  final dynamic editIngredientTile;

  const CreatePantryItemTiles({super.key, required this.pantry, required this.category, this.editIngredientTile});
  
  @override
  State<CreatePantryItemTiles> createState() => _CreatePantryItemTilesState();
}

class _CreatePantryItemTilesState extends State<CreatePantryItemTiles>{
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: inactivePantryItemTiles() + <Widget>[editPantryItemTile()]
      //createPantryItemTilesFunc(widget.pantry, widget.category),
    );
  }

  List<Widget> inactivePantryItemTiles() {
    List<Widget> tiles = [];

    for (var i in widget.pantry.getItemsWithCategory(widget.category)) {
      var inactiveIngredientTile = Container(
          width: getScreenWidth() * 0.8,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(5),
          color: const Color(0xFFF3F9F6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IngredientTile(i.getIngredientName(), i.getQuantity().toString(), i.getUnit()),
              IconButton(
                  onPressed: () {
                    widget.pantry.removeFromPantry(i);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete)
              ),
            ],
          )
      );
      tiles.add(inactiveIngredientTile);
    }
    return tiles;
  }

  Widget editPantryItemTile() {
    return SizedBox(
        height: 150,
        child: widget.editIngredientTile
    );
  }

  Widget IngredientTile(String name, String quantity, String unit) {
    return Row(
      children: [
        Text(name),
        Text("$quantity $unit"),
      ],
    );
  }
}