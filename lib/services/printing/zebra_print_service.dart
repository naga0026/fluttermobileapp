import 'package:base_project/model/printer/printer_calibration.dart';
import 'package:base_project/services/printing/stock_type_service.dart';
import 'package:base_project/utility/constants/app/platform_channel_constants.dart';
import 'package:base_project/utility/logger/logger_config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../model/printer_setup.dart';
import '../../translations/translation_keys.dart';
import '../../utility/constants/images_and_icons/icon_constants.dart';
import '../../utility/enums/stock_type.dart';
import '../navigation/navigation_service.dart';
import '../physical_response/physical_response_service.dart';
import 'model/print_label_model.dart';
import 'model/printer_status.dart';

/// This service is used to connect to the printer and print labels.
/// Handled printer related activities in this class
class ZebraPrintService extends GetxService {

  //region Variables
  List<PrinterSetUp> connectedPrinters = [];
  final methodChannel = PlatformChannelConstants.sboPrintMethodChannel;

//endregion

  //region Connect/Disconnect Printer
  Future<(bool, String)> connectToPrinter(PrinterSetUp printer) async {
    bool isPrinterConnected = false;
    String connectionMessage = "";
    if (connectedPrinters.length < 3) {
      try {
        var isConnected = await methodChannel.invokeMethod(
            "connectToPrinterWithIP", printer.toJsonForDB());
        if (isConnected) {
          connectedPrinters.add(printer);
          isPrinterConnected = true;
          LoggerConfig.logger.d("Printer with ip ${printer.printerId} is connected.");
        }
      } on PlatformException catch (e) {
        connectionMessage = TranslationKey.printerUnAvailable.tr;
        LoggerConfig.logger.e("Error connecting to the printer platform exception ${e.toString()}");
      }
      catch (e) {
        connectionMessage = TranslationKey.printerUnAvailable.tr;//e.toString();
        LoggerConfig.logger.e("Error connecting to the printer ${e.toString()}");
      }
    }
    return (isPrinterConnected, connectionMessage);
  }

  Future<bool?> disconnect(PrinterSetUp printer) async {
    try {
      var isDisconnected = await methodChannel.invokeMethod("disconnect", printer.toJsonForDB());
      connectedPrinters.remove(printer);
      return isDisconnected;
    } catch (e) {
      LoggerConfig.logger.e("Error disconnecting the printer ${e.toString()}");
    }
    return null;
  }

//endregion

  //region Print label
  Future<void> printLabel(PrintLabelModel printingDetails) async {
    final physicalResponseService = Get.find<PhysicalResponseService>();
    physicalResponseService.s1Beep();
    try {
      var response = await methodChannel.invokeMethod("printLabel", printingDetails.toJson());
      LoggerConfig.logger.d('Print response $response');
    } on PlatformException catch (e) {
      if(e.code == 'PRINTER_ERROR') {
        if(e.message == PrinterStatus.isHeadOpen.rawValue){
          LoggerConfig.logger.e("Error connecting to the printer reason: PRINTER HEAD IS OPEN");
          showError(TranslationKey.printerHeadOpen.tr);
        } else if (e.message == PrinterStatus.isPaused.rawValue) {
          LoggerConfig.logger.e("Error connecting to the printer reason: PRINTER IS PAUSED");
          showError(TranslationKey.printerPaused.tr);
        } else if (e.message == PrinterStatus.isPaperOut.rawValue) {
          LoggerConfig.logger.e("Error connecting to the printer reason: PRINTER RAN OUT OF PAPER");
          showError(TranslationKey.printerOutOfPaper.tr);
        }
      }
    } catch (error) {
      LoggerConfig.logger.e("Error connecting to the printer ${error.toString()}");
      showError(TranslationKey.printerUnknownError.tr);
    }
  }
//endregion

  PrinterSetUp? getPrinterForStockType(StockTypeEnum stockType) {
    var availablePrinter = connectedPrinters.firstWhereOrNull(
            (element) => element.printerStock == stockType.parameterKey);
    return availablePrinter;
  }

  showError(String subtitle){
    NavigationService.showDialog(
        subtitle: subtitle,
        title: TranslationKey.error.tr,
        buttonCallBack: ()=> Get.back(),
        icon: IconConstants.failedIcon);
  }

  Future<void> calibratePrinter(PrinterSetUp currentPrinter) async {
    LoggerConfig.logger.d("Calibrating printer to ${currentPrinter.printerStock}");
    final stockTypeService = Get.find<StockTypeService>();
    StockTypeEnum stockType = currentPrinter.printerStock.stock; // _stockService.GetStockEnumCode(currentPrinter.printerStock);
    var labelLength = stockTypeService.getLabelLength(stockType);
    var separatorCommand = stockTypeService.getSeparatorCommand();

    var commands = [
      "^XA",
      "^LL$labelLength",
      "^$separatorCommand",
      "^XZ",
      "! U1 do \"zpl.calibrate\" \"now\""
    ];

    var labelDefinitionString = '';
    for (var element in commands) {
      labelDefinitionString = labelDefinitionString.isNotEmpty ? '$labelDefinitionString\n$element' : element;
    }
    PrinterCalibrationModel printerCalibrationModel = PrinterCalibrationModel(
        printerIp: currentPrinter.printerId,
        command: labelDefinitionString);
    try {
      var response = await methodChannel.invokeMethod("calibrate_printer", printerCalibrationModel.toJson());
      LoggerConfig.logger.d('Print response $response');
    } on PlatformException catch (e) {
      LoggerConfig.logger.e("Error writing calibration commands to the printer ${e.toString()}");
    } catch (error) {
      LoggerConfig.logger.e("Error writing calibration commands to the printer ${error.toString()}");
      showError(TranslationKey.printerUnknownError.tr);
    }
  }
}