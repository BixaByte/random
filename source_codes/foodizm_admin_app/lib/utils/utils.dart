import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Utils {
  boxDecoration(color, borderColor) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(10),
    );
  }

  inputDecoration(text) {
    return InputDecoration(
      hintStyle: TextStyle(fontSize: 14),
      hintText: text,
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(15),
    );
  }

  inputDecorationWithLabel(hint, labelText, fillColor, color, {image, onTap}) {
    return InputDecoration(
      hintStyle: TextStyle(fontSize: 14, color: AppColors.lightGreyColor, height: 1.5, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      hintText: hint,
      labelStyle: TextStyle(fontSize: 14, color: AppColors.primaryColor, height: 1, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      labelText: labelText,
      filled: true,
      alignLabelWithHint: true,
      fillColor: fillColor,
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.primaryColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color)),
      suffixIcon: image != null
          ? InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(image, color: AppColors.blackColor, height: 20, width: 20),
              ),
            )
          : null,
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

  int timeAgoSinceDate(int newTimeStamp, {bool numericDates = true}) {
    var date = DateTime.fromMillisecondsSinceEpoch(newTimeStamp);
    final date2 = DateTime.now();
    final difference = date2.difference(date);
    if (difference.inDays > 8) {
      return 8;
    } else if ((difference.inDays == 7)) {
      return 7;
    } else if (difference.inDays == 6) {
      return 6;
    } else if (difference.inDays == 5) {
      return 5;
    } else if (difference.inDays == 4) {
      return 4;
    } else if (difference.inDays == 3) {
      return 3;
    } else if (difference.inDays == 2) {
      return 2;
    } else if (difference.inDays <= 1) {
      return 1;
    } else {
      return 0;
    }
  }
}
