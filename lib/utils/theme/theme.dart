import 'package:cinema_app/utils/theme/custom_themes/appbar_theme.dart';
import 'package:cinema_app/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:cinema_app/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:cinema_app/utils/theme/custom_themes/chip_theme.dart';
import 'package:cinema_app/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:cinema_app/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:cinema_app/utils/theme/custom_themes/text_field_theme.dart';
import 'package:flutter/material.dart';
import 'package:cinema_app/utils/theme/custom_themes/text_theme.dart';

class AppTheme{
  AppTheme._(); //private ctor

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: MyAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: MyBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: MyCheckboxTheme.lightCheckboxTheme,
    chipTheme: MyChipTheme.lightChipTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.lightOutlineButtonTheme,
    textTheme: AppTextTheme.lightTextTheme,
    inputDecorationTheme: MyTextFormFieldTheme.lightInputDecorationTheme
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: MyAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: MyBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: MyCheckboxTheme.darkCheckboxTheme,
    chipTheme: MyChipTheme.darkChipTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.darkOutlineButtonTheme,
    textTheme: AppTextTheme.darkTextTheme,
    inputDecorationTheme: MyTextFormFieldTheme.darkInputDecorationTheme
  );
}