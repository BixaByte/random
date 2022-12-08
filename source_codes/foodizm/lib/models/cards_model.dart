import 'package:firebase_database/firebase_database.dart';

class CardsModel {
  String? cardHolderName, cardNumber, cvv, expiryDate, status;

  CardsModel({this.cardHolderName, this.cardNumber, this.cvv, this.expiryDate, this.status});

  CardsModel.fromSnapshot(DataSnapshot snapshot)
      : cardHolderName = snapshot.value["cardHolderName"],
        cardNumber = snapshot.value["cardNumber"],
        cvv = snapshot.value["cvv"],
        expiryDate = snapshot.value["expiryDate"],
        status = snapshot.value["status"];

  CardsModel.fromJson(Map<String, dynamic> json) {
    cardHolderName = json['cardHolderName'];
    cardNumber = json['cardNumber'];
    cvv = json['cvv'];
    expiryDate = json['expiryDate'];
    status = json['status'];
  }
}
