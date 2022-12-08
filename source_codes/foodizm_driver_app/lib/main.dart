import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Directory directory = await pathProvider.getApplicationSupportDirectory();
  Hive.init(directory.path);
  await Hive.openBox('credentials');
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return  GetMaterialApp(
        defaultTransition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: 700),
        title: 'Foodizm Driver',
        theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            primaryColor: AppColors.primaryColor,
            colorScheme: ThemeData().colorScheme.copyWith(secondary: AppColors.primaryColor, primary: AppColors.primaryColor),
            platform: TargetPlatform.iOS),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
    );
  }
}
