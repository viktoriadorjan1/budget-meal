import 'dart:io';

import 'package:budget_meal/UserData/UserData.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';

Widget More(UserData userData, existingIngredients, BuildContext context) {
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