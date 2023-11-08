import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/home/ticket_maker/shoe/shoes_ Final_controller.dart';
import '../../../../controller/home/ticket_maker/shoe/shoes_Front_controller.dart';
import '../../../../controller/store_config/store_config_controller.dart';
import '../../../../model/sbo_field_model.dart';
import '../../../../ui_controls/custom_text.dart';
import '../../../../ui_controls/sbo_button.dart';
import '../../../../ui_controls/sbo_text_field.dart';
import '../../../base/base_screen.dart';
import '../../../base/widgets/app_bar.dart';
import '../../../base/widgets/dropdown.dart';

class ShoesFinalScreen extends BaseScreen {
  const ShoesFinalScreen({super.key});
  @override
  createState() => _ShoesFrontScreenState();
}

class _ShoesFrontScreenState extends BaseScreenState<ShoesFinalScreen> {
  @override
  bool get isScanningEnabled => true;

  @override
  bool get showAppBar => false;

  @override
  bool get showBackButton => true;

  @override
  bool get showCustomAppBar => true;

  final shoesFinalScreenController = Get.find<ShoesFinalScreenController>();
  final shoesFrontScreenController = Get.find<ShoesFrontScreenController>();
  final storeConfigController = Get.find<StoreConfigController>();
  final GlobalKey<FormState> _validateSignData = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    shoesFinalScreenController.finalScreenOnClickClear();
    shoesFinalScreenController.getVendorData();
    shoesFinalScreenController.getOurPriceController().text = Get.arguments[1]["ticketPrice"];
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
      shoesFinalScreenController.subscription.cancel();
      zebraScanService.disableDataWedge();
      logger.d('Scanner disposed : Shoes');
    }
    super.dispose();
  }

  @override
  AppBar customAppBar() {
    return customizedAppBar(Get.arguments[0]);
  }

  @override
  Widget body() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _validateSignData,
          child: Column(
            children: [
              10.heightBox,
              scanOrEnter(),
              10.heightBox,
              Row(
                children: [
                  const SizedBox(
                      width: 100,
                      child: Text(
                        "BRAND",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      )),
                  5.widthBox,
                  Expanded(
                    child: Obx(() {
                      return DropDown(
                        value: shoesFinalScreenController.selectedVendorData_.value,
                        items: shoesFinalScreenController.vendorData_.value ?? [],
                        onChange: (vendor) {
                          shoesFinalScreenController.onChangeVendorData(vendor);
                        },
                      );
                    }),
                  ),
                ],
              ),
              10.heightBox,
              ...shoesFinalScreenController.finalTextFieldControllers
                  .map((textFieldObj) {
                return storeConfigController.isMarshallsUSA() &&
                            textFieldObj.sboField == SBOField.uline ||
                        !storeConfigController.isMarshallsUSA() &&
                            textFieldObj.sboField == SBOField.style
                    ? SBOInputField(
                        sboFieldModel: textFieldObj)
                    : textFieldObj.sboField != SBOField.style &&
                            textFieldObj.sboField != SBOField.uline
                        ? Obx(
                            () => SBOInputField(

                                enabled: shoesFinalScreenController
                                                    .selectedVendorData_
                                                    .value !=
                                                null &&
                                            textFieldObj.sboField ==
                                                SBOField.line1 ||
                                        shoesFinalScreenController
                                                    .selectedVendorData_
                                                    .value !=
                                                null &&
                                            textFieldObj.sboField ==
                                                SBOField.line2
                                    ? false
                                    : true,
                                sboFieldModel: textFieldObj),
                          )
                        : const SizedBox.shrink();
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SBOButtonCustom(
                    title: TranslationKey.enterLabel.tr,
                    onPressed: () {
                      if (_validateSignData.currentState!.validate()) {
                        shoesFinalScreenController.finalScreenOnClickEnter(Get.arguments[1]["department"],Get.arguments[1]["uline"],Get.arguments[1]["ticketPrice"]).then((value){
                          shoesFinalScreenController.finalScreenOnClickClear();
                          shoesFrontScreenController.frontOnClickClear();
                          Get.back();
                        });
                      }
                    },
                    isEnabled: false,
                    width_: 85,
                    isAppbar: false,
                  ),
                  SBOButtonCustom(
                    title: TranslationKey.clear.tr,
                    onPressed: () {
                      shoesFinalScreenController.finalScreenOnClickClear();
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
      ),
    );
  }
}
