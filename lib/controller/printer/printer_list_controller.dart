import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/model/printer_setup.dart';
import 'package:base_project/services/printing/stock_type_service.dart';
import 'package:base_project/services/printing/zebra_print_service.dart';
import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:get/get.dart';

import '../../model/api_request/update_stock_request.dart';
import '../../model/api_response/get_printer_response.dart';
import '../../services/navigation/navigation_service.dart';
import '../../utility/enums/status_code_enum.dart';
import '../../utility/enums/stock_type.dart';

class PrinterListViewController extends BaseViewController {

  //region Variables and initializer
  var connectedPrinters = <PrinterSetUp>[].obs;
  final _printerService = Get.find<ZebraPrintService>();
  final _stockTypeService = Get.find<StockTypeService>();
  RxList<StockTypeEnum> stocks = <StockTypeEnum>[].obs;
  Rx<StockTypeEnum> selectedStock = StockTypeEnum.markdown.obs;

  @override
  onInit() {
    super.onInit();
    apiCallGetPreviousPrinters();
    getStocks();
  }
  //endregion

  //region Connect and remove printers
  Future<void> removePrinter(PrinterSetUp printer) async {
    var result = await _printerService.disconnect(printer);
    if(result == true){
      apiCallUnAssignPrinter(printer);
    } else {
      NavigationService.showToast(TranslationKey.errorPrinterDisconnect.tr);
    }
  }

  Future<void> connectToPrinter(List<PrinterSetUp> printers) async {
    printers.removeWhere((element) => element.printerStock.isEmpty);
    for (var printer in printers) {
     (bool, String) printerConnectionResult = await _printerService.connectToPrinter(printer);
     if(printerConnectionResult.$1){
       _printerService.calibratePrinter(printer);
        connectedPrinters.add(printer);
     }
    }
  }
  //endregion

  //region Helper functions
  void getStocks() {
   List<StockTypeEnum> availableStocks =  _stockTypeService.updateStockTypes();
   stocks.value = availableStocks;
  }

  Future<void> updateSelectedStock({required StockTypeEnum stock, required PrinterSetUp printer}) async {
    await apiCallUpdateStock(printer, stock);
  }

  String getStockType(String stock) {
    var stockType = _stockTypeService.getStockTypeFromString(stock);
    return stockType.rawValue;
  }
  //endregion

  //region API Calls
  Future<void> apiCallUnAssignPrinter(PrinterSetUp printer) async {
    var result = await repository.unAssignPrinter(request: printer);
    if(result?.statusCode == StatusCodeEnum.success.statusValue) {
      connectedPrinters.remove(printer);
      NavigationService.showToast(TranslationKey.printerUnassigned.tr);
    } else {
      NavigationService.showToast(result?.error ?? 'Error');
    }
  }

  Future<void> apiCallGetPreviousPrinters() async {
    GetPrinterResponse result = await repository.getAssignedPrinters();
    if(result.status == StatusCodeEnum.success.statusValue){
      var previousPrinters = result.assignedPrinters ?? [];
      if (previousPrinters.isNotEmpty) connectToPrinter(previousPrinters);
    } else {
      NavigationService.showToast(result.error ?? 'Error');
    }
  }

  Future<void> apiCallUpdateStock(PrinterSetUp printer, StockTypeEnum newStock) async {
    var objToUpdate = connectedPrinters.firstWhere((element) => element.printerId == printer.printerId);
    var updatedStockType = newStock.parameterKey;
    var updatedLabelLength = int.tryParse(_stockTypeService.getLabelLength(newStock)) ?? 0;
    var updatedSeparatorType = _stockTypeService.getSeparatorType().rawValue;
    UpdateStockRequest request = UpdateStockRequest(
        separatorType: updatedSeparatorType,
        stockType: updatedStockType, labelLength: updatedLabelLength, printerId: printer.printerId.printerIPWithoutLeadingZero);

    var result = await repository.updatePrinterStock(request: request);
    if(result?.statusCode == StatusCodeEnum.success.statusValue) {
      objToUpdate.labelLength = updatedLabelLength;
      objToUpdate.separatorType = updatedSeparatorType;
      objToUpdate.printerStock = updatedStockType;
      var indexToUpdate = connectedPrinters.indexOf(printer);
      connectedPrinters[indexToUpdate] = objToUpdate;
      selectedStock.value = newStock;
      _printerService.calibratePrinter(printer);
    } else {
      NavigationService.showToast(result?.error ?? 'Error');
    }
  }

//endregion
}