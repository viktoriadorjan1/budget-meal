import 'package:flutter/material.dart';
import '../RecipeBook/RecipeBookModel.dart';
import 'MealplanModel.dart';

Widget Schedule(RecipeBook recipeBook) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            generateMealPlan(recipeBook);
          },
          child: const Text("Generate meal plan"),
        )
      ],
    ),
  );
}