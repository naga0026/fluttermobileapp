import 'dart:async';

import 'package:base_project/controller/validation/validation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/sbo_field_model.dart';
import '../../../../services/navigation/navigation_service.dart';
import '../../../../services/navigation/routes/route_names.dart';
import '../../../../services/scanning/zebra_scan_service.dart';
import '../../../../translations/translation_keys.dart';
import '../../../../utility/enums/departmentStatus_enum.dart';
import '../../../../utility/enums/pricetype_enums.dart';
import '../../../barcode/barcode_interpret_controller.dart';
import '../../../base/base_view_controller.dart';

class ShoesFrontScreenController extends BaseViewController {
  final validationController = Get.find<ValidationController>();
  final _zebraScanService = Get.find<ZebraScanService>();
  late StreamSubscription<String> subscription;
  final barcodeInterpreter = Get.find<BarcodeInterpretController>();
  String scannedData = "";

  List<SBOFieldModel> frontTextFieldControllers = [
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.department,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.uline,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.ticketPrice,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
  }

  void initialize() {
    subscription = _zebraScanService.scannedBarcodeStreamController.stream
        .listen((barcode) {
      scannedData = barcode;
      logger.i("Scanned barcode for Shoes in TM $barcode");
      barcodeInterpreter.fillScannedBarcodeData(
          barcode, frontTextFieldControllers);
    });
  }

  var selectedVendorData_ = Rxn<String>();
  Rxn<List<String>> vendorData_ = Rxn<List<String>>();

  void frontOnClickClear() {
    for (var fields in frontTextFieldControllers) {
      fields.textEditingController.clear();
    }
  }

  Future<bool> validateFrontShoesFields() async {
    Map<SBOField, bool> validationStatus = {};
    for (var itr in frontTextFieldControllers) {
      if (itr.textEditingController.text.isNotEmpty) {
        switch (itr.sboField) {
          case SBOField.department:
            var (status, deptValidation) = await validationController
                .validateDepartment(itr.textEditingController.text);
            if (deptValidation == DeptValidEnum.deptInvalid ||
                deptValidation == DeptValidEnum.notFound && !status) {
              validationStatus[itr.sboField] = false;
            }
          case SBOField.uline:
            validationStatus[itr.sboField] =
                itr.textEditingController.text.length != itr.sboField.maxLength
                    ? false
                    : validationController
                        .validateUline(itr.textEditingController.text);
          case SBOField.ticketPrice:
            validationStatus[itr.sboField] = validationController.validatePrice(
                itr.textEditingController.text, PriceTypeEnum.initial);
          default:
            break;
        }
      }
    }
    List failedValidation = [];
    validationStatus.forEach((key, value) {
      if (!value) {
        failedValidation.add(key.name);
      }
    });
    if (failedValidation.isNotEmpty) {
      NavigationService.showToast(
          "${TranslationKey.invalidInputValidation.tr}, ${failedValidation.toString().replaceAll("[", "").replaceAll("]", "")}");
      return false;
    }
    return true;
  }

  void frontOnClickEnter(String labelName) async {
    final validationStatus = await validateFrontShoesFields();
    if (validationStatus) {
      final tktPrice = frontTextFieldControllers
          .where((field) => field.sboField == SBOField.ticketPrice)
          .first
          .textEditingController
          .text;
      final depart = frontTextFieldControllers
          .where((field) => field.sboField == SBOField.department)
          .first
          .textEditingController
          .text;
      final uline = frontTextFieldControllers
          .where((field) => field.sboField == SBOField.uline)
          .first
          .textEditingController
          .text;
      Get.toNamed(RouteNames.shoesFinalScreen, arguments: [
        labelName,
        {"department": depart, "ticketPrice": tktPrice, "uline": uline}
      ]);
    }
  }
}
