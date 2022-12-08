import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:get/get.dart';

class FirstLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.whiteColor, AppColors.primaryTransColor]),
      ),
    );
  }
}
