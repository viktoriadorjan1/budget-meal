import 'package:budget_meal/RecipeBook/IngredientModel.dart';
import 'package:budget_meal/ShoppingList/ShoppingListModel.dart';
import 'package:flutter/material.dart';
import '../Pantry/PantryModel.dart';
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
      var tile = ShoppingListItemTile(shoppingListItem: i, userData: widget.userData);
      shoppingListItemTiles.add(tile);
    }

    return shoppingListItemTiles;
  }

  /*
  Widget ShoppingListItemTile(String ingredientTag, int amountToBuy, String storeName, int price, String intendedRecipeName, String ingredientName) {
    IconData iconData = Icons.circle_outlined;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("buy $ingredientTag : "),
        Text("$amountToBuy x $ingredientName ($storeName), £${price / 100} (for $intendedRecipeName)"),
        IconButton(
            onPressed: () {
              setState(() {
                if (iconData == Icons.circle_outlined) {
                  iconData = Icons.check_circle_outline;
                  print("tick");
                } else {
                  iconData = Icons.circle_outlined;
                  print("untick");
                }
              });
            },
            icon: Icon(iconData)
        )
      ],
    );
  }
   */

}

class ShoppingListItemTile extends StatefulWidget {
  final ShoppingListItem shoppingListItem;
  final UserData userData;

  const ShoppingListItemTile({super.key, required this.shoppingListItem, required this.userData});

  @override
  State<ShoppingListItemTile> createState() => _ShoppingListItemTileState();
}

class _ShoppingListItemTileState extends State<ShoppingListItemTile>{
  @override
  Widget build(BuildContext context) {
    String ingredientTag = widget.shoppingListItem.getIngredientTag();
    String ingredientName = widget.shoppingListItem.getIngredientName();
    String storeName = widget.shoppingListItem.getStoreName();
    int amountToBuy = widget.shoppingListItem.getAmountToBuy();
    double price = widget.shoppingListItem.getPrice() / 100;
    int quantity = widget.shoppingListItem.getQuantity();
    String unit = widget.shoppingListItem.getUnit();
    String intendedRecipeName = widget.shoppingListItem.getIntendedRecipeName();
    String category = widget.shoppingListItem.getCategory();
    NutritionalInformation nutritionalInformation = widget.shoppingListItem.getNutritionalInformation();

    IconData iconData = widget.shoppingListItem.getIsTicked() ? Icons.check_circle_outline : Icons.circle_outlined;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("buy $ingredientTag : "),
        Text("$amountToBuy x $ingredientName ($storeName), £$price (for $intendedRecipeName)"),
        IconButton(
            onPressed: () {
              if (!widget.shoppingListItem.getIsTicked()) {
                // was unchecked, now checked, add ingredient to pantry.
                setState(() {
                  widget.shoppingListItem.setIsTicked(true);
                });

                Ingredient ingredient = IngredientBuilder().withIngredientTag(ingredientTag).withIngredientName(ingredientName).withAmount(quantity, unit).withCategory(category).withTotalPrice(price).withNutritionalInfo(nutritionalInformation).build();
                widget.userData.getPantry().putInPantry(ingredient);
              } else {
                // was checked, now unchecked, removed ingredient from pantry if still possible.
                setState(() {
                  widget.shoppingListItem.setIsTicked(false);
                });

                try {
                  widget.userData.getPantry().useFromPantry(ingredientName, quantity, unit);
                } catch (e) {
                  print(e);
                  // The pantry item is already used. Still unchecks the box, you can buy it again.
                }
              }
              widget.userData.saveUserData();
            },
            icon: Icon(iconData)
        )
      ],
    );
  }
}