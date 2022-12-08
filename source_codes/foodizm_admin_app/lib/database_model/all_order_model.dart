import 'package:firebase_database/firebase_database.dart';

class AllOrderModel {
  String? orderId, timeStamp;

  AllOrderModel({this.orderId, this.timeStamp});

  AllOrderModel.fromSnapshot(DataSnapshot snapshot)
      : orderId = snapshot.value["orderId"],
        timeStamp = snapshot.value["timeStamp"];

  AllOrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['name'];
    timeStamp = json['timeStamp'];
  }
}
