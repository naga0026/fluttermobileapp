import 'dart:async';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/navigation/navigation_service.dart';
import '../services/navigation/routes/route_names.dart';
import '../services/shared_preference/shared_preference_service.dart';
import '../utility/constants/app/platform_channel_constants.dart';
import '../utility/constants/images_and_icons/icon_constants.dart';
import '../utility/logger/logger_config.dart';

class InitialController extends GetxController {
  final sharePref = Get.find<SharedPreferenceService>();
  RxBool isRemoteEnabled = true.obs;

  RxBool isLoading = false.obs;

  final _resChannel = PlatformChannelConstants.sboRestartChannel;

  restartApp()async{
    await _resChannel.invokeMethod("restart");
  }

  @override
  void onInit() {
    super.onInit();
    getSharedPrefInstructions();
  }


  setSharedPrefInstructions() {
    sharePref.set(
      key: "isRemoteEnabled",
      value: isRemoteEnabled.value,
    );
  }

  Timer? _timer = null;
  //------------------------Session Management----------------------
  void initializeTimer() {
    if (_timer != null) _timer?.cancel();
    const time = Duration(minutes: 10);
    _timer = Timer(time, () {
      logOutUser();
    });
  }

  void logOutUser() async {
    Get.offAll(() => Get.offAndToNamed(RouteNames.loginPage));
    _timer?.cancel();
  }

  void handleUserInteraction([_]) {
    if (_timer != null && !_timer!.isActive) {
      // This means the user has been logged out
      return;
    }
    _timer?.cancel();
    initializeTimer();
  }
  //---------------------------------------------------------------

  Future<bool> checkExternalFilePermission() async {
    if (await Permission.manageExternalStorage.request().isDenied) {
      NavigationService.showDialog(
          title: "Permission Not Granted",
          subtitle: "Please grant permission to proceed further",
          buttonText: "allow",
          buttonCallBack: () async {
            await Permission.manageExternalStorage.request();
          },
          icon: IconConstants.failedIcon);
      return false;
    }
    return true;
  }

  getSharedPrefInstructions() async {
    try {
      isRemoteEnabled.value = await sharePref.get(
        key: "isRemoteEnabled",
        type: bool,
      );
    } catch (e) {
      isRemoteEnabled.value = true;
      LoggerConfig.initLog().i("Cannot find any stored variable in Device$e");
    }
  }
}