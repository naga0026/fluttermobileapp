import 'dart:async';
import 'dart:io';

import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/controller/initial_view_controller.dart';
import 'package:base_project/controller/login/user_management.dart';
import 'package:base_project/controller/read_configuration/read_config_files__controller.dart';
import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:base_project/model/store_config/store_details.dart';
import 'package:base_project/services/caching/caching_service.dart';
import 'package:base_project/services/config/config_service.dart';
import 'package:base_project/services/encryption/encryption_service.dart';
import 'package:base_project/services/navigation/navigation_service.dart';
import 'package:base_project/services/navigation/routes/route_names.dart';
import 'package:base_project/services/network/network_service.dart';
import 'package:base_project/services/shared_preference/shared_preference_service.dart';
import 'package:base_project/ui_controls/loading_overlay.dart';
import 'package:base_project/utility/constants/app/regular_expressions.dart';
import 'package:base_project/utility/constants/custom_dialog/custom_dialogsCLS.dart';
import 'package:base_project/utility/enums/login_status.dart';
import 'package:base_project/utility/enums/status_code_enum.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/api_request/login_request.dart';
import '../../model/api_response/login_response.dart';
import '../../services/database/database_service.dart';
import '../../translations/translation_keys.dart';
import '../../utility/constants/colors/color_constants.dart';
import '../../utility/constants/images_and_icons/icon_constants.dart';

class LoginViewController extends BaseViewController {
  final username = ''.obs;
  final password = ''.obs;
  final isLoginEnabled = false.obs;
  final loginStatus = LoginStatus.unknown.obs;
  static const credentialLength = 4;
  RxString ipBaseUrl = ''.obs;
  LoginData? loginResponse;

  EncryptionService encryptionService = EncryptionService();
  final userManagement = Get.put(UserManagementController(), permanent: true);
  final sharedPref = Get.find<SharedPreferenceService>();
  final initialController = Get.find<InitialController>();
  final readingConfigFile = Get.find<ReadConfigFileController>();
  final configFileService = Get.find<ConfigService>();
  final storeConfigController = Get.find<StoreConfigController>();
  final databaseService = Get.find<DatabaseService>();
  final networkService = Get.find<NetworkService>();
  var isConnectedToNetwork = true.obs;

