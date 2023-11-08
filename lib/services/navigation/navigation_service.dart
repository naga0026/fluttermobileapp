import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utility/constants/colors/color_constants.dart';

// All the keys and paths related to navigation

class NavigationService extends GetxService {
  static final GlobalKey<NavigatorState> kNavigatorKey =
      GlobalKey<NavigatorState>();

  static showToast(String message) {
    ScaffoldMessenger.of(kNavigatorKey.currentState!.context)
        .hideCurrentSnackBar();
    ScaffoldMessenger.of(kNavigatorKey.currentState!.context).showSnackBar(
        SnackBar(
            behavior: SnackBarBehavior.floating,
            elevation: .9,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: MediaQuery.sizeOf(kNavigatorKey.currentState!.context)
                        .height *
                    .4),
            content: Text(
              message.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )));
  }

  static cancelButtonCallBack() => Get.back();

  static Future showDialog(
      {required String title,
      subtitle,
      buttonText = "okay",
      isAddCancelButton = false,
      cancelButtonText = "cancel",
      required VoidCallback buttonCallBack,
      showTitle = false,
      VoidCallback cancelButtonCallBack = cancelButtonCallBack,
      content,
      required Icon icon}) async {
    await Get.dialog(
        barrierDismissible: false,
        WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.white,
              alignment: Alignment.center,
              title: showTitle ? Text(title) : icon,
              content: content ??
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      5.heightBox,
                      Text(subtitle ?? '')
                    ],
                  ),
              actions: [
                ElevatedButton(
                  onPressed: buttonCallBack,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: ColorConstants.primaryRedColor),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                isAddCancelButton
                    ? ElevatedButton(
                        onPressed: cancelButtonCallBack,
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: ColorConstants.primaryRedColor),
                        child: Text(
                          cancelButtonText,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(),
              ],
            )));
  }

  static Future showDialogWithOk(
      {required String title, message, content, VoidCallback? onClickOk}) async {
    await Get.dialog(
        barrierDismissible: false,
        WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.white,
              alignment: Alignment.center,
              title: Text(title),
              content: content ??
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      5.heightBox,
                      Text(message)
                    ],
                  ),
              actions: [
                ElevatedButton(
                  onPressed: () => onClickOk != null ? onClickOk() : Get.back(),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: ColorConstants.primaryRedColor),
                  child: Text(
                    TranslationKey.ok.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )));
  }

  static Future alertDialogWithTwoActions(
      {required Widget content,
      required VoidCallback onClickNo,
      required VoidCallback onClickYes,
      Widget? title,
      String? yesButtonText,
      String? noButtonText}) async {
    await Get.dialog(
        barrierDismissible: false,
        WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.white,
              alignment: Alignment.center,
              title: title,
              content: content,
              actions: [
                ElevatedButton(
                  onPressed: () => onClickYes(),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: ColorConstants.primaryRedColor),
                  child: Text(
                    yesButtonText ?? TranslationKey.yes.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => onClickNo(),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: ColorConstants.primaryRedColor),
                  child: Text(
                    noButtonText ?? TranslationKey.no.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )));
  }
}
