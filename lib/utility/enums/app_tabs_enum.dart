import 'package:base_project/utility/constants/images_and_icons/icon_constants.dart';

enum AppTab {
  home,
  printer,
  scanAndPrint,
  profile,
  settings

}

extension AppTabValue on AppTab {

  String get icon {
    switch(this) {
      case AppTab.home:
        return IconConstants.icHome;
      case AppTab.printer:
        return IconConstants.icPrinter;
      case AppTab.scanAndPrint:
        return IconConstants.icBarcode;
      case AppTab.profile:
        return IconConstants.icPrinter;
      case AppTab.settings:
        return IconConstants.icSetting;
    }
  }

  String get activeIcon {
    switch(this) {
      case AppTab.home:
        return IconConstants.icHome;
      case AppTab.printer:
        return IconConstants.icPrinter;
      case AppTab.scanAndPrint:
        return IconConstants.icBarcode;
      case AppTab.profile:
        return IconConstants.icPrinter;
      case AppTab.settings:
        return IconConstants.icSetting;
    }
  }

}