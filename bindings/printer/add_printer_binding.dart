import 'package:base_project/controller/printer/add_printer_view_controller.dart';
import 'package:base_project/controller/printer/printer_list_controller.dart';
import 'package:get/get.dart';

class AddPrinterBinding implements Bindings {

  @override
  void dependencies() {
    Get.put(AddPrinterViewController());
    Get.put(PrinterListViewController());
  }

}