  TextEditingController ipConnectionAddController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController remoteConnectionAddController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (readingConfigFile.appBaseURL!.ipAddress != null) {
      ipConnectionAddController.text = readingConfigFile.appBaseURL!.ipAddress!;
    }
    isConnectedToNetwork.value = networkService.isConnectedToNetwork;

  }

  remoteSwitchController() {
    storeConfigController.resetStoreConfigData();
    initialController.isRemoteEnabled.value =
        !initialController.isRemoteEnabled.value;
  }

  Future<void> checkStoreConfigWithIp() async {
    storeConfigController.resetStoreConfigData();
    final String ipAddress = ipConnectionAddController.text;
    if (RegularExpressions.ipAddressPattern.hasMatch(ipAddress)) {
      LoadingOverlay.show();
      final res = await repository.getStoreConfigData(true, ipAddress);
      LoadingOverlay.hide();
      if (res != null && res.divisions.divid.isNotEmpty) {
        LoadingOverlay.hide();
        await storeConfigController.getStoreConfigData();
        initialController.setSharedPrefInstructions();
        await configFileService.rewriteExistingFileAppBaseUrl(ipAddress).then(
            (value) async => await readingConfigFile
                .setDataToModels()
                .then((value) => NavigationService.showToast("Configured and Connected")));
      } else {
        LoadingOverlay.hide();
        logger.e(
            "There is an Error while checking in method - checkStoreConfigWithIp() $res");
        CustomDialog.showErrorDialog();
      }
    } else {
      await CustomDialog.showInvalidIPFormatDialog();
    }
    return;
  }

  void validateLogIn() {
    isLoginEnabled.value = username.isNotEmpty &&
        username.value.length == credentialLength &&
        password.value.length == credentialLength &&
        password.isNotEmpty;
  }

  Future<LoginResponse> apiCallLogin(
      {required String username, required String encryptedPassword}) async {
    LoginRequest loginRequest =
        LoginRequest(userId: username, password: encryptedPassword);
    LoginResponse response = await repository.login(request: loginRequest);
    if (response.status == StatusCodeEnum.success.statusValue) {
      logger.i("authenticating user | CHECKING STATUS-CODE-200");
      return response;
    } else {
      logger.e(
          "Error while authenticating the user from method authenticateUser() and Responded code is ${response.status} and the ERROR is ${response.message}");
      return response;
    }
  }

  Future<void> onClickLogin() async {
    if (checkCredential()) {
      if (storeConfigController.selectedDivision.isNotEmpty &&
          storeConfigController.selectedStoreNumber.isNotEmpty) {
        String encryptedPass =
        encryptionService.encryptUserPassword(password.value);
        loginResponse = await apiCallLogin(
            username: username.value, encryptedPassword: encryptedPass)
            .then((value) async {
            if (value.status == StatusCodeEnum.success.statusValue) {
              loginStatus.value = getStatus(value);
              if (loginStatus.value == LoginStatus.success) {
                if (value.data?.responseCode == LoginStatusInt.success.rawValue) {
                  await userManagement.setUserData(value.data);
                  await checkAndMarkDivision();
                }
              } else {
                _clearFields();
                isLoginEnabled.value = false;
                CustomDialog.showInvalidLoginDialog();
              }
            }
            return null;
        });
      } else {
        var _ = await storeConfigController.getStoreConfigData();
        onClickLogin();
      }
    } else {
      LoadingOverlay.hide();
      CustomDialog.showInvalidLoginDialog();
    }
  }

  getStatus(value) {
    return switch (value.data?.responseCode) {
      0 => LoginStatus.unknown,
      1 => LoginStatus.success,
      2 => LoginStatus.accessLocked,
      3 => LoginStatus.passwordIncorrect,
      4 => LoginStatus.passwordExpired,
      _ => LoginStatus.unknown
    };
  }

  checkCredential() {
    if (username.value.isNum &&
        username.value.isNotEmpty &&
        username.value.length == credentialLength &&
        !username.value.contains(".") &&
        password.value.isNum &&
        password.value.isNotEmpty &&
        password.value.length == credentialLength &&
        !password.value.contains(".")) {
      return true;
    }
    return false;
  }

  _clearFields() {
    usernameController.clear();
    passwordController.clear();
    username.value = '';
    password.value = '';
  }

  void navigateToMainTabView() async {
    await initialController.setSharedPrefInstructions();
    // Once store configuration is loaded and division selected, start caching service to cache data based on store details
    Get.put(CachingService());
    Get.offAllNamed(RouteNames.tabPage);
  }

  Future<void> checkAndMarkDivision() async {
    return storeConfigController.isMega
        ? await Get.dialog(
            barrierDismissible: false,
            WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white,
                  alignment: Alignment.center,
                  title: IconConstants.alertBellIcon,
                  content: Obx(
                    () {
                      StoreDetails groupValue = storeConfigController
                          .selectedStoreDetails.value!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            TranslationKey.selectDivision.tr,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          5.heightBox,
                          RadioListTile<StoreDetails>(
                              title: Text(
                                  "${storeConfigController.firstMegaStoreDetails?.storeName}"),
                              value: storeConfigController.firstMegaStoreDetails!,
                              groupValue: groupValue,
                              onChanged: (value) {
                                storeConfigController.switchDivision(value!);
                              }),
                          RadioListTile<StoreDetails>(
                              title: Text(
                                  "${storeConfigController.secondMegaStoreDetails?.storeName}"),
                              value: storeConfigController.secondMegaStoreDetails!,
                              groupValue: groupValue,
                              onChanged: (value) {
                                storeConfigController.switchDivision(value!);
                              }),
                        ],
                      );
                    },
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        navigateToMainTabView();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: ColorConstants.primaryRedColor),
                      child: Text(
                        TranslationKey.done.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )))
        : navigateToMainTabView();
  }

  onSwitchConnection() async {
    // LoadingOverlay.show();
    storeConfigController.resetStoreConfigData();
    if(initialController.isRemoteEnabled.value){
      LoadingOverlay.show();
      await storeConfigController.getStoreConfigData().then((value) => Get.back());
      LoadingOverlay.hide();
    } else {
      await checkStoreConfigWithIp().then((value) => Get.back());
    }
  }

  Future<void> onLogOut() async {
    LoadingOverlay.show();
    storeConfigController.resetStoreConfigData();
    userManagement.restartUserManagement();
    // Delete caching service, It will again reinitialize when user successfully logs in
    Get.delete<CachingService>(force: true);
    await sharedPref.clearCache().then((value) =>
        Future.delayed(const Duration(seconds: 1))
            .then((value) => Get.offAllNamed(RouteNames.loginPage)));
    LoadingOverlay.hide();
  }
}
