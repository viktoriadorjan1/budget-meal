class RequiredNutrients {
  List<NutrientNeeded> nutrientsNeeded = [
    NutrientNeeded("fat", 44, 78),
    NutrientNeeded("saturates", 0, 20),
    NutrientNeeded("carbohydrates", 225, 325),
    NutrientNeeded("sugars", 0, 24),
    NutrientNeeded("fibre", 21, 25),
    NutrientNeeded("protein", 46, 56),
    NutrientNeeded("salt", 0, 5),
  ];
}

class NutrientNeeded {
  String nutrientName = "";
  double min = 0;
  double max = 0;

  NutrientNeeded(this.nutrientName, this.min, this.max);
}