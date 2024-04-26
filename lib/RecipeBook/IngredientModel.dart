class Ingredient {
  String _storeName = "";
  String _ingredientName = "";
  String _category = "Uncategorised";
  int _quantity = 0;
  String _unit = "";
  NutritionalInformation _nutritionalInfo = NutritionalInformation();
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
    return _ingredientName.replaceAll(' ', '_');
  }

  void updateQuantity(int newQuantity) {
    _quantity = newQuantity;
  }

  double getTotalPrice() {
    return _totalPrice;
  }

  void buy() {
    //_perUnitPrice = 0;
    _totalPrice = 0;
  }

  String getCategory() {
    return _category;
  }
}

class IngredientBuilder {
  String _storeName = "";
  String _ingredientName = "";
  String _category = "Uncategorised";
  int _quantity = 0;
  String _unit = "";
  NutritionalInformation _nutritionalInfo = NutritionalInformation();
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
  double fat = 0;
  double saturates = 0;
  double carbs = 0;
  double sugars = 0;
  double fibre = 0;
  double protein = 0;
  double salt = 0;
}