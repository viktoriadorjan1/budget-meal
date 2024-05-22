import 'package:budget_meal/Mealplan/MealPlanModel.dart';
import 'package:budget_meal/RecipeBook/IngredientModel.dart';
import 'package:flutter/material.dart';
import '../UserData/UserData.dart';
import '../ViewElements.dart';
import '../main.dart';
import 'NewMealPlanView.dart';

class Schedule extends StatefulWidget {
  final UserData userData;
  final List<Ingredient> existingIngredients;
  const Schedule({super.key, required this.userData, required this.existingIngredients});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 50),
          TitleBar("Meal plan"),
          Expanded(
            child: ListView(
                children: [
                  Center(
                    child: Column(
                        children: <Widget>[const Text("Current meal plan")] +
                            selectMealPlanWidgetList(MealPlanStatus.current) +
                          [const Text("Upcoming meal plans")] +
                          selectMealPlanWidgetList(MealPlanStatus.upcoming) +
                          [const Text("Previous meal plans")] +
                            selectMealPlanWidgetList(MealPlanStatus.past) +
                          [IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded),
                            color: const Color(0xFF26BDC6),
                            iconSize: 45,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewMealPlanPage(existingIngredients: widget.existingIngredients,userData: widget.userData)));
                            },
                          )]
                    ),
                  ),
                ]),
          )
        ],
      )
    );
  }

  List<Widget> selectMealPlanWidgetList(MealPlanStatus status) {
    List<Widget> mealPlanTiles = [];
    widget.userData.getMealPlanCollection().getMealPlansByStatus(status).forEach((p) {
      var mealPlanTile = PopupMenuButton<int>(
          initialValue: null,
          color: const Color(0xFFF3F9F6),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              onTap: () async {
                widget.userData.getMealPlanCollection().removeMealPlan(p);
                await widget.userData.saveUserData();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MyHomePage(existingIngredients: widget.existingIngredients, userData: widget.userData, pageCount: 2)));
              },
              value: 0,
              child: const Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delete"),
                    Icon(Icons.delete)
                  ]
              ),
            ),
            PopupMenuItem(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => NewMealPlanPage(plan: p, userData: widget.userData, existingIngredients: widget.existingIngredients)));
              },
              value: 1,
              child: const Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Edit"),
                    Icon(Icons.edit)
                  ]
              ),
            ),
          ],
          child: MyListTile(title: p.name.toString())
        //Text(title, style: const TextStyle(color: Color(0xFF26BDC6), fontWeight: FontWeight.bold, fontSize: 18))
      );
      mealPlanTiles.add(mealPlanTile);
    });

    if (mealPlanTiles.isEmpty) {
      return [Text("There are no ${mealPlanStatusToString(status)} meal plans.")];
    }
    return mealPlanTiles;
  }
}