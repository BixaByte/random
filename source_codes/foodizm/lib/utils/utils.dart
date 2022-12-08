import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/screens/home_screen.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  inputDecoration(text) {
    return InputDecoration(
      hintStyle: TextStyle(fontSize: 14),
      hintText: text,
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(15),
    );
  }

  myBoxDecoration(color, borderColor) {
    return BoxDecoration(
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      color: color,
    );
  }

  inputDecorationWithLabel(hint, labelText, color) {
    return InputDecoration(
      hintStyle: TextStyle(fontSize: 14, color: AppColors.lightGreyColor, height: 1.5, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      hintText: hint,
      labelStyle: TextStyle(fontSize: 14, color: AppColors.blackColor, height: 1, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      labelText: labelText,
      filled: true,
      alignLabelWithHint: true,
      fillColor: AppColors.whiteColor,
      contentPadding: EdgeInsets.all(15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.primaryColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color)),
    );
  }

  gradient(color1, color2, circularValue) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(circularValue),
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color1, color2]),
    );
  }

  poppinsSemiBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
    );
  }

  poppinsRegularText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.normal),
    );
  }

  poppinsBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.w900),
    );
  }

  poppinsMediumText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
    );
  }

  helveticaBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
    );
  }

  helveticaMediumText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Helvetica', fontWeight: FontWeight.normal),
    );
  }

  helveticaSemiBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Helvetica', fontWeight: FontWeight.w500),
    );
  }

  helveticaSemiBold2Lines(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(height: 1.1, color: color, fontSize: size, fontFamily: 'Helvetica', fontWeight: FontWeight.w500),
    );
  }

  poppinsRegularTextLineTrough(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.normal, decoration: TextDecoration.lineThrough),
    );
  }

  poppinsMediumText1Lines(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
    );
  }

  poppinsMediumTextLineHeight(text, size, color, textAlign, height) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.w500, height: height),
    );
  }

  showSnakeBar(title, text) {
    return Get.snackbar(title, text,
        snackPosition: SnackPosition.BOTTOM, overlayBlur: 5.0, backgroundColor: AppColors.primaryColor, colorText: AppColors.accentColor);
  }

  showLoadingDialog() {
    Get.dialog(
      Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
      barrierDismissible: false,
      useSafeArea: true,
    );
  }

  showToast(text) {
    return Fluttertoast.showToast(msg: "" + text, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, fontSize: 16.0);
  }

  getUserId() {
    var credentials = Hive.box('credentials');
    return credentials.get('uid');
  }

  noDataWidget(text, height) {
    return Container(
      height: height,
      child: Center(
        child: Text(
          text,
          softWrap: false,
          style: TextStyle(color: AppColors.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void getUserCurrentLocation(String origin) async {
    var status = await Permission.location.request();

    if (status == PermissionStatus.granted) {
      await Geolocator.getCurrentPosition().then((value) async {
        var addresses = await GeoCode().reverseGeocoding(latitude: value.latitude, longitude: value.longitude);
        print(' ${addresses.streetAddress}, ${addresses.city}');
        Common.currentLat = value.latitude.toString();
        Common.currentLng = value.longitude.toString();
        Common.currentAddress = addresses.streetAddress;
        Common.currentCity = addresses.city;
        if (origin == 'location') {
          Get.offAll(() => HomeScreen());
        }
      });
    } else {
      showToast('You need to allow location permission in order to continue');
    }
  }
}
