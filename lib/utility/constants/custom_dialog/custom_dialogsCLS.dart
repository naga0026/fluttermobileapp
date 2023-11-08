import 'package:base_project/model/sbo_field_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../controller/tab/main_tab_controller.dart';
import '../../../services/navigation/navigation_service.dart';
import '../../../translations/translation_keys.dart';
import '../images_and_icons/icon_constants.dart';

class CustomDialog {
  static showInvalidSyncDialog() {
    return NavigationService.showDialog(
      title: TranslationKey.error.tr,
      subtitle: TranslationKey.invalidSync.tr,
      buttonCallBack: () {
        Get.back();
      },
      icon: IconConstants.invalidLoginIcon,
    );
  }

  static showDialogInTransferError(String subtitle) {
    return NavigationService.showDialog(
      title: TranslationKey.error.tr,
      subtitle: subtitle,
      buttonCallBack: () {
        Get.back();
      },
      icon: IconConstants.invalidLoginIcon,
    );
  }

  static showInvalidLoginDialog() {
    return NavigationService.showDialog(
      title: TranslationKey.error.tr,
      subtitle: TranslationKey.invalidLogin.tr,
      buttonCallBack: () {
        Get.back();
      },
      icon: IconConstants.invalidLoginIcon,
    );
  }

  static showInvalidIPFormatDialog() {
    return NavigationService.showDialog(
        title: TranslationKey.error.tr,
        subtitle: TranslationKey.invalidIpFormat.tr,
        buttonText: TranslationKey.ok.tr,
        icon: IconConstants.failedIcon,
        buttonCallBack: () {
          Get.back();
        });
  }

  static showErrorDialog() {
    return NavigationService.showDialog(
        title: TranslationKey.error.tr,
        subtitle: TranslationKey.thereIsAnError.tr,
        buttonText: TranslationKey.ok.tr,
        icon: IconConstants.failedIcon,
        buttonCallBack: () {
          Get.back();
        });
  }

  static navigateToPrinter() {
    final mainTabController = Get.find<MainTabController>();
    mainTabController.currentIndex.value = 1;
    Get.back();
  }

  static showNoPrinterFoundDialog() {
    return WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.showDialog(
          title: "No Printer Found",
          subtitle:
              "Please add printer before going for label printing by Clicking below.",
          buttonCallBack: () {
            navigateToPrinter();
          },
          buttonText: "Navigate",
          icon: IconConstants.warningIcon);
    });
  }

  static showEndBoxWithParameters(
      {required String storeNumber,
      required VoidCallback onClickYes,
      required VoidCallback onClickNo}) {
    return WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.showDialog(
          title: "STORE-TO-STORE\nSHIPPING",
          subtitle:
              "Confirm Location\nShip to location is store $storeNumber \n is it correct ? ",
          buttonCallBack: onClickYes,
          cancelButtonCallBack: onClickNo,
          buttonText: "YES",
          isAddCancelButton: true,
          cancelButtonText: "NO",
          icon: IconConstants.alertBellIcon);
    });
  }

  static showStockMismatchDialog() {
    return WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.showDialog(
          title: "Wrong Printer Profile",
          subtitle: "DO YOU WANT TO CORRECT PROFILE ?",
          buttonCallBack: () {
            navigateToPrinter();
          },
          buttonText: "YES",
          icon: IconConstants.warningIcon,
          cancelButtonText: "NO",
          isAddCancelButton: true);
    });
  }

  static showDialogInTransferScreen(
      {required String title,
      required cancelButtonText,
      required buttonText,
      required subtitle,
      required VoidCallback buttonCallBack,
      required Icon icon,
      required bool showTitle,
      required bool isCancelButtonRequired,
      required VoidCallback cancelButtonCallBack,
      content}) {
    return WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.showDialog(
          title: title,
          subtitle: subtitle,
          buttonCallBack: buttonCallBack,
          cancelButtonText: cancelButtonText,
          icon: icon,
          buttonText: buttonText,
          showTitle: showTitle,
          isAddCancelButton: isCancelButtonRequired,
          cancelButtonCallBack:cancelButtonCallBack,
          content: content);
    });
  }
}
