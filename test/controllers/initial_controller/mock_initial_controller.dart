import 'package:base_project/controller/initial_view_controller.dart';
import 'package:base_project/utility/logger/logger_config.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class MockInitialController extends GetxController with Mock implements InitialController{

  @override
  RxBool isRemoteEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSharedPrefInstructions();
  }

  @override
  setSharedPrefInstructions(){
    isRemoteEnabled.value = isRemoteEnabled.value;
  }

  @override
  getSharedPrefInstructions()async{
    try{
      isRemoteEnabled.value = isRemoteEnabled.value;
    }catch(e){
      isRemoteEnabled.value=true;
      LoggerConfig.initLog().i("Cannot find any stored variable in Device$e");
    }
  }









}