enum MealPlanStatus {
  current,
  past,
  upcoming
}

String mealPlanStatusToString(MealPlanStatus status) {
  switch(status) {
    case MealPlanStatus.past: return "past";
    case MealPlanStatus.upcoming: return "upcoming";
    case MealPlanStatus.current: return "current";
  }
}

class MealPlan {
  String? name;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> plan;
  MealPlanStatus status = MealPlanStatus.past;
  List<dynamic> _meals;

  MealPlan(this.startDate, this.endDate, this.plan, this._meals, {String? name}) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (today.isBefore(startDate)) {
      status = MealPlanStatus.upcoming;
    } else if (today.isAfter(endDate)){
      status = MealPlanStatus.past;
    } else {
      status = MealPlanStatus.current;
    }

    this.name = "${startDate.toString().split(' ')[0]} - ${endDate.toString().split(' ')[0]}";
  }

  List<dynamic> getMeals() {
    return _meals;
  }

  void setMeals(List<dynamic> ms) {
    _meals = ms;
  }
}