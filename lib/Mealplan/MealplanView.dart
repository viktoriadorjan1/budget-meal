import 'package:flutter/material.dart';
import '../UserData/UserData.dart';
import 'MealplanModel.dart';

Widget Schedule(UserData userData) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            generateMealPlan(userData);
          },
          child: const Text("Generate meal plan"),
        )
      ],
    ),
  );
}