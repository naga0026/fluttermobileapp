import 'package:base_project/controller/home/home_view_controller.dart';
import 'package:base_project/controller/printer/printer_list_controller.dart';
import 'package:base_project/controller/tab/main_tab_controller.dart';
import 'package:get/get.dart';

import '../../controller/barcode/barcode_interpret_controller.dart';
import '../../controller/home/init_subs/init_subs_view_controller.dart';

class MainTabBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<MainTabController>(() => MainTabController());
    Get.lazyPut<HomeViewController>(() => HomeViewController());
    Get.put(PrinterListViewController());
    Get.lazyPut<BarcodeInterpretController>(() => BarcodeInterpretController());
    Get.lazyPut<InitSubsViewController>(() => InitSubsViewController());
  }

}