import 'package:firebase_database/firebase_database.dart';

class DriverModel {
  String? uid, email, password, fullName, userName, profileImage, phoneNumber, age, token;
  String? vin, vehicle, licenseNo, idCardFront, idCardBack, licenseFront, licenseBack, approvalStatus, onlineStatus;

  DriverModel({
    this.uid,
    this.email,
    this.password,
    this.fullName,
    this.userName,
    this.profileImage,
    this.phoneNumber,
    this.age,
    this.token,
    this.vin,
    this.vehicle,
    this.licenseNo,
    this.idCardFront,
    this.idCardBack,
    this.licenseFront,
    this.licenseBack,
    this.approvalStatus,
    this.onlineStatus,
  });

  DriverModel.fromSnapshot(DataSnapshot snapshot)
      : uid = snapshot.value["uid"],
        email = snapshot.value["email"],
        password = snapshot.value["password"],
        fullName = snapshot.value["fullName"],
        userName = snapshot.value["userName"],
        profileImage = snapshot.value["profileImage"],
        phoneNumber = snapshot.value["phoneNumber"],
        age = snapshot.value["age"],
        token = snapshot.value["token"],
        vin = snapshot.value["vin"],
        vehicle = snapshot.value["vehicle"],
        licenseNo = snapshot.value["licenseNo"],
        idCardFront = snapshot.value["idCardFront"],
        idCardBack = snapshot.value["idCardBack"],
        licenseFront = snapshot.value["licenseFront"],
        licenseBack = snapshot.value["licenseBack"],
        approvalStatus = snapshot.value["approvalStatus"],
        onlineStatus = snapshot.value["onlineStatus"];

  DriverModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    password = json['password'];
    fullName = json['fullName'];
    userName = json['userName'];
    profileImage = json['profileImage'];
    phoneNumber = json['phoneNumber'];
    age = json['age'];
    token = json['token'];
    vin = json['vin'];
    vehicle = json['vehicle'];
    licenseNo = json['licenseNo'];
    idCardFront = json['idCardFront'];
    idCardBack = json['idCardBack'];
    licenseFront = json['licenseFront'];
    licenseBack = json['licenseBack'];
    approvalStatus = json['approvalStatus'];
    onlineStatus = json['onlineStatus'];
  }
}
