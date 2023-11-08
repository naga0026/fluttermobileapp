import 'dart:async';

import 'package:base_project/controller/printer/printer_list_controller.dart';
import 'package:base_project/model/printer_setup.dart';
import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/ui_controls/loading_overlay.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/navigation/navigation_service.dart';
import '../../services/printing/zebra_print_service.dart';
import '../../services/scanning/zebra_scan_service.dart';
import '../../utility/constants/app/app_constants.dart';
import '../../utility/constants/app/regular_expressions.dart';
import '../../utility/enums/status_code_enum.dart';
import '../../utility/enums/stock_type.dart';
import '../base/base_view_controller.dart';

class AddPrinterViewController extends BaseViewController {

  //region Variables
  TextEditingController ipAddress1 = TextEditingController();
  TextEditingController ipAddress2 = TextEditingController();
  TextEditingController ipAddress3 = TextEditingController();
  TextEditingController ipAddress4 = TextEditingController();
  final _zebraPrintService = Get.find<ZebraPrintService>();
  final _zebraScanService = Get.find<ZebraScanService>();
  late StreamSubscription<String> subscription;

  //endregion


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
    subscription = _zebraScanService.scannedBarcodeStreamController.stream.listen((barcode) {
      logger.d('Scanner barcode in base scanner: $barcode');
      if(barcode.contains('.') && barcode.length <= AppConstants.barcodeLengthWithDots){
        var ipTriplets = barcode.ipAddressThreeDigits;
        ipAddress1.text = ipTriplets[0];
        ipAddress2.text = ipTriplets[1];
        ipAddress3.text = ipTriplets[2];
        ipAddress4.text = ipTriplets[3];
      } else {
        NavigationService.showToast(TranslationKey.invalidBarcode.tr);
      }
    });
  }

  //region Action handlers
  void onClickClear() {
    ipAddress1.clear();
    ipAddress2.clear();
    ipAddress3.clear();
    ipAddress4.clear();
  }

  Future<void> onClickOk() async {
    var printerIP = "${ipAddress1.text}.${ipAddress2.text}.${ipAddress3.text}.${ipAddress4.text}";
    bool isValidIp = isValidIP(printerIP);
    if(isValidIp){
      LoadingOverlay.show();
      PrinterSetUp printer = PrinterSetUp(
          appId: '',
          printerId: printerIP.printerIPWithoutLeadingZero,
          printerStock: StockTypeEnum.markdown.parameterKey,
          printerDescription: "Null",
          labelLength: 0,
          separatorType: 0);

      (bool, String) printerConnectionResult = await _zebraPrintService.connectToPrinter(printer);
      if(printerConnectionResult.$1){
        await _apiCallAddPrinter(printer);
        LoadingOverlay.hide();
      } else {
        LoadingOverlay.hide();
        NavigationService.showToast(printerConnectionResult.$2);
      }
    } else {
      NavigationService.showToast(TranslationKey.invalidIpFormat.tr);
    }
  }

  bool isValidIP(String ip) {
    return RegularExpressions.printerIpRexExp.hasMatch(ip.printerIPWithoutLeadingZero);
  }

//endregion

  //region API call
  Future<void> _apiCallAddPrinter(PrinterSetUp printer) async {
    var response = await repository.addPrinter(request: printer);
    if(response?.statusCode == StatusCodeEnum.success.statusValue){
      var printerListController = Get.find<PrinterListViewController>();
      printerListController.connectedPrinters.add(printer);
      NavigationService.showToast(TranslationKey.printerConnectSuccess.tr);
      Get.back();
    } else {
      NavigationService.showToast(response?.error ?? '');
    }
  }
//endregion
}
