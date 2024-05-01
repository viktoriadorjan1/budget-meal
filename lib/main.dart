import 'package:flutter/material.dart';

import 'IngredientCatalog/IngredientCatalogModel.dart';
import 'Pantry/PantryModel.dart';
import 'RecipeBook/RecipeBookModel.dart';
import 'RecipeBook/RecipeBookView.dart';
import 'Pantry/PantryView.dart';
import 'UserData/UserData.dart';
import 'ViewElements.dart';
import 'WebStore/ShoppingList.dart';
import 'Settings/SettingsView.dart';
import 'Mealplan/MealplanView.dart';

Future<void> main() async {
  IngredientCatalog ingredientCatalog = IngredientCatalog();
  await ingredientCatalog.create();
  List<String> existingIngredients = ingredientCatalog.getAllIngredientNames();

  WidgetsFlutterBinding.ensureInitialized();

  UserData userData = UserData();
  bool userExists = await userData.init();

  print("Finished loading. Running app...");
  runApp(MyApp(recipeBook: userData.getRecipeBook(), pantry: userData.getPantry(), existingIngredients: existingIngredients, userExists: userExists, userData: userData));
}

class MyApp extends StatelessWidget {
  final List<String> existingIngredients;

  final bool userExists;
  final UserData userData;

  const MyApp({required this.recipeBook, super.key, required this.pantry, required this.existingIngredients, required this.userExists, required this.userData, });
  final RecipeBook recipeBook;
  final Pantry pantry;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    if (userExists) {
      // User exists, carry on with loaded data.
      return MaterialApp(
        home: MyHomePage(recipeBook: recipeBook, pantry: pantry, existingIngredients: existingIngredients, userData: userData),
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
  UserData userData;
  final List<String> existingIngredients;


  SetupPage(this.userData, {super.key, required this.existingIngredients});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage>{
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
            backgroundColor: const Color(0xFFCFCFCF),
            body: Center(
              child: Column(
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
                        ElevatedButton(
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                // TODO: replace with calculation for calories
                                widget.userData.setSex("male");
                                widget.userData.setActivityLevel("low");
                                widget.userData.setDailyCalories(2000);

                                await widget.userData.saveUserData();

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Saving..."))
                                );
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(recipeBook: RecipeBook(), pantry: Pantry(), existingIngredients: widget.existingIngredients, userData: widget.userData,)));
                              }
                            },
                            child: const Text("OK")
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        )
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<String> existingIngredients;
  const MyHomePage({required this.recipeBook, super.key, required this.pantry, required this.existingIngredients, required this.userData});
  final RecipeBook recipeBook;
  final Pantry pantry;
  final UserData userData;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List _pages = [
      RecipeBookView(recipeBook: widget.recipeBook, pantry: widget.pantry, existingIngredients: widget.existingIngredients, userData: widget.userData,),
      PantryView(widget.pantry, widget.userData),
      Schedule(widget.pantry, widget.recipeBook),
      Shopping(),
      More(widget.userData, widget.existingIngredients, context)
    ];

    return PopScope(
        canPop: false,
    child: Scaffold(
      backgroundColor: const Color(0xFFCFCFCF),
      body: _pages[_currentIndex],
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
      currentIndex: _currentIndex,
      selectedItemColor: Colors.white,
      onTap: (index) => setState(() {
        _currentIndex = index;
      }),
    )));
  }
}

