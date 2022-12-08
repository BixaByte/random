import 'package:firebase_database/firebase_database.dart';

class ProductModel {
  String? categoryId, title, details, image, price, type, noOfServing, timeCreated;
  int? viewsCount;
  List<Map<String, dynamic>?>? customizationForVariations;
  List<String>? customizationForFlavours;
  List<String>? ingredients;

  ProductModel({
    this.categoryId,
    this.title,
    this.details,
    this.image,
    this.price,
    this.type,
    this.noOfServing,
    this.timeCreated,
    this.viewsCount,
    this.customizationForVariations,
    this.customizationForFlavours,
    this.ingredients,
  });

  ProductModel.fromSnapshot(DataSnapshot snapshot)
      : categoryId = snapshot.value["categoryId"],
        title = snapshot.value["title"],
        details = snapshot.value["details"],
        image = snapshot.value["image"],
        price = snapshot.value["price"].toString(),
        type = snapshot.value["type"],
        noOfServing = snapshot.value["no_of_serving"],
        timeCreated = snapshot.value["timeCreated"],
        customizationForVariations = snapshot.value["customizationForVariations"],
        customizationForFlavours = snapshot.value["customizationForFlavours"],
        ingredients = snapshot.value["ingredients"],
        viewsCount = snapshot.value["viewsCount"];

  ProductModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    title = json['title'];
    details = json['details'];
    image = json['image'];
    price = json['price'].toString();
    type = json['type'];
    noOfServing = json['no_of_serving'];
    timeCreated = json['timeCreated'];
    customizationForVariations = json["customizationForVariations"] =
        (json['customizationForVariations'] as List).map((e) => e == null ? null : Map<String, dynamic>.from(e)).toList();
    customizationForFlavours = json['customizationForFlavours'].cast<String>();
    ingredients = json['ingredients'].cast<String>();
    viewsCount = json['viewsCount'];
  }
}
