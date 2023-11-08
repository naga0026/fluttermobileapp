
import 'package:base_project/controller/printer/printer_list_controller.dart';
import 'package:base_project/services/network/api_repository.dart';
import 'package:base_project/utility/enums/stock_type.dart';
import 'package:base_project/utility/logger/logger_config.dart';
import 'package:get/get.dart';

import '../../services/physical_response/physical_response_service.dart';


abstract class BaseViewController extends GetxController {
  final repository = APIRepository();
  final logger = LoggerConfig.initLog();
  final physicalResponseService = Get.put(PhysicalResponseService());


  bool? checkStockBeforeNavigatingToView(List<StockTypeEnum> stockList) {
    final printerListViewController = Get.find<PrinterListViewController>();
    bool? status;
    if (printerListViewController.connectedPrinters.isNotEmpty ||
        printerListViewController.connectedPrinters != []) {
      for (var printer in printerListViewController.connectedPrinters) {
        if (stockList
            .contains(printer.printerStock.getPrinterStockTypeFromString)) {
          status = true;
        } else {
          status = false;
        }
      }
    }
    return status;
  }

}
