import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/controller/read_configuration/read_config_files__controller.dart';
import 'package:base_project/services/config/config_service.dart';
import 'package:base_project/services/shared_preference/shared_preference_service.dart';
import 'package:base_project/utility/constants/app/config_file_constants.dart';
import 'package:base_project/utility/constants/app/shared_preferences_constants.dart';
import 'package:get/get.dart';

class NetworkViewController extends BaseViewController {
  final labUrls = {
    "lab0705": "usmar0705",
    "lab0248": "catjw0248",
    "lab0542": "usmar0542",
    "lab0452": "ustjm0452",
    "lab0657": "ustjm0657",
    "lab0083": "ustjh0083",
    "lab0781": "ustjh0781",
    "lab0325": "ustjm0325",
    "lab0051": "ustjm0051",
    "lab0020": "ustjm0020",
    "lab0181": "usmar0181",
    "lab0275": "usmar0275",
    "labEu0118": "eutkm0118",
    "labEu0160": "eutkm0160",
    "lab0104": "eutkm0104",
    "lab0351": "catjw0351",
    "lab0346": "catjw0346",
    "lab0289": "ustjh0289",
    "lab1199": "usmar1199",
    "lab0376": "ustjh0376",
    "labEu0700": "eutkg0700",
    "labEu0137": "eutkm0137",
    "labOs2019test": "u2mar0542",
    "labOs2019testVm79": "u2mar1401/v2"
  };
 RxString selectedLab = "".obs;

 @override
  void onInit() {
    super.onInit();
    checkLabAndAssignedSelected();
  }

  void getLabName(String lab){
   selectedLab.value = lab;

  }

  void changeRemoteIpAddress(MapEntry<String, String> remoteIP)async{
   getLabName(remoteIP.value);
    final configService = Get.find<ConfigService>();
    final sharedPref = Get.find<SharedPreferenceService>();
    final readConfigController = Get.find<ReadConfigFileController>();
    await configService.rewriteExistingFileAppBaseUrl(remoteIP.value,isRemote: true).then((value) {
      readConfigController.readSingleFileWithName(
          ConfigurationFileNames.apiBaseUrlParameterFile);
      var lastLab = sharedPref.get(key: SharedPreferenceConstants.lastLoggedInLab, type: String);
      if(lastLab != remoteIP.value){
        sharedPref.clearCache(isClearDataOnLabChange: true);
        sharedPref.set(key: SharedPreferenceConstants.lastLoggedInLab, value: remoteIP.value);
      }
    }
    );
    Get.back();
  }

  void checkLabAndAssignedSelected() {
    final readConfigController = Get.find<ReadConfigFileController>();
    final readLab = readConfigController.appBaseURL!.apiBaseUrl.split('/')[5];
    selectedLab.value = readLab.trim();
     }





}
