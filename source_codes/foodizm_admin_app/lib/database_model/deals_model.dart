import 'package:firebase_database/firebase_database.dart';

class DealsModel {
  String? title, details, discount, expiryDate, image, newPrice, oldPrice, validDate, type, noOfServing, timeCreated;
  int? viewsCount, totalOrder;
  List<String>? customizationForDrinks;
  List<String>? customizationForFlavours;
  List<String>? itemsIncluded;

  DealsModel({
    this.title,
    this.details,
    this.discount,
    this.expiryDate,
    this.image,
    this.newPrice,
    this.oldPrice,
    this.validDate,
    this.type,
    this.noOfServing,
    this.timeCreated,
    this.viewsCount,
    this.totalOrder,
    this.customizationForDrinks,
    this.customizationForFlavours,
    this.itemsIncluded,
  });

  DealsModel.fromSnapshot(DataSnapshot snapshot)
      : title = snapshot.value["title"],
        details = snapshot.value["details"],
        discount = snapshot.value["discount"],
        expiryDate = snapshot.value["expiryDate"],
        image = snapshot.value["image"],
        newPrice = snapshot.value["newPrice"].toString(),
        oldPrice = snapshot.value["oldPrice"].toString(),
        validDate = snapshot.value["validDate"],
        type = snapshot.value["type"],
        noOfServing = snapshot.value["no_of_serving"].toString(),
        timeCreated = snapshot.value["timeCreated"],
        customizationForDrinks = snapshot.value["customizationForDrinks"],
        customizationForFlavours = snapshot.value["customizationForFlavours"],
        itemsIncluded = snapshot.value["itemsIncluded"],
        viewsCount = snapshot.value["viewsCount"],
        totalOrder = snapshot.value["totalOrder"];

  DealsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    details = json['details'];
    discount = json['discount'];
    expiryDate = json['expiryDate'];
    image = json['image'];
    newPrice = json['newPrice'].toString();
    oldPrice = json['oldPrice'].toString();
    validDate = json['validDate'];
    type = json['type'];
    noOfServing = json['no_of_serving'].toString();
    timeCreated = json['timeCreated'];
    customizationForDrinks = json['customizationForDrinks'].cast<String>();
    customizationForFlavours = json['customizationForFlavours'].cast<String>();
    itemsIncluded = json['itemsIncluded'].cast<String>();
    viewsCount = json['viewsCount'];
    totalOrder = json['totalOrder'];
  }
}
