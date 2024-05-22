import 'package:flutter/material.dart';

import 'IngredientCatalog/IngredientCatalogModel.dart';
import 'RecipeBook/IngredientModel.dart';
import 'RecipeBook/RecipeBookView.dart';
import 'Pantry/PantryView.dart';
import 'UserData/UserData.dart';
import 'ViewElements.dart';
import 'ShoppingList/ShoppingListView.dart';
import 'Settings/SettingsView.dart';
import 'Mealplan/MealplanCollectionView.dart';

Future<void> main() async {
  IngredientCatalog ingredientCatalog = IngredientCatalog();
  //await ingredientCatalog.create();
  ingredientCatalog.create();
  List<Ingredient> existingIngredients = ingredientCatalog.getAllIngredients();

  WidgetsFlutterBinding.ensureInitialized();

  UserData userData = UserData();
  bool userExists = await userData.init();

  print("Finished loading. Running app...");
  runApp(MyApp(existingIngredients: existingIngredients, userExists: userExists, userData: userData));
}

class MyApp extends StatelessWidget {
  final List<Ingredient> existingIngredients;

  final bool userExists;
  final UserData userData;

  const MyApp({required this.existingIngredients, required this.userExists, required this.userData});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    if (userExists) {
      // User exists, carry on with loaded data.
      return MaterialApp(
        home: MyHomePage(existingIngredients: existingIngredients, userData: userData, pageCount: 2),
      );
    }
    else {
      // New user, needs setup!
      return MaterialApp(
        home: SetupPage(userData, existingIngredients: existingIngredients,),
      );
    }
  }
}

class SetupPage extends StatefulWidget {
  final UserData userData;
  final List<Ingredient> existingIngredients;


