import 'package:budget_meal/ShoppingList/ShoppingListModel.dart';
import 'package:flutter/material.dart';
import '../UserData/UserData.dart';
import '../ViewElements.dart';

class ShoppingListPage extends StatefulWidget {
  final UserData userData;

  const ShoppingListPage({super.key, required this.userData});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  double? totalPrice;
  double saveTotalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 50),
          Row(
            children: [
              TitleBar("Shopping list"),
              Text("total price is £${getTotalPrice()}"),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                Center(
                  child: ShoppingListItemTiles(userData: widget.userData, saveTotalPrice: saveTotalPrice)
                )
              ]
            )
          )
        ],
      ),
    );
  }

  void refreshShoppingList() {
    setState(() {});
  }

  double getTotalPrice() {
    ShoppingList? savedShoppingList = widget.userData.getShoppingList() ?? ShoppingList();
    double totalPrice = 0;

    for (ShoppingListItem i in savedShoppingList.getShoppingList()) {
      totalPrice += i.getPrice();
    }

    return totalPrice / 100;
  }
}

class ShoppingListItemTiles extends StatefulWidget {
  final UserData userData;
  double saveTotalPrice;

  ShoppingListItemTiles({super.key, required this.userData, required this.saveTotalPrice});

  @override
  State<ShoppingListItemTiles> createState() => _ShoppingListItemTilesState();
}

class _ShoppingListItemTilesState extends State<ShoppingListItemTiles>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: ShoppingListItemTiles(),
    );
  }

  List<Widget> ShoppingListItemTiles() {
    ShoppingList? savedShoppingList = widget.userData.getShoppingList() ?? ShoppingList();
    List<Widget> shoppingListItemTiles = [];

    for (ShoppingListItem i in savedShoppingList.getShoppingList()) {
      var tile = ShoppingListItemTile(i.getIngredientTag(), i.getAmountToBuy(), i.getStoreName(), i.getPrice(), i.getIntendedRecipeName(), i.getIngredientName());
      shoppingListItemTiles.add(tile);
    }

    return shoppingListItemTiles;
  }

  Widget ShoppingListItemTile(String ingredientTag, int amountToBuy, String storeName, int price, String intendedRecipeName, String ingredientName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("buy $ingredientTag : "),
        Text("$amountToBuy x $ingredientName ($storeName), £${price / 100} (for $intendedRecipeName)"),
      ],
    );
  }

}