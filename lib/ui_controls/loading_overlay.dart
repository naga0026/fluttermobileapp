import 'package:base_project/utility/constants/colors/color_constants.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoadingOverlay {
  static OverlayEntry? _overlayEntry;
  static void show() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlayState = Get.overlayContext!.findRootAncestorStateOfType<OverlayState>();
      if (_overlayEntry != null) {
        hide();
      }
      _overlayEntry = OverlayEntry(
        builder: (context) => Container(
          color: Colors.black54,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: ColorConstants.primaryRedColor,
            ),
          ),
        ),
      );
      overlayState?.insert(_overlayEntry!);});
  }
  static void showFetchingWithReference(String title) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlayState = Get.overlayContext!.findRootAncestorStateOfType<OverlayState>();
      if (_overlayEntry != null) {
        hide();
      }
      _overlayEntry = OverlayEntry(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white38.withOpacity(.5),
          body: Container(
            color: Colors.black54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: ColorConstants.primaryRedColor,
                  ),
                ),
                 10.heightBox,
                 Container(
                   padding: const EdgeInsets.all(10),
                   decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                   child:  Text(title,style:const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                 )
              ],
            ),
          ),
        ),
      );
      overlayState?.insert(_overlayEntry!);});
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}