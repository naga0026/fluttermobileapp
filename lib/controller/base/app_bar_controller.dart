import 'package:base_project/controller/home/sgm/sgm_view_controller.dart';
import 'package:base_project/model/store_config/store_details.dart';
import 'package:get/get.dart';

import '../../view/base/widgets/app_bar.dart';
import '../printer/printer_list_controller.dart';

class AppBarController extends GetxController{

  onChangeDivision(StoreDetails storeDetails){
    final sgmViewController = Get.find<SGMViewController>();
    final printerListView = Get.find<PrinterListViewController>();

    ticketMaker.onClickClear();
    storeDivision.switchDivision(storeDetails);
    sgmViewController.selectedOrigin.value = null;
    sgmViewController.selectedReason.value = null;
    sgmViewController.onChangeDivision();
    printerListView.getStocks();
  }

}