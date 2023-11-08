import 'package:flutter/material.dart';

class IconConstants {

  //region Tab Icons
  static const String icHome = 'assets/icons/home.png';
  static const String icHomeActive = 'assets/icons/home_active.png';
  static const String icPrinter = 'assets/icons/printer.png';
  static const String icPrinterActive = 'assets/icons/printer_active.png';
  static const String icBarcode = 'assets/icons/barcode.png';
  static const String icBarcodeActive = 'assets/icons/barcode_active.png';
  static const String icAccount = 'assets/icons/account.png';
  static const String icAccountActive = 'assets/icons/account_active.png';
  static const String icSetting = 'assets/icons/setting.png';
  static const String icSettingActive = 'assets/icons/setting_active.png';
//endregion

  static const String icHamburger = 'assets/icons/hamburger.png';
  static const String icLocation = 'assets/icons/location.png';
  static const failedIcon = Icon(
    Icons.build_circle_outlined,
    color: Colors.red,
    size: 50,
  );static const alertBellIcon = Icon(
    Icons.circle_notifications_outlined,
    color: Colors.orange,
    size: 50,
  );
  static const successIcon = Icon(
    Icons.check_circle_outlined,
    color: Colors.green,
    size: 50,
  );
  static const warningIcon = Icon(
    Icons.warning_amber,
    color: Colors.orange,
    size: 50,
  );
  static const exitAppIcon = Icon(
    Icons.exit_to_app,
    color: Colors.red,
    size: 50,
  );

  static const invalidLoginIcon =  Icon(
    Icons.account_circle_outlined,
    color: Colors.red,
    size: 50,
  );
}