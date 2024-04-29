import 'package:flutter/material.dart';
import '../Pantry/PantryModel.dart';
import '../RecipeBook/RecipeBookModel.dart';
import 'MealplanModel.dart';

Widget Schedule(Pantry pantry, RecipeBook recipeBook) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            generateMealPlan(pantry, recipeBook);
          },
          child: const Text("Generate meal plan"),
        )
      ],
    ),
  );
}