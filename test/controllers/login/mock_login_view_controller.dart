import 'package:base_project/controller/login/login_view_controller.dart';
import 'package:base_project/model/api_request/login_request.dart';
import 'package:base_project/model/api_response/login_response.dart';
import 'package:base_project/services/encryption/encryption_service.dart';
import 'package:base_project/services/navigation/routes/route_names.dart';
import 'package:base_project/ui_controls/loading_overlay.dart';
import 'package:base_project/utility/constants/app/regular_expressions.dart';
import 'package:base_project/utility/enums/login_status.dart';
import 'package:base_project/utility/enums/status_code_enum.dart';
import 'package:base_project/utility/logger/logger_config.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mock_api_repository.dart';
import '../initial_controller/mock_initial_controller.dart';
import '../read/mock_read_config_controller.dart';

class MockLoginViewController extends GetxController with Mock implements LoginViewController{


  @override
  final loginStatus = LoginStatus.unknown.obs;
  static const credentialLength = 4;
  @override
  RxString ipBaseUrl = ''.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  // }


  @override
  final initialController = Get.find<MockInitialController>();
  @override
  final readingConfigFile = Get.find<MockReadConfigController>();
  @override
  //final storeConfigController = Get.find<MockStoreConfigController>();


  @override
  Future<void> checkStoreConfigWithIp() async {
    final String ipAddress = ipConnectionAddController.text;
    if (RegularExpressions.ipAddressPattern.hasMatch(ipAddress)) {
      LoadingOverlay.show();
      final res = await repository.getStoreConfigData(true, ipAddress);
      LoadingOverlay.hide();

      if (res != null && res.divisions.divid.isNotEmpty) {
        LoadingOverlay.hide();
        storeConfigController.getStoreConfigData();
        initialController.setSharedPrefInstructions();
        configFileService.rewriteExistingFileAppBaseUrl(ipAddress);
        readingConfigFile.setDataToModels();
        // NavigationService.showDialog(
        //     "Success", "IP-Address has been set", "Okay", false);
      } else {
        LoggerConfig.initLog().e("There is an Error while checking in method - checkStoreConfigWithIp() $res");
        // NavigationService.showDialog("Error",
        //     "There is an Error ", "Okay", true);
      }
    } else {
      // NavigationService.showDialog(
      //     "Error", "Invalid IP-Address format", "Okay", true);
    }
    LoadingOverlay.hide();
  }

  @override
  LoginData? loginResponse;
  @override
  EncryptionService encryptionService = EncryptionService();
  @override
  //final userManagement = Get.put(UserManagementController(), permanent: true);

  @override
  void validateLogIn() {
    isLoginEnabled.value = username.isNotEmpty &&
        username.value.length == credentialLength &&
        password.value.length == credentialLength &&
        password.isNotEmpty;
  }
  @override
  // TODO: implement repository
  MockAPIRepository get repository => MockAPIRepository();

  @override
  Future<LoginResponse> apiCallLogin(
      {required String username, required String encryptedPassword}) async {
    LoginRequest loginRequest =
    LoginRequest(userId: username, password: encryptedPassword);
    LoginResponse response = await repository.login(request: loginRequest);
    if (response.status == StatusCodeEnum.success.statusValue) {
    return response;
    } else {
      return response;
    }
  }

  // var controller = Get.put(SettingController());
  // Timer? _timer=null;
  // //------------------------Session Management----------------------
  // void initializeTimer() {
  //   if (_timer != null) _timer?.cancel();
  //   const time = Duration(minutes:26);
  //   _timer = Timer(time, () {
  //     logOutUser();
  //   });
  // }
  // void logOutUser() async {
  //   Get.offAll(()=>LoginScreen(settingController: controller));
  //   _timer?.cancel();
  // }
  // void handleUserInteraction([_]) {
  //   if (_timer != null && !_timer!.isActive) {
  //     // This means the user has been logged out
  //     return;
  //   }
  //   _timer?.cancel();
  //   initializeTimer();
  // }
  // //---------------------------------------------------------------

  @override
  Future<void> onClickLogin() async {
    if (checkCredential()) {
      String encryptedPass =
      encryptionService.encryptUserPassword(password.value);
      loginResponse = await apiCallLogin(
          username: username.value, encryptedPassword: encryptedPass)
          .then((value) {
        if (value.status == StatusCodeEnum.success.statusValue) {
          loginStatus.value = getStatus(value);
          if (loginStatus.value == LoginStatus.success) {
            if (value.data?.responseCode == LoginStatusInt.success.rawValue) {
              userManagement.setUserData(value.data);
              //_sharedPref.addUserCred(username, encryptedPass);
              initialController.setSharedPrefInstructions();
              navigateToMainTabView();
            }
          } else {
            // Error : Show toast with error message, disable login and clear fields
            _clearFields();
            isLoginEnabled.value = false;
            // NavigationService.showDialog(
            //     'Error!!', loginStatus.value.rawValue, "back", true);
          }
        }
      });
    } else {
      // NavigationService.showDialog('Wrong Credentials!!',
      //     'Please Enter Correct Credentials', "back", true);
    }
  }

  @override
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

  @override
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

  @override
  void navigateToMainTabView() {
    Get.offAllNamed(RouteNames.tabPage);
  }






}