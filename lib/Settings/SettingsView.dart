import 'dart:io';

import 'package:budget_meal/UserData/UserData.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../RecipeBook/IngredientModel.dart';
import '../main.dart';

Widget More(UserData userData, existingIngredients, BuildContext context) {
  Fats? fats = userData.getNutritionalInformation()?.getFats();
  Saturates? saturates = userData.getNutritionalInformation()?.getSaturates();
  Carbs? carbs = userData.getNutritionalInformation()?.getCarbs();
  Sugars? sugars = userData.getNutritionalInformation()?.getSugars();
  Protein? protein = userData.getNutritionalInformation()?.getProtein();
  Salt? salt = userData.getNutritionalInformation()?.getSalt();

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Username: ${userData.getUsername()}"),
        Text("Sex: ${userData.getSex()}"),
        Text("Age: ${userData.getAge()}"),
        Text("Height: ${userData.getHeight()}"),
        Text("Weight: ${userData.getWeight()}"),
        Text("Activity level: ${userData.getActivityLevel()}"),
        Text("Daily calorie goals: ${userData.getDailyCalories()}"),
        const Text("Daily nutritional targets: "),
        Text("Fats: ${fats?.getLowerLimit()}g - ${fats?.getUpperLimit()}g"),
        Text("Saturates: ${saturates?.getLowerLimit()}g - ${saturates?.getUpperLimit()}g"),
        Text("Carbs: ${carbs?.getLowerLimit()}g - ${carbs?.getUpperLimit()}g"),
        Text("Sugars: ${sugars?.getLowerLimit()}g - ${sugars?.getUpperLimit()}g"),
        Text("Protein: ${protein?.getLowerLimit()}g - ${protein?.getUpperLimit()}g"),
        Text("Salt: ${salt?.getLowerLimit()}g - ${salt?.getUpperLimit()}g"),
        ElevatedButton(
          onPressed: () async {
            final directory = await getApplicationDocumentsDirectory();
            final path = directory.path;
            final userDataFile = File('$path/userData.txt');

            await userDataFile.delete();
            userData = UserData();

            Navigator.push(context, MaterialPageRoute(builder: (context) => SetupPage(userData, existingIngredients: existingIngredients,),));
          },
          child: const Text("Delete user profile!!"),
        )
      ],
    ),
  );
}