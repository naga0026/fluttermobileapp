import 'package:base_project/services/encryption/encryption_service.dart';
import 'package:base_project/services/network/network_interceptor.dart';
import 'package:base_project/services/network/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';

import '../controllers/initial_controller/mock_initial_controller.dart';
import '../controllers/login/mock_login_view_controller.dart';
import '../controllers/read/mock_read_config_controller.dart';
import '../services/network/mock_network_service.dart';

@GenerateMocks([NetworkService,NwtInterceptor])
void main()  {
  Get.testMode= true;
  WidgetsFlutterBinding.ensureInitialized();

  //Get.put(MockStoreConfigController());
  late MockLoginViewController controller;
  EncryptionService  encryptionService = EncryptionService();
  Get.put(MockInitialController());
  Get.put(MockReadConfigController());
  Get.put(() => MockNetworkService());
  setUp((){
    controller = Get.put(MockLoginViewController());
  });


  test("login-test-1[1000,0000]--wrongs password",()async{
    final data = await controller.apiCallLogin(username:"1000", encryptedPassword:"0000");
    if(data.data!=null){
      expect(data.data!.responseCode,3);
    }
  });

  test("login-test-1[7006,zD5G]--Remote | correct credential",()async{
    final data = await controller.apiCallLogin(username:"7006", encryptedPassword:"zD5G");
    if(data.data!=null){
      expect(data.data!.responseCode,1);
    }
  }); test("login-test-1[5002,vBgR]--IP-Based | correct credential",()async{
    final data = await controller.apiCallLogin(username:"5002", encryptedPassword:"vBgR");
    if(data.data!=null){
      expect(data.data!.responseCode,1);
    }
  });
}
