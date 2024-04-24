import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
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

  // New recipe properties
  String recipeName = "";
  String category = "";
  int portionSize = 0;
  List<Ingredient> ingredients = [];

  // TODO: replace with pre-defined ingredients
  List<Ingredient> ingredientOptions = [];

  Ingredient milk = IngredientBuilder().withIngredientName("milk").withAmount(300, 'ml').build();
  Ingredient cerealFlakes = IngredientBuilder().withIngredientName("cereal flakes").withAmount(300, 'g').build();
  Ingredient bread = IngredientBuilder().withIngredientName("bread").withAmount(1000, 'g').build();

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
          MultiSelectDropDown(
            onOptionSelected: (options) {
              for (var element in options) {
                for (Ingredient i in ingredientOptions) {
                  if (i.getIngredientName() == element.label && !ingredients.contains(i)) {
                    ingredients.add(i);
                  }
                }
              }
            },
            options: const <ValueItem>[
              ValueItem(label: 'milk', value: '1'),
              ValueItem(label: 'cereal flakes', value: '2'),
              ValueItem(label: 'bread', value: '3'),
            ],
          ),
        ElevatedButton(onPressed: () {
          if (_key.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Saving..."))
            );
            Recipe newRecipe = Recipe(recipeName, portionSize, ingredients, false, category);
            widget.recipeBook.addRecipe(newRecipe);
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(recipeBook: widget.recipeBook)));
          }
        }, child: const Text("OK")),
      ],
    ));
  }
}