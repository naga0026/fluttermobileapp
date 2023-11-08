import 'package:base_project/utility/enums/access_right_enum.dart';
import 'package:base_project/utility/enums/app_name_enum.dart';
import 'package:get/get.dart';

import '../../model/api_response/login_response.dart';
import '../base/base_view_controller.dart';
import '../store_config/store_config_controller.dart';

class UserManagementController extends BaseViewController {
  LoginData? userData;
  String? getDivision;
  List<Map<AppNameEnum, AppAccessRightEnum>> userAccess = [];
  final storeConfigController = Get.find<StoreConfigController>();
  RxInt divisionLength = 0.obs;
  List<Division> divisionData = [];

  @override
  onInit(){
    super.onInit();
    restartUserManagement();
  }


  setUserData(data) {
    if (data != null) {
      userData = data;
      divisionLength.value = userData!.data!.divisions.length;
      arrangeAndSetUserAccessData();
    }
  }

  arrangeAndSetUserAccessData() {
    for (var data in userData!.data!.divisions) {
      divisionData.add(data);
      for (UserApp userApp in data.userApps) {
        AppNameEnum appName = getAppName(userApp.appName);
        AppAccessRightEnum appAccessRightEnum =
        getAppAccessRight(userApp.appAccessRight);
        Map<AppNameEnum,AppAccessRightEnum> uAccess = {appName:appAccessRightEnum};
        userAccess.add(uAccess);
      }
    }
  }

  AppNameEnum getAppName(int appName) {
    return switch (appName) {
      0 => AppNameEnum.markdowns,
      1 => AppNameEnum.sgm,
      2 => AppNameEnum.ticketMaker,
      3 => AppNameEnum.transfers,
      4 => AppNameEnum.returnItemLookup,
      5 => AppNameEnum.recallTracking,
      6 => AppNameEnum.userMgmt,
      7 => AppNameEnum.supplyReq,
      8 => AppNameEnum.flashSales,
      9 => AppNameEnum.pos,
      10 => AppNameEnum.password,
      11 => AppNameEnum.cashOffice,
      12 => AppNameEnum.shoes,
      _ => AppNameEnum.markdowns
    };
  }

  setDivision(String divisionCode) {
    return switch (divisionCode) {
      "04" => "WinnersCanadaOrMarshallsCanada",
      "05" => "TkMaxxEuropeUk",
      "08" => "TjMaxxUsa",
      "10" => "MarshallsUsa",
      "24" => "HomeSenseCanada",
      "28" => "HomeGoodsUsaOrHomeSenseUsa",
      "55" => "TkMaxxEuropeOther",
      _ => "Null"
    };
  }

  Map<AppNameEnum, AppAccessRightEnum> getAppAccessRightFromAppName(AppNameEnum appName_) {
    return userAccess.firstWhere((element) => element.containsKey(appName_),orElse: ()=>{});
  }

