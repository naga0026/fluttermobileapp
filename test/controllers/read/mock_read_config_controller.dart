import 'package:base_project/controller/read_configuration/read_config_files__controller.dart';
import 'package:base_project/model/app_base_url/app_base_url.dart';
import 'package:base_project/model/app_setting/app_setting.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/const_data.dart';
import '../initial_controller/mock_initial_controller.dart';

class MockReadConfigController extends GetxController
    with Mock
    implements ReadConfigFileController {
  @override
  MockInitialController initialController = Get.find<MockInitialController>();

  @override
  AppSettings? appSettings = AppSettings.fromJson(HelperData.apiBaseData);

  @override
  AppBaseURL? appBaseURL = AppBaseURL.fromJson(HelperData.appBaseData);
}
