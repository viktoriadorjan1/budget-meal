import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../Pantry/PantryModel.dart';
import '../ViewElements.dart';
import '../main.dart';
import 'IngredientModel.dart';
import 'RecipeBookModel.dart';

class NewRecipePage extends StatefulWidget {
  final RecipeBook recipeBook;
  final Pantry pantry;
  final Recipe? recipe;
  const NewRecipePage({required this.recipeBook, this.recipe, super.key, required this.pantry});

  @override
  State<NewRecipePage> createState() => _NewRecipePageState();
}

class _NewRecipePageState extends State<NewRecipePage> {

  @override
  Widget build(BuildContext context) {
    if (widget.recipe == null) {
      return PopScope(
        canPop: false,
        child: Scaffold(
        appBar: AppBar(title: const Text("New recipe"), automaticallyImplyLeading: false,),
        backgroundColor: const Color(0xFFCFCFCF),
        body: ListView(
            children: <Widget> [
              Container(height: 50),
              NewRecipeForm(recipeBook: widget.recipeBook, pantry: widget.pantry,),
            ]),
      ),);
    }
    return PopScope(
        canPop: false, child: Scaffold(
      appBar: AppBar(title: const Text("Edit recipe"), automaticallyImplyLeading: false,),
      backgroundColor: const Color(0xFFCFCFCF),
      body: ListView(
          children: <Widget> [
            Container(height: 50),
            NewRecipeForm(recipeBook: widget.recipeBook, recipe: widget.recipe, pantry: widget.pantry,),
          ]),
    ));
  }
}

class NewRecipeForm extends StatefulWidget {
  final RecipeBook recipeBook;
  final Pantry pantry;
  final Recipe? recipe;
  const NewRecipeForm({required this.recipeBook, this.recipe, super.key, required this.pantry});

  @override
  State<NewRecipeForm> createState() => _NewRecipeFormState();
}

class _NewRecipeFormState extends State<NewRecipeForm> {
  final _key = GlobalKey<FormState>();
  final _ingredientKey = GlobalKey<FormState>();

  // New recipe properties
  String recipeName = "";
  List<dynamic> categories = [];
  String portionSize = "";
  List<Ingredient> ingredients = [];

  // Inserted ingredient properties
  String ingredientName = "";
  String ingredientAmount = "";
  String ingredientUnit = "";

  List listOfInactiveIngredientTiles = [];
  Widget? editIngredientTile;

  @override
  Widget build(BuildContext context) {
    if (widget.recipe != null) {
      recipeName = widget.recipe!.getRecipeName();
      categories = widget.recipe!.getCategories();
      portionSize = widget.recipe!.getPortionSize().toString();
      ingredients = widget.recipe!.getIngredients();
    }
    return Form(
      key: _key,
      child: Column(
        children: [
        TextFormField(
          initialValue: recipeName,
          decoration: const InputDecoration(
            labelText: "Recipe name *"
          ),
          validator: (n) {
            if (n == null || n.isEmpty) return "Please enter a name for your recipe";
            recipeName = n;
            return null;
          },
        ),
          MultiSelectChipField(
            items: [
              MultiSelectItem<String>("breakfast", "breakfast"),
              MultiSelectItem<String>("lunch", "lunch"),
            ],
            initialValue: categories,
            title: const Text("Meal type * (e.g. breakfast)"),
            onTap: (values) {},
            validator: (cats) {
              if (cats == null || cats.isEmpty) {
                return "Please select at least one type";
              } else {
                categories = cats;
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: portionSize.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: "Portion size *",
            ),
            validator: (size) {
              if (size == null || size.isEmpty || size == "0") return "Please enter how many portions this recipe makes";
              portionSize = size;
              return null;
            },
          ),
          Form(
            key: _ingredientKey,
            child: Column(
              children: [
                const Text("Ingredients:"),
                InsertIngredients(ingredients, editIngredientTile, listOfInactiveIngredientTiles),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    if (editIngredientTile == null) {
                      _ingredientKey.currentState?.reset();
                      editIngredientTile = EditIngredientTile();
                    }
                  },
                  child: const Text("Add ingredient"),
                ),
              ],
            )
          ),
          ElevatedButton(
            onPressed: () {
              if (_key.currentState!.validate() && editIngredientTile == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Saving..."))
                );
                // delete old recipe from recipe book, if exists
                Recipe oldRecipe = widget.recipe ?? Recipe("", 0, [], false, []);
                widget.recipeBook.removeRecipe(oldRecipe);
                // add new recipe to recipe book
                Recipe newRecipe = Recipe(recipeName, int.parse(portionSize), ingredients, false, categories);
                widget.recipeBook.addRecipe(newRecipe);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(recipeBook: widget.recipeBook, pantry: widget.pantry,)));
              }
            },
            child: const Text("OK")
          ),
      ],
    ));
  }

  Widget EditIngredientTile() {
    List<String> units = ['grams', 'milliliters', 'pieces'];
    List<String> existingIngredients = ['milk', 'bread', 'cereal flakes'];
    /*Map<String, String> categoryMap = {
      'milk' : 'dairy',
      'bread' : 'bakery',
      "cupboard" : "cereal flakes"
    };*/


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
            ],
          ),
          IconButton(
              onPressed: () {
                setState(() {});
                if (_ingredientKey.currentState!.validate()) {
                  if (editIngredientTile != null) {
                    Ingredient i = IngredientBuilder().withIngredientName(ingredientName).withAmount(int.parse(ingredientAmount), ingredientUnit).build();
                    ingredients.add(i);
                  }
                  _ingredientKey.currentState?.reset();
                  editIngredientTile = null; //EditIngredientTile();
                }
              },
              icon: const Icon(Icons.coronavirus)
          ),
        ],
      )
    );
  }
}

class InsertIngredients extends StatefulWidget {
  final List<Ingredient> ingredients;
  final List<dynamic> listOfInactiveIngredientTiles;
  final dynamic editIngredientTile;

  const InsertIngredients(this.ingredients, this.editIngredientTile, this.listOfInactiveIngredientTiles, {super.key});

  @override
  State<InsertIngredients> createState() => _InsertIngredientsState();
}

class _InsertIngredientsState extends State<InsertIngredients> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _inactiveIngredientTilesList() + <Widget>[
        editIngredientTile(),
      ]
    );
  }

  Widget editIngredientTile() {
    return SizedBox(
        height: 150,
        child: widget.editIngredientTile
    );
  }

  List<Widget> _inactiveIngredientTilesList() {
    List<Widget> tiles = [];
    for (var i in widget.ingredients) {
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
                widget.ingredients.remove(i);
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