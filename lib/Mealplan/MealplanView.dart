import 'dart:convert';

import 'package:flutter/material.dart';
import '../UserData/UserData.dart';
import '../ViewElements.dart';
import 'MealplanModel.dart';

class Schedule extends StatefulWidget {
  final UserData userData;
  Schedule({super.key, required this.userData});

  final List<String> days = ["monday", "tuesday", "wednesday"];

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  String results = "{}";
  String mealPlan = "";

  @override
  Widget build(BuildContext context) {

    return Center(
      child: ListView(children: [Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              mealPlan = await generateMealPlan(widget.userData);
              setState(() {
                results = mealPlan;
              });
            },
            child: const Text("Generate meal plan"),
          ),
          MealPlanWidget(widget.days, jsonDecode(results)),
          //Text(results)
        ],
      )]),
    );
  }

  Widget MealPlanWidget(List<String> days, Map<String, dynamic> results) {

    if (results.isEmpty) {
      return const Center();
    }

    return Center(
      child: Column(
        children: createDayTiles(days, results),
      ),
    );
  }

  Widget dayName(String dayName) {
    return Text(
      dayName,
      style: const TextStyle(color: Color(0xFF26BDC6), fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget daySchedule(String meal, String recipe) {
    return Row(
      children: [
        Text(meal),
        const Text(" : "),
        Text(recipe)
      ]
    );
  }

  List<Widget> createDayTiles(List<String> days, Map<String, dynamic> results) {
    List<Widget> dayTileList = <Widget>[];

    List<dynamic> schedules = results["schedule"];

    for (String day in days) {
      print(day);
      List<Widget> mealTileList = <Widget>[];
      for (List<dynamic> schedule in schedules) {
        //print("Looking at $day for schedule(${schedule[0]}, ${schedule[1]}, ${schedule[2]})");
        // if this schedule(recipe, day, meal) has correct day
        if (schedule[1] == day) {
          //print("SUCCESS");
          String recipe = schedule[0];
          //String day = schedule[1];
          String meal = schedule[2];

          Widget mealTile = daySchedule(meal, recipe);
          mealTileList.add(mealTile);
        }
      }
      if (mealTileList.isNotEmpty) {
        Widget dayTile = Column(
          children: [dayName(day)] + mealTileList,
        );
        dayTileList.add(dayTile);
      }
    }

    return dayTileList;
  }
}