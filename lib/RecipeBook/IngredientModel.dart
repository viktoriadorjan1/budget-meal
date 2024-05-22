import 'dart:convert';

class Ingredient {
  String _storeName = "";
  String _ingredientName = "";
  String _category = "other";
  int _quantity = 0;
  String _unit = "";
  NutritionalInformation? _nutritionalInfo;
  double _totalPrice = 0;
  //int _perUnitPrice = 0;
  String _storage = "";
  ExpiryInformation _expiryInfo = ExpiryInformation();

  Ingredient(IngredientBuilder builder) {
    _storeName = builder._storeName;
    _ingredientName = builder._ingredientName;
    _category = builder._category;
    _quantity = builder._quantity;
    _unit = builder._unit;
    _nutritionalInfo = builder._nutritionalInfo;
    _totalPrice = builder._totalPrice;
    //_perUnitPrice = builder._perUnitPrice;
    _storage = builder._storage;
    _expiryInfo = builder._expiryInfo;
  }

  String getUnit() {
    return _unit;
  }

  int getQuantity() {
    return _quantity;
  }

  String getIngredientName({bool? normalised}) {
    if (normalised == null || !normalised) return _ingredientName;
    return _ingredientName.replaceAll(' ', '_').toLowerCase();
  }

  void updateQuantity(int newQuantity) {
    _quantity = newQuantity;
  }

  double getTotalPrice() {
    return _totalPrice;
  }

  String getCategory() {
    return _category;
  }

  void buy() {
    //_perUnitPrice = 0;
    _totalPrice = 0;
  }
}

class IngredientBuilder {
  String _storeName = "";
  String _ingredientName = "";
  String _category = "other";
  int _quantity = 0;
  String _unit = "";
  NutritionalInformation? _nutritionalInfo;
  double _totalPrice = 0;
  //int _perUnitPrice = 0;
  String _storage = "";
  ExpiryInformation _expiryInfo = ExpiryInformation();

  IngredientBuilder();

  Ingredient build() {
    //if (_quantity > 0) _perUnitPrice = _totalPrice / _quantity;
    Ingredient ingredient = Ingredient(this);
    return ingredient;
  }

  IngredientBuilder fromStore(String storeName) {
    _storeName = storeName;
    return this;
  }

  IngredientBuilder withIngredientName(String ingredientName) {
    _ingredientName = ingredientName;
    return this;
  }

  IngredientBuilder withCategory(String category) {
    _category = category;
    return this;
  }

  IngredientBuilder withAmount(int quantity, String unit) {
    _quantity = quantity;
    _unit = unit;
    return this;
  }

  IngredientBuilder withNutritionalInfo(NutritionalInformation nutritionalInfo) {
    _nutritionalInfo = nutritionalInfo;
    return this;
  }

  IngredientBuilder withTotalPrice(double totalPrice) {
    _totalPrice = totalPrice;
    return this;
  }

  IngredientBuilder inStorage(String storage) {
    _storage = storage;
    return this;
  }

  IngredientBuilder withExpiry(ExpiryInformation expiryInfo) {
    _expiryInfo = expiryInfo;
    return this;
  }

}

class ExpiryInformation {
  // key: storage method (e.g. cupboard, fridge, freezer), value: days until expiry
  Map<String, int> expiryInfo = {};
}

class NutritionalInformation {
  Fats _fats;
  Saturates _saturates;
  Carbs _carbs;
  Sugars _sugars;
  Protein _protein;
  Salt _salt;

  NutritionalInformation(this._fats, this._saturates, this._carbs, this._sugars, this._protein, this._salt);

  List<Nutrition> getNutritions() {
    return [_fats, _saturates, _carbs, _sugars, _protein, _salt];
  }

  // GETTERS

  Fats getFats() {
    return _fats;
  }

  Saturates getSaturates() {
    return _saturates;
  }

  Carbs getCarbs() {
    return _carbs;
  }

  Sugars getSugars() {
    return _sugars;
  }

  Protein getProtein() {
    return _protein;
  }

  Salt getSalt() {
    return _salt;
  }

  // SETTERS

  void setFats(Fats fats) {
    _fats = fats;
  }

  void setSaturates(Saturates saturates) {
    _saturates = saturates;
  }

  void setCarbs(Carbs carbs) {
    _carbs = carbs;
  }

  void setSugars(Sugars sugars) {
    _sugars = sugars;
  }

  void setProtein(Protein protein) {
    _protein = protein;
  }

  void setSalt(Salt salt) {
    _salt = salt;
  }

  String toJson() {
    Map<String, dynamic> generateJson() => {
      for (Nutrition n in getNutritions()) n.runtimeType.toString().toLowerCase() : {
        "lower_limit" : n._lowerLimit,
        "upper_limit": n._upperLimit
      }
    };

    print(jsonEncode(generateJson()));

    return jsonEncode(generateJson());
  }
}

abstract class Nutrition {
  int _lowerLimit;
  int _upperLimit;

  Nutrition(this._lowerLimit, this._upperLimit);

  int getLowerLimit() {
    return _lowerLimit;
  }

  int getUpperLimit() {
    return _upperLimit;
  }

  void setLowerLimit(int limit) {
    _lowerLimit = limit;
  }

  void setUpperLimit(int limit) {
    _upperLimit = limit;
  }
}

class Fats extends Nutrition {
  Fats(super.lowerLimit, super.upperLimit);
}

class Saturates extends Nutrition {
  Saturates(super.lowerLimit, super.upperLimit);
}

class Carbs extends Nutrition {
  Carbs(super.lowerLimit, super.upperLimit);
}

class Sugars extends Nutrition {
  Sugars(super.lowerLimit, super.upperLimit);
}

class Protein extends Nutrition {
  Protein(super.lowerLimit, super.upperLimit);
}

class Salt extends Nutrition {
  Salt(super.lowerLimit, super.upperLimit);
}