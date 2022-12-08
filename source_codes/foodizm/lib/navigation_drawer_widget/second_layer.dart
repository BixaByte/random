import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:get/get.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

SecondLayerState? secondLayerState;

class SecondLayer extends StatefulWidget {
  @override
  SecondLayerState createState() => SecondLayerState();
}

class SecondLayerState extends State<SecondLayer> {
  RxDouble xoffSet = 0.0.obs;
  RxDouble yoffSet = 0.0.obs;
  RxDouble angle = 0.0.obs;
  RxBool isOpen = false.obs;

  @override
  Widget build(BuildContext context) {
    secondLayerState = this;
    return Obx(() {
      return AnimatedContainer(
        transform: Matrix4Transform().translate(x: xoffSet.value, y: yoffSet.value).rotate(angle.value).matrix4,
        duration: Duration(milliseconds: 550),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primaryColor),
      );
    });
  }
}
