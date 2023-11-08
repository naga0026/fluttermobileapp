import 'dart:async';

import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/controller/home/ticket_maker/ticket_maker_controller.dart';
import 'package:base_project/controller/validation/validation_controller.dart';
import 'package:base_project/model/sbo_field_model.dart';
import 'package:base_project/utility/enums/sign_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/ticket_maker/ticketmaker_printer_model.dart';
import '../../../../services/navigation/navigation_service.dart';
import '../../../../services/scanning/zebra_scan_service.dart';
import '../../../../utility/enums/departmentStatus_enum.dart';
import '../../../../utility/enums/pricetype_enums.dart';
import '../../../../utility/enums/printerStatus_enum.dart';
import '../../../barcode/barcode_interpret_controller.dart';
import '../../../store_config/store_config_controller.dart';

class SignsController extends BaseViewController {
  final storeConfigController = Get.find<StoreConfigController>();
  final validationController = Get.find<ValidationController>();
  final barcodeInterpreter = Get.find<BarcodeInterpretController>();
  final tmController = Get.find<TicketMakerController>();
  String scannedData = "";
  final RxBool _isLoading = false.obs;
  final _zebraScanService = Get.find<ZebraScanService>();
  late StreamSubscription<String> subscription;
  Rx<SignTypeEnum> selectedSignButton = SignTypeEnum.vertical.obs;

  bool get isLoading => _isLoading.value;
  set setIsLoading(bool loading) {
    _isLoading.value = loading;
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
      logger.i("Scanned barcode for SIGN in TM $barcode");
      barcodeInterpreter.fillScannedBarcodeData(barcode, signControllerFields);
    });
  }

  List<SBOFieldModel> signControllerFields = [
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.department,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.category,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.style,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.price,
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
  onInit() {
    super.onInit();
    initialize();
  }

  PerformTicketMaker getTMSignDataForPrinting() {
    return PerformTicketMaker(
        department: signControllerFields
            .where((field) => field.sboField == SBOField.department)
            .first
            .textEditingController
            .text,
        category: signControllerFields
            .where((field) => field.sboField == SBOField.category)
            .first
            .textEditingController
            .text,
        price: signControllerFields
            .where((field) => field.sboField == SBOField.price)
            .first
            .textEditingController
            .text
            .replaceAll(".", ""),
        style: signControllerFields
            .where((field) => field.sboField == SBOField.style)
            .first
            .textEditingController
            .text,
        compareAt: signControllerFields
            .where((field) => field.sboField == SBOField.compareAt)
            .first
            .textEditingController
            .text,
        uline: null);
  }

  onClickEnter(SignTypeEnum type) async {
    setIsLoading = true;
    try {
      final validationStatus = await validateTMFields();
      if (validationStatus) {
        var (status, printIndex) = tmController.checkValidStockBeforePrinting();

        PerformTicketMaker printerTicketMaker = getTMSignDataForPrinting();
        if (printIndex != null &&
            status == PrinterStockStatusEnum.stockMatched) {
          tmController.printTicketMakerLabel(printIndex, printerTicketMaker);
          // final result = await repository.apiCallAddTicketMakerLog(
          //     tmController.getTicketMakerLogData(printerTicketMaker));
        }
      }
      setIsLoading = false;
    } catch (e) {
      setIsLoading = false;
      logger.e(
          "Error in Printing Ticket Maker Sign ${Get.arguments[0]} Label | Error:$e");
    }
    setIsLoading = false;
  }

  Future<bool> validateTMFields() async {
    Map<SBOField, bool> validationStatus = {};
    for (var itr in signControllerFields) {
      if (itr.textEditingController.text.isNotEmpty &&
          (itr.sboField == SBOField.department
              ? true
              : (itr.textEditingController.text.length ==
                  itr.sboField.maxLength))) {
        switch (itr.sboField) {
          case SBOField.department:
            var (status, deptValidation) = await validationController
                .validateDepartment(itr.textEditingController.text);
            if (deptValidation == DeptValidEnum.deptInvalid ||
                deptValidation == DeptValidEnum.notFound && !status) {
              validationStatus[itr.sboField] = false;
            }
          case SBOField.style:
            validationStatus[itr.sboField] =
                itr.textEditingController.text.length != itr.sboField.maxLength
                    ? false
                    : validationController
                        .validateStyle(itr.textEditingController.text);
          case SBOField.category:
            validationStatus[itr.sboField] =
                itr.textEditingController.text.length != itr.sboField.maxLength
                    ? false
                    : validationController
                        .validateCategory(itr.textEditingController.text);
          case SBOField.price || SBOField.compareAt:
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
          "The Following Inputs are Invalid, ${failedValidation.toString().replaceAll("[", "").replaceAll("]", "")}");
      return false;
    }
    return true;
  }

  onClickClear() {
    for (var e in signControllerFields) {
      if (e.sboField == SBOField.quantity) {
        e.textEditingController.text = "1";
      } else {
        e.textEditingController.clear();
      }
    }
  }
}
