import 'dart:convert';

import 'MealPlanModel.dart';

class MealPlanCollection {
  final List<MealPlan> _mealPlansList = [];

  MealPlanCollection();

  void addMealPlan(MealPlan mealPlan) {
    _mealPlansList.add(mealPlan);
  }

  void removeMealPlan(MealPlan mealPlan) {
    _mealPlansList.remove(mealPlan);
  }

  List<MealPlan> getMealPlans() {
    return _mealPlansList;
  }

  List<MealPlan> getMealPlansByStatus(MealPlanStatus status) {
    List<MealPlan> plans = [];
    for (MealPlan mealPlan in _mealPlansList) {
      if (mealPlan.status == status) {
        plans.add(mealPlan);
      }
    }
    return plans;
  }

  String toJson() {
    Map<String, dynamic> generateJson() => {
      for (MealPlan plan in _mealPlansList) plan.name.toString() : {
        "start": plan.startDate.toString(),
        "end": plan.endDate.toString(),
        "meals": plan.getMeals(),
        "plan" : plan.plan
      }
    };
    return jsonEncode(generateJson());
  }

}