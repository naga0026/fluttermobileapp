import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mock_api_repository.dart';

class MockStoreConfigController extends GetxController with Mock implements StoreConfigController{

  @override
  RxBool isCombo = false.obs;
  @override
  RxBool isStandAlone = false.obs;
  @override
  RxBool isCountryPoland = false.obs;

  @override
  String? firstMegaStoreName;
  @override
  String? selectedStoreName;
  @override
  RxString selectedStoreDivision ="".obs;
  @override
  String? secondMegaStoreName;
  @override
  String? firstMegaStoreDivision;
  @override
  String? secondMegaStoreDivision;
  @override
  String? firstMegaStoreNumber;
  @override
  String? secondMegaStoreNumber;
  @override
  RxBool isEurope = false.obs;
  @override
  MockAPIRepository get repository => MockAPIRepository();

  @override
  onInit() {
    getStoreConfigData();
    super.onInit();
  }

}
