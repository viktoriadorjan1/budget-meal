import 'package:flutter/material.dart';
import '../RecipeBook/IngredientModel.dart';
import '../UserData/UserData.dart';
import '../ViewElements.dart';

Widget PantryView({required List<Ingredient> existingIngredients, required UserData userData}) {
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
                CreateCategoryTiles(userData: userData, existingIngredients: existingIngredients)
              ],
            )
        ),
      ],
    ),
  );
}

class CreateCategoryTiles extends StatefulWidget {
  final UserData userData;
  final List<Ingredient> existingIngredients;

  const CreateCategoryTiles({super.key, required this.userData, required this.existingIngredients});

  @override
  State<CreateCategoryTiles> createState() => _CreateCategoryTilesState();
}

class _CreateCategoryTilesState extends State<CreateCategoryTiles>{
  List<String> categories = [];

  // Inserted ingredient properties
  String ingredientName = "";
  String ingredientAmount = "";
  String ingredientUnit = "";

  @override
  Widget build(BuildContext context) {
    // build categories of the ingredients
    for (Ingredient ingredient in widget.existingIngredients) {
      String category = ingredient.getCategory();
      if (!categories.contains(category)) {
        categories.add(ingredient.getCategory());
      }
    }
    // map all categories to null initially
    Map<String, Widget?> cat = {
      for (Ingredient i in widget.existingIngredients) i.getIngredientName() : null
    };
    List<Widget> tiles = [];
    for (var c in categories) {
      var categoryTile = ExpansionTile(
        onExpansionChanged: (value) {
          setState(() {});
        },
          initiallyExpanded: true,
            title: Text(c),
            children: inactivePantryItemTiles(c) + <Widget>[
              GenerateEditIngredientForm(cat: cat, category: c, ingredientName: ingredientName, ingredientAmount: ingredientAmount, ingredientUnit: ingredientUnit, refresh: refreshCategoryTiles, userData: widget.userData, existingIngredients: widget.existingIngredients,)
            ],
      );
      tiles.add(categoryTile);
      //cat[c] = null;
    }
    return Column(children: tiles,);
  }

  void refreshCategoryTiles() {
    setState(() {});
  }

  List<Widget> inactivePantryItemTiles(String category) {
    List<Widget> tiles = [];

    for (var i in widget.userData.getPantry().getItemsWithCategory(category)) {
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
                  onPressed: () async {
                    widget.userData.getPantry().removeFromPantry(i);
                    await widget.userData.saveUserData();
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

  Widget IngredientTile(String name, String quantity, String unit) {
    return Row(
      children: [
        Text(name),
        Text("$quantity $unit"),
      ],
    );
  }
}

class GenerateEditIngredientForm extends StatefulWidget {
  final Map<String, Widget?> cat;
  final String category;
  String ingredientName;
  String ingredientAmount;
  String ingredientUnit;
  final UserData userData;
  final List<Ingredient> existingIngredients;
  final void Function() refresh;
  GenerateEditIngredientForm({super.key, required this.cat, required this.category, required this.ingredientName, required this.ingredientAmount, required this.ingredientUnit, required this.refresh, required this.userData, required this.existingIngredients});

  @override
  State<GenerateEditIngredientForm> createState() => _GenerateEditIngredientFormState();
}

class _GenerateEditIngredientFormState extends State<GenerateEditIngredientForm> {
  final pantryItemKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: pantryItemKey,
        child: Column(
          children: [
            InsertEditPantryItemTile(editPantryItemTile: widget.cat[widget.category]),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                if (widget.cat[widget.category] == null) {
                  pantryItemKey.currentState?.reset();
                  widget.cat[widget.category] = EditIngredientTile(widget.existingIngredients, widget.category);
                }
              },
              child: const Text("Add ingredient"),
            ),
          ],
        )
    );
  }

  Widget EditIngredientTile(List<Ingredient> existingIngredients, String category) {
    List<String> units = ['grams', 'milliliters', 'pieces'];
    List<String> existingIngredientNames = [];
    existingIngredientNames.addAll(existingIngredients.map((Ingredient i) {
      if (i.getCategory() == category) {
        return i.getIngredientName();
      }
      return "";
    }));

    existingIngredientNames.removeWhere((String element) => element == "");

    //List<String?> existingIngredientNames = existingIngredients.map((Ingredient i) {
    //  if (i.getCategory() == category) {
    //    return i.getIngredientName();
    //  }
    //}).toList();

    String? selectedIngredient;
    var selectedUnit = units.first;
    return Container(
      width: getScreenWidth(),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      color: const Color(0xFFF3F9F6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 118,
                height: 80,
                child: DropdownButtonFormField(
                  value: selectedIngredient,
                  validator: (name) {
                    if (name == null) return "Required *";
                    widget.ingredientName = name;
                    return null;
                  },
                  hint: const Text("Select..."),
                  items: existingIngredientNames.map<DropdownMenuItem<String>>((String value) {
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
                    widget.ingredientAmount = quantity;
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 100,
                height: 80,
                child: DropdownButtonFormField(
                  validator: (unit) {
                    widget.ingredientUnit = unit!;
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
            ],),
          Row(children: [
            IconButton(
                onPressed: () {
                  widget.cat[widget.category] = null;
                  setState(() {});
                },
                icon: const Icon(Icons.delete)
            ),
            IconButton(
                onPressed: () async {
                  setState(() {});
                  if (pantryItemKey.currentState!.validate()) {
                    Ingredient i = IngredientBuilder().withIngredientName(
                        widget.ingredientName).withAmount(
                        int.parse(widget.ingredientAmount),
                        widget.ingredientUnit)
                        .withCategory(widget.category)
                        .build();
                    widget.userData.getPantry().putInPantry(i);
                    pantryItemKey.currentState?.reset();
                    widget.cat[widget.category] = null;
                    await widget.userData.saveUserData();
                    widget.refresh();
                  }
                },
                icon: const Icon(Icons.coronavirus)
            ),
          ],),
        ],
      ),
    );
  }
}

class InsertEditPantryItemTile extends StatefulWidget {
  final dynamic editPantryItemTile;

  const InsertEditPantryItemTile({super.key, this.editPantryItemTile});
  
  @override
  State<InsertEditPantryItemTile> createState() => _InsertEditPantryItemTileState();
}

class _InsertEditPantryItemTileState extends State<InsertEditPantryItemTile>{
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[editPantryItemTile()]
    );
  }

  Widget editPantryItemTile() {
    return SizedBox(
        height: 150,
        child: widget.editPantryItemTile
    );
  }
}