  const SetupPage(this.userData, {super.key, required this.existingIngredients});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage>{
  final _key = GlobalKey<FormState>();

  String _sex = "";
  String _activityLevel = "";

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
            backgroundColor: const Color(0xFFCFCFCF),
            body: Center(
              child: ListView(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 50),
                    TitleBar("Before you get started..."),
                    Form(
                      key: _key,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: "",
                            decoration: const InputDecoration(
                                labelText: "Username *"
                            ),
                            validator: (n) {
                              if (n == null || n.isEmpty) return "Please enter a username";
                              widget.userData.setUsername(n);
                              return null;
                            },
                          ),
                          const Text("Sex *"),
                          Wrap(
                            children: [
                              ChoiceChip(
                                  label: const Text("Male"),
                                  selected: _sex == "Male",
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _sex = (selected ? "Male" : "");
                                    });
                                  },
                              ),
                              ChoiceChip(
                                label: const Text("Female"),
                                selected: _sex == "Female",
                                onSelected: (bool selected) {
                                  setState(() {
                                    _sex = (selected ? "Female" : "");
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: const Text("Non-Binary"),
                                selected: _sex == "Non-Binary",
                                onSelected: (bool selected) {
                                  setState(() {
                                    _sex = selected ? "Non-Binary" : "";
                                  });
                                },
                              )
                            ],
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: "",
                            decoration: const InputDecoration(
                                labelText: "Age *"
                            ),
                            validator: (a) {
                              if (a == null || a.isEmpty) return "Please enter your age";
                              widget.userData.setAge(int.parse(a));
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: "",
                            decoration: const InputDecoration(
                                labelText: "Height (cm) *"
                            ),
                            validator: (h) {
                              if (h == null || h.isEmpty) return "Please enter your height in centimeters";
                              widget.userData.setHeight(int.parse(h));
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: "",
                            decoration: const InputDecoration(
                                labelText: "Weight (kg) *"
                            ),
                            validator: (w) {
                              if (w == null || w.isEmpty) return "Please enter your weight in kilograms";
                              widget.userData.setWeight(int.parse(w));
                              return null;
                            },
                          ),
                          const Text("Activity level *"),
                          Wrap(
                              children: [
                                ChoiceChip(
                                  label: const Text("Sedentary (little to no exercise)"),
                                  selected: _activityLevel == "Sedentary",
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _activityLevel = selected ? "Sedentary" : "";
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text("Lightly active (light exercise 1-3 days a week)"),
                                  selected: _activityLevel == "Lightly active",
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _activityLevel = selected ? "Lightly active" : "";
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text("Moderately active (light to moderate exercise 4-5 days a week)"),
                                  selected: _activityLevel == "Moderately active",
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _activityLevel = selected ? "Moderately active" : "";
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text("Active (moderate exercise 6-7 days a week or intense exercise 3-4 days a week)"),
                                  selected: _activityLevel == "Active",
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _activityLevel = selected ? "Active" : "";
                                    });
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text("Very active (intense exercise 6-7 days a week, sports training, or physical job)"),
                                  selected: _activityLevel == "Very active",
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _activityLevel = selected ? "Very active" : "";
                                    });
                                  },
                                ),

                              ]
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (_key.currentState!.validate() && _sex != "" && _activityLevel != "") {
                                  // TODO: replace with calculation for calories
                                  widget.userData.setSex(_sex);
                                  widget.userData.setActivityLevel(_activityLevel);

                                  // calculate daily calories
                                  double calories = 10 * widget.userData.getWeight() + 6.25 * widget.userData.getHeight() - 5 * widget.userData.getAge();
                                  double femaleCals = calories - 161;
                                  double maleCals = calories + 5;
                                  if (_sex == "Female") {
                                    widget.userData.setDailyCalories(femaleCals.round());
                                  } else if (_sex == "Male") {
                                    widget.userData.setDailyCalories(maleCals.round());
                                  } else {
                                    widget.userData.setDailyCalories(((femaleCals + maleCals) / 2).round());
                                  }

                                  // calculate required nutritional information in grams
                                  // fats: 20-35% of daily calories. 9 calories = 1g fat
                                  int fatLower = (widget.userData.getDailyCalories() * 0.2 / 9).round();
                                  int fatUpper = (widget.userData.getDailyCalories() * 0.35 / 9).round();

                                  Fats fats = Fats(fatLower, fatUpper);

                                  int saturatedFat = (widget.userData.getDailyCalories() * 0.1 / 9).round();

                                  Saturates saturates = Saturates(0, saturatedFat);

                                  // carbs: 45-65% of daily calories. 4 calories = 1g carb
                                  int carbsLower = (widget.userData.getDailyCalories() * 0.45 / 4).round();
                                  int carbsUpper = (widget.userData.getDailyCalories() * 0.65 / 4).round();

                                  Carbs carbs = Carbs(carbsLower, carbsUpper);

                                  // sugars: 36g for men, 25g for women
                                  int sugarsLimit = 0;
                                  if (_sex == "Male") {
                                    sugarsLimit = 36;
                                  } else if (_sex == "Female") {
                                    sugarsLimit = 25;
                                  } else {
                                    sugarsLimit = ((36 + 25) / 2).round();
                                  }

                                  Sugars sugars = Sugars(0, sugarsLimit);

                                  // protein: 10-35% of daily calories. 4 calories = 1g protein
                                  int proteinLower = (widget.userData.getDailyCalories() * 0.1 / 4).round();
                                  int proteinUpper = (widget.userData.getDailyCalories() * 0.35 / 4).round();

                                  Protein protein = Protein(proteinLower, proteinUpper);

                                  // salt: 6g
                                  Salt salt = Salt(0, 6);

                                  NutritionalInformation nutritionTargets = NutritionalInformation(fats, saturates, carbs, sugars, protein, salt);

                                  widget.userData.setNutritionalInformation(nutritionTargets);

                                  await widget.userData.saveUserData();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Saving..."))
                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(existingIngredients: widget.existingIngredients, userData: widget.userData, pageCount: 0,)));
                                }
                              },
                              child: const Text("OK")
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],)
            ),
        )
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Ingredient> existingIngredients;
  int pageCount;
  MyHomePage({super.key, required this.existingIngredients, required this.userData, required this.pageCount});
  final UserData userData;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final List _pages = [
      RecipeBookView(existingIngredients: widget.existingIngredients, userData: widget.userData,),
      PantryView(existingIngredients: widget.existingIngredients, userData: widget.userData),
      Schedule(existingIngredients: widget.existingIngredients, userData: widget.userData),
      ShoppingListPage(userData: widget.userData,),
      More(widget.userData, widget.existingIngredients, context)
    ];

    return PopScope(
        canPop: false,
    child: Scaffold(
      backgroundColor: const Color(0xFFCFCFCF),
      body: _pages[widget.pageCount],
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF26BDC6),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Recipes'),
        BottomNavigationBarItem(icon: Icon(Icons.bakery_dining_rounded), label: 'Pantry'),
        BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: 'Schedule'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'To buy'),
        BottomNavigationBarItem(icon: Icon(Icons.more_outlined), label: 'More'),
      ],
      currentIndex: widget.pageCount,
      selectedItemColor: Colors.white,
      onTap: (index) => setState(() {
        widget.pageCount = index;
      }),
    )));
  }
}
