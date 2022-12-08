import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';

class ShowColorPicker extends StatefulWidget {
  final Function? func;

  ShowColorPicker({Key? key, this.func}) : super(key: key);

  @override
  _ShowColorPickerState createState() => _ShowColorPickerState();
}

class _ShowColorPickerState extends State<ShowColorPicker> {
  Color currentColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: Colors.transparent,
          onColorChanged: (value) {
            currentColor = value;
          },
          showLabel: true,
          enableAlpha: true,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            if (currentColor == Colors.transparent) {
              Utils().showToast("Please select any color");
            } else {
              var hex = currentColor.value.toRadixString(16).split('f');
              Get.back();
              widget.func!('${hex[0]}');
              print('${hex[0]}');
            }
          },
          style: ElevatedButton.styleFrom(
            primary: AppColors.primaryColor,
          ),
          child: const Text('Got it'),
        )
      ],
    );
  }
}