  bool userHasAccessToAppAsync(AppNameEnum appName) {
    AppAccessRightEnum? appAccessRight = getAppAccessRightFromAppName(appName)[appName];
    return switch (appName) {
      AppNameEnum.markdowns => appAccessRight ==
          AppAccessRightEnum.mdAssociateOrCoordinatorOrLevel2 ||
          appAccessRight == AppAccessRightEnum.coordinatorOrLpStoreDetective ||
          appAccessRight ==
              AppAccessRightEnum
                  .mluOnlyOrMdAssociateOrAssociateOrLevel1OrLookup ||
          appAccessRight == AppAccessRightEnum.managerOrFullAccessRights,
      AppNameEnum.sgm => appAccessRight ==
          AppAccessRightEnum.mdAssociateOrCoordinatorOrLevel2 ||
          appAccessRight == AppAccessRightEnum.coordinatorOrLpStoreDetective ||
          appAccessRight ==
              AppAccessRightEnum
                  .mluOnlyOrMdAssociateOrAssociateOrLevel1OrLookup ||
          appAccessRight == AppAccessRightEnum.managerOrFullAccessRights,
      AppNameEnum.ticketMaker => appAccessRight ==
          AppAccessRightEnum.mdAssociateOrCoordinatorOrLevel2 ||
          appAccessRight == AppAccessRightEnum.coordinatorOrLpStoreDetective ||
          appAccessRight ==
              AppAccessRightEnum
                  .mluOnlyOrMdAssociateOrAssociateOrLevel1OrLookup ||
          appAccessRight == AppAccessRightEnum.managerOrFullAccessRights,
      AppNameEnum.transfers => appAccessRight ==
          AppAccessRightEnum.mdAssociateOrCoordinatorOrLevel2 ||
          appAccessRight == AppAccessRightEnum.coordinatorOrLpStoreDetective ||
          appAccessRight ==
              AppAccessRightEnum
                  .mluOnlyOrMdAssociateOrAssociateOrLevel1OrLookup ||
          appAccessRight == AppAccessRightEnum.managerOrFullAccessRights,
      AppNameEnum.returnItemLookup => appAccessRight ==
          AppAccessRightEnum.mdAssociateOrCoordinatorOrLevel2 ||
          appAccessRight == AppAccessRightEnum.coordinatorOrLpStoreDetective ||
          appAccessRight ==
              AppAccessRightEnum
                  .mluOnlyOrMdAssociateOrAssociateOrLevel1OrLookup ||
          appAccessRight == AppAccessRightEnum.managerOrFullAccessRights,
      AppNameEnum.recallTracking => appAccessRight ==
          AppAccessRightEnum.mdAssociateOrCoordinatorOrLevel2 ||
          appAccessRight == AppAccessRightEnum.coordinatorOrLpStoreDetective ||
          appAccessRight ==
              AppAccessRightEnum
                  .mluOnlyOrMdAssociateOrAssociateOrLevel1OrLookup ||
          appAccessRight == AppAccessRightEnum.managerOrFullAccessRights,
      AppNameEnum.userMgmt => false,
      AppNameEnum.supplyReq => false,
      AppNameEnum.flashSales => false,
      AppNameEnum.pos => false,
      AppNameEnum.password => false,
      AppNameEnum.language => false,
      _ => false
    };
  }

  AppAccessRightEnum getAppAccessRight(int appAccessRight) {
    return switch (appAccessRight) {
      0 => AppAccessRightEnum.noAccessRights,
      1 => AppAccessRightEnum.mluOnlyOrMdAssociateOrAssociateOrLevel1OrLookup,
      2 => AppAccessRightEnum.mdAssociateOrCoordinatorOrLevel2,
      3 => AppAccessRightEnum.coordinatorOrLpStoreDetective,
      5 => AppAccessRightEnum.lpStoreDetectiveOrWebAccess,
      8 => AppAccessRightEnum.managerOrFullAccessRights,
      9 => AppAccessRightEnum.specialAccessRights,
      _ => AppAccessRightEnum.noAccessRights
    };
  }


  List<UserApp>? getUserRolesForApp(AppNameEnum appName) {
    final userRoles = storeConfigController.isMega
        ? getDivisionSpecificUserRoles()
        : getComboStoreUserRoles();
    return userRoles;
  }

  List<UserApp>? getComboStoreUserRoles() {
    if (divisionData.isEmpty) {
      logger.d("There are no user roles defined.");
    }
    return divisionData[0].userApps;
  }

  List<UserApp>? getDivisionSpecificUserRoles() {
    final primaryDivision = storeConfigController.selectedDivision;
    final divisionSpecificRole = divisionData
        .where((element) => element.code == primaryDivision)
        .toList();
    if (divisionSpecificRole.isEmpty) {
      logger.d("There are no user roles defined for given division.");
      return null;
    }
    return divisionSpecificRole.first.userApps;
  }

  void restartUserManagement(){
     userData = null;
   getDivision = null;
    userAccess = [];
    divisionLength = 0.obs;
    divisionData = [];
  }

  String get currentUserId {
    return userData?.data?.userId ?? '';
  }

}