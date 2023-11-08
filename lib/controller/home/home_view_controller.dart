import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/controller/home/sgm/sgm_view_controller.dart';
import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:base_project/utility/enums/app_name_enum.dart';
import 'package:get/get.dart';

import '../login/user_management.dart';

class HomeViewController extends BaseViewController {
  final userManagementController = Get.find<UserManagementController>();
  final storeConfigController = Get.find<StoreConfigController>();

  List<AppNameEnum> appNamesConst = [
    AppNameEnum.markdowns,
    AppNameEnum.sgm,
    AppNameEnum.ticketMaker,
    AppNameEnum.transfers,
    AppNameEnum.returnItemLookup,
    AppNameEnum.recallTracking
  ];

  List<AppNameEnum> scannerAccess = [
    AppNameEnum.markdowns,
    AppNameEnum.ticketMaker,
  ];

  RxList<AppNameEnum> appNames = <AppNameEnum>[].obs;
  RxInt currentTabIndex = 0.obs;


  checkAccessToApp() {
    for (AppNameEnum name in appNamesConst) {
      if (userManagementController.userHasAccessToAppAsync(name)) {
        if(storeConfigController.isEurope.value){
          if(name==AppNameEnum.recallTracking||name==AppNameEnum.returnItemLookup){
            continue;
          }else{
            appNames.add(name);
          }
        }else{
          appNames.add(name);
        }
      }
    }
  }

  void onTabChange() {
    final sgmC = Get.find<SGMViewController>();
    sgmC.selectedOrigin.value=null;
  }
}
