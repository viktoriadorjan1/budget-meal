import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../UserData/UserData.dart';
import '../ViewElements.dart';
import '../main.dart';
import 'IngredientModel.dart';
import 'RecipeBookModel.dart';

class NewRecipePage extends StatefulWidget {
  final Recipe? recipe;
  final List<Ingredient> existingIngredients;
  final UserData userData;
  const NewRecipePage({this.recipe, super.key, required this.existingIngredients, required this.userData});

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
              NewRecipeForm(existingIngredients: widget.existingIngredients, userData: widget.userData,),
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
            NewRecipeForm(recipe: widget.recipe, existingIngredients: widget.existingIngredients, userData: widget.userData,),
          ]),
    ));
  }
}

class NewRecipeForm extends StatefulWidget {
  final Recipe? recipe;
  final List<Ingredient> existingIngredients;
  final UserData userData;

  const NewRecipeForm({this.recipe, super.key, required this.existingIngredients, required this.userData});

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

  Color ingColor = Colors.black;

  @override
  void initState() {
    //super.initState();
    if (widget.recipe != null) {
      recipeName = widget.recipe!.getRecipeName();
      categories = widget.recipe!.getCategories();
      portionSize = widget.recipe!.getPortionSize().toString();
      ingredients = widget.recipe!.getIngredients().map((Ingredient i) => i).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              MultiSelectItem<String>("dinner", "dinner"),
              MultiSelectItem<String>("dessert", "dessert"),
            ],
            initialValue: categories,
            title: const Text("Meal type * (e.g. breakfast, lunch, ...)"),
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
                labelText: "How many people does this recipe serve? *",
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
                Text(
                  "Ingredients: *",
                  style: TextStyle(color: ingColor)
                ),
                InsertIngredients(ingredients, editIngredientTile, listOfInactiveIngredientTiles),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {});
                    if (editIngredientTile == null) {
                      _ingredientKey.currentState?.reset();
                      editIngredientTile = EditIngredientTile(widget.existingIngredients);
                    }
                  },
                  child: const Text("Add ingredient"),
                ),
              ],
            )
          ),
          ElevatedButton(
            onPressed: () async {
              if (ingredients.isEmpty) {
                setState(() {
                  ingColor = Colors.red;
                });
              }
              else if (_key.currentState!.validate() && editIngredientTile == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Saving..."))
                );
                // delete old recipe from recipe book, if exists
                Recipe oldRecipe = widget.recipe ?? Recipe("", 0, [], []);
                widget.userData.getRecipeBook().removeRecipe(oldRecipe);
                // add new recipe to recipe book
                Recipe newRecipe = Recipe(recipeName, int.parse(portionSize), ingredients, categories);
                widget.userData.getRecipeBook().addRecipe(newRecipe);
                await widget.userData.saveUserData();
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(existingIngredients: widget.existingIngredients, userData: widget.userData, pageCount: 0)));
              }
            },
            child: const Text("OK")
          ),
          ElevatedButton(
              onPressed: () async {
                // navigate back
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(existingIngredients: widget.existingIngredients, userData: widget.userData, pageCount: 0)));
              },
              child: const Text("CANCEL")
          ),
      ],
    ));
  }

  Widget EditIngredientTile(List<Ingredient> existingIngredients) {
    List<String> units = ['grams', 'ml', 'pieces', 'slices', 'whole', 'tbsp', 'tsp', 'block'];
    List<String> existingIngredientNames = [];
    existingIngredientNames.addAll(existingIngredients.map((Ingredient i) {
      return i.getIngredientTag();
    }));


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
                width: 140,
                height: 80,
                child: DropdownSearch<String>(
                  popupProps: const PopupProps.menu(
                    searchDelay: Duration(seconds: 0),
                    fit: FlexFit.loose,
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      autofocus: true
                    ),
                  ),
                  selectedItem: selectedIngredient,
                  validator: (name) {
                    if (name == null) return "Required *";
                    ingredientName = name.toString();
                    return null;
                  },
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Select...",
                      hintText: "Select...",
                    ),
                  ),
                  items: existingIngredientNames.map<String>((String value) {
                    return value;
                  }).toList(),
                  onChanged: (value) => {selectedIngredient = value.toString()},
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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    editIngredientTile = null;
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete)
              ),
              IconButton(
                  onPressed: () {
                    setState(() {});
                    if (_ingredientKey.currentState!.validate()) {
                      if (editIngredientTile != null) {
                        Ingredient i = IngredientBuilder().withIngredientTag(ingredientName).withAmount(int.parse(ingredientAmount), ingredientUnit).build();
                        ingredients.add(i);
                      }
                      _ingredientKey.currentState?.reset();
                      editIngredientTile = null; //EditIngredientTile();
                    }
                  },
                  icon: const Icon(Icons.check_circle)
              ),
            ],
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
          IngredientTile(i.getIngredientTag(), i.getQuantity().toString(), i.getUnit()),
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