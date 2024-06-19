import 'dart:convert';

import '../RecipeBook/IngredientModel.dart';

class ShoppingList {
  List<ShoppingListItem> shoppingList = [];

  ShoppingList();

  void addItem(ShoppingListItem item) {
    shoppingList.add(item);
  }

  String toJson() {
    Map<String, dynamic> generateJson() => {
      for (ShoppingListItem i in shoppingList) i.getIngredientTag() : {
        "intendedRecipeName" : i.getIntendedRecipeName(),
        "amountToBuy": i.getAmountToBuy(),
        "storeName": i.getStoreName(),
        "price": i.getPrice(),
        "ingredientName": i.getIngredientName(),
        "quantity": i.getQuantity(),
        "unit": i.getUnit(),
        "category": i.getCategory(),
        "isTicked": i.getIsTicked()
      }
    };

    return jsonEncode(generateJson());
  }

  List<ShoppingListItem> getShoppingList() {
    return shoppingList;
  }
}

class ShoppingListItem {
  final String _intendedRecipeName; // e.g. (for) cereal
  final String _ingredientTag;   // e.g. milk
  final String _ingredientName;  // e.g. Nature's Pick Jazz Apples 6 Pack
  final int _amountToBuy;        // e.g. 2x
  final int _quantity;           // e.g. 200 (ml)
  final String _unit;            // e.g. ml
  final String _storeName;       // e.g. Aldi
  final int _price;              // e.g. 200 (i.e. £2.00)
  final String _category;        // e.g. dairy
  final NutritionalInformation _nutritionalInformation;
  bool _isTicked;

  ShoppingListItem(this._intendedRecipeName, this._ingredientTag, this._amountToBuy, this._storeName, this._price, this._ingredientName, this._quantity, this._unit, this._category, this._nutritionalInformation, this._isTicked);

  // GETTERS

  String getStoreName() {
    return _storeName;
  }

  String getIngredientTag() {
    return _ingredientTag.replaceAll("_", " ");
  }

  int getAmountToBuy() {
    return _amountToBuy;
  }

  int getPrice() {
    return _price;
  }

  String getIntendedRecipeName() {
    return _intendedRecipeName;
  }

  String getIngredientName() {
    return _ingredientName.replaceAll("_", " ");
  }

  int getQuantity() {
    return _quantity;
  }

  String getUnit() {
    return _unit;
  }

  String getCategory() {
    return _category;
  }

  NutritionalInformation getNutritionalInformation() {
    return _nutritionalInformation;
  }

  bool getIsTicked() {
    return _isTicked;
  }

  // SETTER

  void setIsTicked(bool isTicked) {
    _isTicked = isTicked;
  }
}