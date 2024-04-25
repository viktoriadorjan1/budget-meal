import 'package:flutter/material.dart';
import '../ViewElements.dart';
import '../main.dart';
import 'IngredientModel.dart';
import 'RecipeBookModel.dart';

class NewRecipePage extends StatefulWidget {
  final RecipeBook recipeBook;
  const NewRecipePage({required this.recipeBook, super.key});

  @override
  State<NewRecipePage> createState() => _NewRecipePageState();
}

class _NewRecipePageState extends State<NewRecipePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New recipe")),
        backgroundColor: const Color(0xFFCFCFCF),
        body: ListView(
            children: <Widget> [
              Container(height: 50),
              NewRecipeForm(recipeBook: widget.recipeBook),
            ]),
    );
  }
}

class NewRecipeForm extends StatefulWidget {
  final RecipeBook recipeBook;
  const NewRecipeForm({required this.recipeBook, super.key});

  @override
  State<NewRecipeForm> createState() => _NewRecipeFormState();
}

class _NewRecipeFormState extends State<NewRecipeForm> {
  final _key = GlobalKey<FormState>();
  final _ingredientKey = GlobalKey<FormState>();

  // New recipe properties
  String recipeName = "";
  String category = "";
  int portionSize = 0;
  List<Ingredient> ingredients = [];

  // Inserted ingredient properties
  String ingredientName = "";
  String ingredientAmount = "";
  String ingredientUnit = "";

  // TODO: replace with pre-defined ingredients
  List<Ingredient> ingredientOptions = [];

  Ingredient milk = IngredientBuilder().withIngredientName("milk").withAmount(300, 'ml').build();
  Ingredient cerealFlakes = IngredientBuilder().withIngredientName("cereal flakes").withAmount(300, 'g').build();
  Ingredient bread = IngredientBuilder().withIngredientName("bread").withAmount(1000, 'g').build();

  List listOfInactiveIngredientTiles = [];
  Widget? editIngredientTile;

  @override
  Widget build(BuildContext context) {
    ingredientOptions.add(milk);
    ingredientOptions.add(cerealFlakes);
    ingredientOptions.add(bread);

    return Form(
      key: _key,
      child: Column(
        children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Recipe name *"
          ),
          validator: (n) {
            if (n == null || n.isEmpty) return "Please enter a name for your recipe";
            recipeName = n;
            return null;
          },
        ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Category",
            ),
            validator: (c) {
              if (c == null || c.isEmpty) {
                category = "Uncategorised";
              } else {
                category = c;
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: "Portion size *",
            ),
            validator: (size) {
              if (size == null || size.isEmpty) return "Please enter how many portions this recipe makes";
              portionSize = int.parse(size);
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
                    if (_ingredientKey.currentState!.validate()) {
                      if (editIngredientTile != null) {
                        var ing = IngredientTile(ingredientName, ingredientAmount, ingredientUnit);
                        listOfInactiveIngredientTiles.add(ing);
                      }
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
              if (_key.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Saving..."))
                );
                Recipe newRecipe = Recipe(recipeName, portionSize, ingredients, false, category);
                widget.recipeBook.addRecipe(newRecipe);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(recipeBook: widget.recipeBook)));
              }
            },
            child: const Text("OK")
          ),
      ],
    ));
  }

  Widget EditIngredientTile() {
    List<String> units = ['grams', 'milliliters', 'pieces'];

    String? selectedIngredient;
    var selectedUnit = units.first;
    return Container(
      width: getScreenWidth() * 0.9,
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
              items: ['milk', 'bread', 'cereal flakes'].map<DropdownMenuItem<String>>((String value) {
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
          const Icon(Icons.delete)
        ],),
    );
  }
}

/*class EditIngredientTile extends StatefulWidget {
  String ingredientName = "";
  String ingredientAmount = "";
  String ingredientUnit = "";

  EditIngredientTile({super.key});

  @override
  State<EditIngredientTile> createState() => _EditIngredientState();
}*/

/*class _EditIngredientState extends State<EditIngredientTile>{
  @override
  Widget build(BuildContext context) {
    List<String> units = ['grams', 'milliliters', 'pieces'];

    String? selectedIngredient;
    var selectedUnit = units.first;

    return Container(
      width: getScreenWidth() * 0.9,
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
                widget.ingredientName = name;
                return null;
              },
              hint: const Text("Select..."),
              items: ['milk', 'bread', 'cereal flakes'].map<DropdownMenuItem<String>>((String value) {
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
          const Icon(Icons.delete)
        ],),
    );
  }
}*/

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
      children: <Widget>[
        inactiveIngredientTilesList(),
        editIngredientTile(),
      ]
    );
  }

  /*List<Widget> createIngredientTiles(List<Ingredient> ingredients) {
    List<Widget> ingredientTiles = [];
    for (Ingredient i in ingredients) {
      var ingredientTile = IngredientTile(i);
      ingredientTiles.add(ingredientTile);
    }
    return ingredientTiles;
  }*/

  Widget editIngredientTile() {
    return SizedBox(
        height: 150,
        child: widget.editIngredientTile
    );
  }

  Widget inactiveIngredientTilesList() {
    return SizedBox(
        height: 150,
        child: ListView.builder(
            itemCount: widget.listOfInactiveIngredientTiles.length,
            itemBuilder: (_, index) => widget.listOfInactiveIngredientTiles[index]
        )
    );
  }
}

Widget IngredientTile(String name, String quantity, String unit) {
  return Container(
    width: getScreenWidth() * 0.9,
    padding: const EdgeInsets.all(5),
    margin: const EdgeInsets.all(5),
    color: const Color(0xFFF3F9F6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(name),
        Text("$quantity $unit"),
        const Icon(Icons.delete)
      ],),
  );
}