import 'dart:convert';

import 'package:budget_meal/RecipeBook/IngredientModel.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../RecipeBook/RecipeBookModel.dart';
import '../ShoppingList/ShoppingListModel.dart';
import '../UserData/UserData.dart';
import '../ViewElements.dart';
import '../main.dart';
import 'MealPlanModel.dart';
import 'MealplannerModel.dart';

class NewMealPlanPage extends StatefulWidget {
  MealPlan? plan;
  final UserData userData;
  final List<Ingredient> existingIngredients;

  NewMealPlanPage({super.key, required this.userData, required this.existingIngredients, this.plan});

  @override
  State<NewMealPlanPage> createState() => _NewMealPlanPageState();
}

class _NewMealPlanPageState extends State<NewMealPlanPage> {
  final _key = GlobalKey<FormState>();

  String? results;
  String? mealPlan;
  String title = "New meal plan";

  List<String> days = [];
  List<dynamic> selected_meals = [];

  DateTime? startDate;
  DateTime? endDate;
  Color mealTimeColor = Colors.black;
  String mealPlanText = "Select start - Select end";

  @override
  Widget build(BuildContext context) {
    if (widget.plan != null && results == null) {
      startDate = widget.plan?.startDate;
      endDate = widget.plan?.endDate;
      results = jsonEncode(widget.plan!.plan);
      title = "Edit meal plan";
      mealPlanText = "${startDate.toString().split(' ')[0]} - ${endDate.toString().split(' ')[0]}";
      selected_meals = widget.plan!.getMeals();

      DateTime currentDate = startDate!;
      while (currentDate.isBefore(endDate!) || currentDate == endDate) {
        String c = currentDate.toString().split(' ')[0];
        if (!days.contains(c)) {
          days.add(c);
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }

    List<String> mealOptions = [];

    for (Recipe r in widget.userData.getRecipeBook().getRecipes()) {
      for (String type in r.getCategories()) {
        if (!mealOptions.contains(type)) {
          mealOptions.add(type);
        }
      }
    }

    selected_meals.removeWhere((category) => !mealOptions.contains(category));

      return PopScope(
          canPop: false,
          child: Scaffold(
              backgroundColor: const Color(0xFFCFCFCF),
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 50),
                    TitleBar(title),
                    Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(8),
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(existingIngredients: widget.existingIngredients, userData: widget.userData, pageCount: 2)));
                                      },
                                      child: const Text("Cancel")
                                  ),
                                  Form(
                                    key: _key,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Select meal plan times: *",
                                          style: TextStyle(
                                              color: mealTimeColor
                                          ),
                                        ),
                                        OutlinedButton(
                                            onPressed: () async {
                                              final picked = await showDateRangePicker(
                                                initialDateRange: DateTimeRange(
                                                    start: startDate ?? DateTime.now(),
                                                    end: endDate ?? DateTime.now().add(const Duration(days: 6))
                                                ),
                                                context: context,
                                                lastDate: DateTime.now().add(const Duration(days: 365)),
                                                firstDate: DateTime(2018)
                                              );
                                              if (picked != null) {
                                                setState(() {
                                                  // Date has changed. Deleting invalid results...
                                                  //widget.plan = null;
                                                  results = "{}";
                                                  mealPlan = "";

                                                  startDate = picked.start;
                                                  endDate = picked.end;

                                                  mealPlanText = "${startDate.toString().split(' ')[0]} - ${endDate.toString().split(' ')[0]}";
                                                  mealTimeColor = Colors.black;
                                                });
                                              }
                                            },
                                            child: SizedBox(
                                              width: getScreenWidth() * 0.6,
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.arrow_back_ios),
                                                    Text(mealPlanText),
                                                    //Text("${startDate.toString().split(' ')[0]} - ${endDate.toString().split(' ')[0]}"),
                                                    const Icon(Icons.arrow_forward_ios)
                                                  ]
                                              ),
                                            )
                                        ),
                                        MultiSelectChipField(
                                          searchable: true,
                                          items: getMealSelectionItems(mealOptions),
                                          initialValue: selected_meals,
                                          title: const Text("Select meals to schedule *"),
                                          onTap: (values) {
                                            setState(() {
                                              // Meals have changed. Deleting invalid results...
                                              //widget.plan = null;
                                              results = "{}";
                                              mealPlan = "";
                                            });
                                          },
                                          validator: (ms) {
                                            if (ms == null || ms.isEmpty) {
                                              return "Please select at least one meal to schedule";
                                            } else {
                                              selected_meals = ms;
                                              //widget.plan?.setMeals(ms);
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        results = "Generating new meal plan...";
                                      });
                                      if (startDate == null || endDate == null) {
                                        setState(() {
                                          mealTimeColor = Colors.red;
                                        });
                                      } else if (_key.currentState!.validate()) {
                                        days = [];
                                        DateTime currentDate = startDate!;
                                        while (currentDate.isBefore(endDate!)) {
                                          days.add(currentDate.toString().split(' ')[0]);
                                          currentDate = currentDate.add(const Duration(days: 1));
                                        }
                                        days.add(endDate.toString().split(' ')[0]);

                                        mealPlan = await generateMealPlan(widget.userData, days, selected_meals);
                                        setState(() {
                                          results = mealPlan;
                                        });
                                      }
                                    },
                                    child: const Text("Generate meal plan"),
                                  ),
                                  if (results != null && results != "{}") mealPlanWidget()
                                ],
                              ),
                            )
                          ],
                        )
                    ),
                  ],
                ),
              )
          )
      );
    }

  Widget mealPlanWidget() {
    Map<String, dynamic> jsonResults;

    try {
      jsonResults = jsonDecode(results!);
    } catch (e) {
      return Center(
        child: Text(results!),
      );
    }

    if (jsonResults.isEmpty) {
      return const Center();
    }

    ShoppingList shoppingList = generateShoppingList(jsonResults);

    return Center(
      child: Column(
        children: createDayTiles(days, jsonResults) + [
          ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Saving..."))
                );
                // SAVING MEAL PLAN
                // delete old meal plan from collection, if exists
                MealPlan oldPlan = widget.plan ?? MealPlan(DateTime.now(), DateTime.now(), {}, []);
                widget.userData.getMealPlanCollection().removeMealPlan(oldPlan);
                // add new meal plan to the collection
                MealPlan newPlan = MealPlan(DateTime.parse(days.first), DateTime.parse(days.last), jsonResults, selected_meals);
                widget.userData.getMealPlanCollection().addMealPlan(newPlan);

                // SAVING SHOPPING LIST
                // replace (or create) shopping list
                widget.userData.setShoppingList(shoppingList);

                // SAVING...
                await widget.userData.saveUserData();

                // navigate back to meal plan list
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(existingIngredients: widget.existingIngredients, userData: widget.userData, pageCount: 2)));
                },
              child: const Text("ACCEPT")
          )
        ]
      ),
    );
  }

  List<Widget> createDayTiles(List<String> days, Map<String, dynamic> results) {
    List<Widget> dayTileList = <Widget>[];

    //Map<String, dynamic> schedules = jsonDecode(results["schedule"]);
    List<dynamic> schedules = results["schedule"];

    /*schedules.forEach((key, value) {
      String day = key;
      print("$key : $value");
      List<Widget> mealTileList = <Widget>[];
      //for (dynamic v in value) {
      //  print(v);
      //}

      //Widget mealTile = DaySchedule(meal: meal, recipeName: recipe, userData: widget.userData);
      //mealTileList.add(mealTile);
    });*/

    for (String day in days) {
      List<Widget> mealTileList = <Widget>[];
      for (List<dynamic> schedule in schedules) {
        // if this schedule(recipe, day, meal) has correct day
        if (schedule[1] == day) {
          String recipe = schedule[0];
          //String day = schedule[1];
          String meal = schedule[2];

          Widget mealTile = DaySchedule(meal: meal, recipeName: recipe, userData: widget.userData);
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

  Widget dayName(String dayName) {
    return Text(
      dayName,
      style: const TextStyle(color: Color(0xFF26BDC6), fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  /*
  Widget daySchedule(String meal, String recipe) {
    IconData iconData = Icons.circle_outlined;
    return Row(
        children: [
          Text(meal),
          const Text(" : "),
          Text(recipe),
          IconButton(
              onPressed: () {
                if (iconData == Icons.circle_outlined) {
                  setState(() {
                    iconData = Icons.check_circle_outline;
                  });
                } else {
                  setState(() {
                    iconData = Icons.circle_outlined;
                  });
                }
              },
              icon: Icon(iconData)
          )
        ]
    );
  }
  */

  getMealSelectionItems(mealOptions) {
    List<MultiSelectItem> items = [];
    mealOptions.forEach((String mealOption) {
      items.add(MultiSelectItem<String>(mealOption, mealOption));
    });
    return items;
  }

  ShoppingList generateShoppingList(Map<String, dynamic> jsonResults) {
    if (jsonResults["buy"] == null) {
      return ShoppingList();
    }

    //Map<String, dynamic> buyList = jsonDecode(jsonResults["buy"]);

    List<dynamic> buyList = jsonResults["buy"];
    List<dynamic> webItemsList = jsonResults["i_costs"];
    List<dynamic> unitMapList = jsonResults["i_unit"];

    ShoppingList shoppingList = ShoppingList();
    /*buyList.forEach((key, value) {
      String ingredientTag = key;
      int amount = value["amount"];
      String category = value["category"];
      String ingredientName = value["ingredientName"];
      int price = value["price"];
      String recipeName = value["recipe"];
      String storeName = value["store"];
      int weight = value["weight"];
      // TODO: unit
      print("$key : $value");
      NutritionalInformation n = NutritionalInformation(Fats(0,0), Saturates(0,0), Carbs(0,0), Sugars(0,0), Protein(0,0), Salt(0,0));
      ShoppingListItem item = ShoppingListItem(recipeName, ingredientTag, amount, storeName, price, ingredientName, weight, "g", category, n, false);
      shoppingList.addItem(item);
    });*/

    for (List<dynamic> buyItem in buyList) {
      String recipeName = buyItem[0];
      String ingredientTag = buyItem[1];
      int amount = int.parse(buyItem[2]);
      String storeName = buyItem[3];
      String ingredientName = buyItem[4];
      int price = int.parse(buyItem[5]);

      int quantity = 0;
      for (List<dynamic> webItem in webItemsList) {
        if (webItem[1] == ingredientName) {
          quantity = int.parse(webItem[3]);
          break;
        }
      }

      String unit = "ERROR";
      for (List<dynamic> unitMap in unitMapList) {
        if (unitMap[0] == ingredientName) {
          unit = unitMap[1];
          break;
        }
      }

      // TODO: category, nutrition
      String category = "vegetables";
      NutritionalInformation n = NutritionalInformation(Fats(0,0), Saturates(0,0), Carbs(0,0), Sugars(0,0), Protein(0,0), Salt(0,0));
      ShoppingListItem item = ShoppingListItem(recipeName, ingredientTag, amount, "Aldi", price, ingredientName, quantity, unit, category, n, false);
      shoppingList.addItem(item);
    }

    return shoppingList;

  }
}

class DaySchedule extends StatefulWidget {
  final UserData userData;
  final String meal;
  final String recipeName;
  //final bool isChecked;

  const DaySchedule({super.key, required this.meal, required this.recipeName, required this.userData});

  @override
  State<DaySchedule> createState() => _DayScheduleState();
}

class _DayScheduleState extends State<DaySchedule> {
  IconData iconData = Icons.circle_outlined;
  List<Ingredient> usedIngredients = [];

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Text(widget.meal),
          const Text(" : "),
          Text(widget.recipeName),
          IconButton(
              onPressed: () {
                if (iconData == Icons.circle_outlined) {
                  // if it was unchecked, now checked.
                  setState(() {
                    iconData = Icons.check_circle_outline;
                  });
                  // use ingredients from pantry.
                  for (Ingredient i in widget.userData.getRecipeBook().getRecipe(widget.recipeName)!.getIngredients()) {
                    // TODO: handle case when not all ingredients are present anymore i.e. recipe cooking should be atomic
                    // TODO: consider serving size
                    try {
                      Ingredient used = widget.userData.getPantry().useGenericFromPantry(i.getIngredientTag(), i.getQuantity(), i.getUnit());
                      used.updateQuantity(i.getQuantity());
                      usedIngredients.add(used);
                    } catch (e) {
                      // Pantry does not contain this ingredient");
                    }

                  }
                } else {
                  setState(() {
                    iconData = Icons.circle_outlined;
                  });
                  // put ingredients back to pantry.
                  for (Ingredient i in usedIngredients) {
                    // TODO: consider serving size
                    // TODO: categories
                    widget.userData.getPantry().putInPantry(i);
                  }
                }
                //widget.userData.saveUserData();
              },
              icon: Icon(iconData)
          )
        ]
    );
  }

}