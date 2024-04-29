import 'package:mongo_dart/mongo_dart.dart';

class WishList {
  static Future<List<String>> getAllExistingIngredientNames() async {
    Db db = await Db.create("mongodb+srv://admin:JKEw0feoZCxOE0LS@cluster0.m5iuzzq.mongodb.net:27017/webstores");

    //db = Db.create("mongodb+srv://admin:JKEw0feoZCxOE0LS@cluster0.m5iuzzq.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
    await db.open(secure: true);

    final collection = db.collection('webstoreWishList');

    List<String> ingredients = [];
    final result = await collection.find().toList();



    // result (entry) entries (key) value
    for (int entry = 0; entry < result.length; entry++) {
      String ingredientName = result[entry].entries.elementAt(1).value;
      ingredients.add(ingredientName);
    }

    return ingredients;
  }

}