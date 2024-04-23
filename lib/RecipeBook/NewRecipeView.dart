import 'package:flutter/material.dart';
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
      appBar: AppBar(),
        backgroundColor: const Color(0xFFCFCFCF),
        body: Column(
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

List<String> ingredientNames = <String>['Eggs', 'Cheese', 'Milk'];

class _NewRecipeFormState extends State<NewRecipeForm> {
  final _key = GlobalKey<FormState>();

  String recipeName = "";
  String category = "";
  int portionSize = 0;
  List<Ingredient> ingredients = [];


  String dropdownval = ingredientNames.first;

  @override
  Widget build(BuildContext context) {
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
        DropdownButton<String>(
          value: dropdownval,
          items: ingredientNames.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              dropdownval = value!;
            });
        }),
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