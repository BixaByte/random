import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/locale/translation_file.dart';
import 'package:foodizm_admin_app/providers/add_drinks_widget_provider.dart';
import 'package:foodizm_admin_app/providers/add_flavours_widget_provider.dart';
import 'package:foodizm_admin_app/providers/add_ingredients_widget_provider.dart';
import 'package:foodizm_admin_app/providers/add_item_included_widget_provider.dart';
import 'package:foodizm_admin_app/providers/add_variations_widget_provider.dart';
import 'package:foodizm_admin_app/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AddDrinksWidgetProvider()),
        ChangeNotifierProvider.value(value: AddFlavoursWidgetProvider()),
        ChangeNotifierProvider.value(value: AddIngredientsWidgetProvider()),
        ChangeNotifierProvider.value(value: AddVariationsWidgetProvider()),
        ChangeNotifierProvider.value(value: AddItemIncludedWidgetProvider()),
      ],
      child: GetMaterialApp(
        defaultTransition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: 700),
        title: 'Foodizm Restaurant',
        translations: TranslationsFile(),
        fallbackLocale: Locale('en', 'US'),
        locale: Locale('en', 'US'),
        theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            primaryColor: AppColors.primaryColor,
            colorScheme: ThemeData().colorScheme.copyWith(secondary: AppColors.accentColor, primary: AppColors.primaryColor),
            platform: TargetPlatform.iOS),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
