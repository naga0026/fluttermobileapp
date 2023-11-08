import 'package:base_project/controller/printer/printer_list_controller.dart';
import 'package:get/get.dart';

class PrinterBinding implements Bindings {

  @override
  void dependencies() {
    Get.put(PrinterListViewController());
  }

}