import 'package:base_project/controller/home/ticket_maker/shoe/shoes_Front_controller.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/store_config/store_config_controller.dart';
import '../../../../model/sbo_field_model.dart';
import '../../../../ui_controls/custom_text.dart';
import '../../../../ui_controls/sbo_button.dart';
import '../../../../ui_controls/sbo_text_field.dart';
import '../../../base/base_screen.dart';
import '../../../base/widgets/app_bar.dart';

class ShoesFrontScreen extends BaseScreen {
  const ShoesFrontScreen({super.key});
  @override
  createState() => _ShoesFrontScreenState();
}

class _ShoesFrontScreenState extends BaseScreenState<ShoesFrontScreen> {
  @override
  bool get isScanningEnabled => true;

  @override
  bool get showAppBar => false;

  @override
  bool get showBackButton => true;

  @override
  bool get showCustomAppBar => true;

  final shoesFrontScreenController = Get.find<ShoesFrontScreenController>();
  final storeConfigController = Get.find<StoreConfigController>();
  final GlobalKey<FormState> _validateSignData = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (isScanningEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          zebraScanService.enableDataWedge();
          logger.d('Scanner initialized : Shoes');
        });
      });
    }
  }

  @override
  void dispose() {
    if (isScanningEnabled) {
      shoesFrontScreenController.subscription.cancel();
      zebraScanService.disableDataWedge();
      logger.d('Scanner disposed : Shoes');
    }
    super.dispose();
  }

  @override
  AppBar customAppBar() {
    return  customizedAppBar(Get.arguments[0]);
  }

  @override
  Widget body() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _validateSignData,
        child: Column(
          children: [
            10.heightBox,
            scanOrEnter(),
            10.heightBox,
            ...shoesFrontScreenController.frontTextFieldControllers.map((textFieldObj) {
              return storeConfigController.isMarshallsUSA() &&
                          textFieldObj.sboField == SBOField.uline ||
                      !storeConfigController.isMarshallsUSA() &&
                          textFieldObj.sboField == SBOField.style
                  ? SBOInputField(
                      sboFieldModel: textFieldObj)
                  : textFieldObj.sboField != SBOField.style &&
                          textFieldObj.sboField != SBOField.uline
                      ? SBOInputField(
                          sboFieldModel: textFieldObj)
                      : const SizedBox.shrink();
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SBOButtonCustom(
                  title: "Enter",
                  onPressed: () {
                    if (_validateSignData.currentState!.validate()) {
                      shoesFrontScreenController.frontOnClickEnter(Get.arguments[0]);
                    }
                  },
                  isEnabled: false,
                  width_: 85,
                  isAppbar: false,
                ),
                SBOButtonCustom(
                  title: "Clear",
                  onPressed: () {
                    shoesFrontScreenController.frontOnClickClear();
                  },
                  isEnabled: false,
                  width_: 85,
                  isAppbar: false,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
