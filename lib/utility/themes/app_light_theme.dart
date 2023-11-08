import 'package:base_project/utility/constants/colors/color_constants.dart';
import 'package:base_project/utility/constants/colors/material_color_constants.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: ColorConstants.primaryRedColor,
    primarySwatch: MaterialColorConstants.primarySwatch,
    appBarTheme: LightThemeValues.appBarTheme,
    textSelectionTheme: LightThemeValues.textSelectionTheme,
    tabBarTheme: LightThemeValues.tabBarTheme,
    switchTheme: LightThemeValues.switchTheme,
    inputDecorationTheme: LightThemeValues.inputDecorationTheme,
    buttonTheme: ButtonThemeData(buttonColor: ColorConstants.primaryRedColor),
    filledButtonTheme: LightThemeValues.filledBtnTheme,
    floatingActionButtonTheme: LightThemeValues.fabTheme,
    colorScheme: LightThemeValues.colorScheme,
    dialogTheme: LightThemeValues.dialogTheme,
    textButtonTheme: LightThemeValues.textButtonTheme,
    radioTheme: LightThemeValues.radioTheme,
    chipTheme: ChipThemeData(
        backgroundColor: Colors.grey,
        selectedColor: ColorConstants.primaryRedColor
    )
);

class LightThemeValues {
  static RadioThemeData radioTheme = RadioThemeData(
      fillColor: MaterialStateProperty.all(ColorConstants.primaryRedColor));

  static TextButtonThemeData textButtonTheme = TextButtonThemeData(
      style: ButtonStyle(
    textStyle: MaterialStateProperty.all(
        TextStyle(color: ColorConstants.primaryRedColor)),
  ));

  static const DialogTheme dialogTheme = DialogTheme(
    backgroundColor: Colors.white,
  );

  static FloatingActionButtonThemeData fabTheme = FloatingActionButtonThemeData(
      backgroundColor: ColorConstants.primaryRedColor);

  static ColorScheme colorScheme = ColorScheme.fromSwatch().copyWith(secondary: Colors.white);

  static FilledButtonThemeData filledBtnTheme = FilledButtonThemeData(
      style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(ColorConstants.primaryRedColor)));

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
      iconColor: ColorConstants.primaryRedColor,
      prefixIconColor: ColorConstants.primaryRedColor,
      suffixIconColor: ColorConstants.primaryRedColor,
      enabledBorder: const OutlineInputBorder()
          .copyWith(borderSide: const BorderSide(color: Colors.grey)),
      focusedBorder: const OutlineInputBorder().copyWith(
          borderSide: BorderSide(color: ColorConstants.primaryRedColor)),
      labelStyle: const TextStyle(color: Colors.grey),
      focusColor: ColorConstants.primaryRedColor,
      contentPadding: const EdgeInsets.only(left: 8, right: 8),
      hintStyle: const TextStyle(color: Colors.grey));

  static SwitchThemeData switchTheme = SwitchThemeData(
      thumbColor: MaterialStateProperty.all(ColorConstants.primaryRedColor),
      trackColor: MaterialStateProperty.all(Colors.grey));

  static TabBarTheme tabBarTheme = const TabBarTheme(
      indicatorColor: Colors.grey,
      unselectedLabelColor: Colors.white,
      labelColor: Colors.white,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal));

  static TextSelectionThemeData textSelectionTheme = TextSelectionThemeData(
    selectionColor: Colors.grey,
    cursorColor: ColorConstants.primaryRedColor,
    selectionHandleColor: ColorConstants.primaryRedColor,
  );

  static AppBarTheme appBarTheme = AppBarTheme(
      color: ColorConstants.primaryRedColor,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white));
}
