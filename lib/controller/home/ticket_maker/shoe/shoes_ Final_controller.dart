import 'dart:async';

import 'package:base_project/controller/home/ticket_maker/ticket_maker_controller.dart';
import 'package:base_project/controller/validation/validation_controller.dart';
import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/utility/constants/custom_dialog/custom_dialogsCLS.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/sbo_field_model.dart';
import '../../../../model/ticket_maker/ticketmaker_printer_model.dart';
import '../../../../services/navigation/navigation_service.dart';
import '../../../../services/scanning/zebra_scan_service.dart';
import '../../../../utility/enums/pricetype_enums.dart';
import '../../../../utility/enums/status_code_enum.dart';
import '../../../barcode/barcode_interpret_controller.dart';
import '../../../base/base_view_controller.dart';

class ShoesFinalScreenController extends BaseViewController {
  final validationController = Get.find<ValidationController>();
  final _zebraScanService = Get.find<ZebraScanService>();
  late StreamSubscription<String> subscription;
  final barcodeInterpreter = Get.find<BarcodeInterpretController>();
  final tMakerController = Get.find<TicketMakerController>();
  String scannedData = "";

  List<SBOFieldModel> finalTextFieldControllers = [
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.line1,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.line2,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.ourPrice,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.compareAt,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.quantity,
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
          barcode, finalTextFieldControllers);
    });
  }

  var selectedVendorData_ = Rxn<String>();
  Rxn<List<String>> vendorData_ = Rxn<List<String>>();

  getVendorData() async {
    vendorData_.value = null;
    final vData = await repository.getTMVendorData();
    if (vData.status == StatusCodeEnum.success.statusValue) {
      vendorData_.value = vData.data.toSet().toList();
    }
  }

  TextEditingController getOurPriceController() => finalTextFieldControllers
      .where((field) => field.sboField == SBOField.ourPrice)
      .first
      .textEditingController;

  Future<bool> validateFinalShoesFields() async {
    Map<SBOField, bool> validationStatus = {};
    for (var itr in finalTextFieldControllers) {
      if (itr.textEditingController.text.isNotEmpty) {
        switch (itr.sboField) {
          case SBOField.ourPrice || SBOField.compareAt:
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
          "${TranslationKey.invalidInputValidation.tr} ${failedValidation.toString().replaceAll("[", "").replaceAll("]", "")}");
      return false;
    }
    return true;
  }

  Future<void> finalScreenOnClickEnter(String dept, uline, ticketPrice) async {
    tMakerController.fromShoes.value = true;
    final validationStatus = await validateFinalShoesFields();
    if (validationStatus) {
      var (_, printIndex) =
          tMakerController.checkValidStockBeforePrinting();
      if (printIndex != null) {
        tMakerController.printTicketMakerLabel(
            printIndex,
            PerformTicketMaker(
                department: dept,
                category: "00",
                line1: selectedVendorData_.value ??
                    finalTextFieldControllers
                        .where((field) => field.sboField == SBOField.line1)
                        .first
                        .textEditingController
                        .text,
                line2: selectedVendorData_.value != null
                    ? ""
                    : finalTextFieldControllers
                        .where((field) => field.sboField == SBOField.line2)
                        .first
                        .textEditingController
                        .text,
                compareAt: finalTextFieldControllers
                    .where((field) => field.sboField == SBOField.compareAt)
                    .first
                    .textEditingController
                    .text
                    .replaceAll(".", ""),
                price: finalTextFieldControllers
                            .where(
                                (field) => field.sboField == SBOField.compareAt)
                            .first
                            .textEditingController
                            .text !=
                        ticketPrice
                    ? finalTextFieldControllers
                        .where((field) => field.sboField == SBOField.ourPrice)
                        .first
                        .textEditingController
                        .text
                        .replaceAll(".", "")
                    : ticketPrice.replaceAll(".", ""),
                uline: uline,
                YAline: getYAlineWithRespectToPrice(),
                style: ""));
      } else {
        CustomDialog.showStockMismatchDialog();
      }
    }
    tMakerController.fromShoes.value = false;

  }

  void onChangeVendorData(String vendor) {
    selectedVendorData_.value = vendor;
  }

  String getYAlineWithRespectToPrice() {
    String price = finalTextFieldControllers
        .where((fields) => fields.sboField == SBOField.ourPrice)
        .first
        .textEditingController
        .text;
    return switch (price.replaceAll(".", "").length) {
      3 => "670",
      4 => "690",
      5 => "710",
      6 => "730",
      _ => "700"
    };
  }

  void finalScreenOnClickClear() {
    selectedVendorData_.value=null;
    for (var e in finalTextFieldControllers) {
      if (e.sboField == SBOField.quantity) {
        e.textEditingController.text = "1";
      } else {
        e.textEditingController.clear();
      }
    }
  }
}
