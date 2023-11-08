import 'package:base_project/services/network/network_interceptor.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../controllers/initial_controller/mock_initial_controller.dart';
import '../../controllers/read/mock_read_config_controller.dart';
import '../../helpers/user_data.dart';

class MockNetworkInterceptor extends http.BaseClient with Mock implements NwtInterceptor{

  //region Variables
  static MockNetworkInterceptor? nwtInterceptor;
  @override
  final MockReadConfigController apiConstants =
  Get.find<MockReadConfigController>();
  @override
  final MockInitialController initialController = Get.find<MockInitialController>();

  MockNetworkInterceptor._nwtInstance();

  static int timeOutInSecond = 120;

  factory MockNetworkInterceptor() {
    return MockNetworkInterceptor.nwtInterceptor ?? MockNetworkInterceptor._nwtInstance();
  }
  //endregion

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    String url = request.url.toString();
    if(url.contains("login")){
      return http.StreamedResponse(
        Stream.value(http.Response(UserData.data.toString(),200).bodyBytes),
       200,
      );
    }
    else if(url.contains("store")){
      return http.StreamedResponse(
        Stream.value(http.Response(UserData.data.toString(),200).bodyBytes),
        200,
      );
    }
    else{
      return http.StreamedResponse(
        Stream.value(http.Response(UserData.data.toString(),200).bodyBytes),
        200,
      );
    }

  }

}