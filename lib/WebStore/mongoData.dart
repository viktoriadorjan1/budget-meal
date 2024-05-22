import 'package:mongo_dart/mongo_dart.dart';

Future<List<String>> getUnitsForIngredientFromDB(String category) async {
  String uri = "mongodb+srv://admin:JKEw0feoZCxOE0LS@cluster0.m5iuzzq.mongodb.net:27017/webstores";

  Db db = await Db.create(uri);
  await db.open(secure: true);

  final DbCollection collection = db.collection("webstoreWishList");

  var entries = await collection.find(where.eq("ingredientCategory", category)).toList();

  List<String> possibleUnits = [];
  for (Map<String, dynamic> entry in entries) {
    List<String> units = List<String>.from(entry["possibleUnits"]);
    for (String unit in units) {
      if (!possibleUnits.contains(unit)) {
        possibleUnits.add(unit);
      }
    }
  }

  //List<String> units = List<String>.from(entry["possibleUnits"]);
  print("units is $possibleUnits");
  return possibleUnits;
}