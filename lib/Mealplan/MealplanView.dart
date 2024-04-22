import 'package:flutter/material.dart';
import 'MealplanModel.dart';

Widget Schedule() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            generateMealPlan();
          },
          child: const Text("Generate meal plan"),
        )
      ],
    ),
  );
}