import 'package:flutter/material.dart';
import '../UserData/UserData.dart';
import 'MealplanModel.dart';

class Schedule extends StatefulWidget {
  final UserData userData;
  const Schedule({super.key, required this.userData});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  String results = "results";
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
          Text(results)
        ],
      )]),
    );
  }
}