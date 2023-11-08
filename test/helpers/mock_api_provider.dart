import 'package:base_project/model/api_request/login_request.dart';
import 'package:base_project/model/api_response/login_response.dart';
import 'package:base_project/model/store_config/store_config_model.dart';
import 'package:base_project/services/network/api_provider.dart';
import 'package:base_project/services/network/models/api_request_model.dart';
import 'package:base_project/services/network/request_type.dart';
import 'package:base_project/utility/enums/api_enum.dart';
import 'package:base_project/utility/enums/status_code_enum.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import '../controllers/read/mock_read_config_controller.dart';
import '../services/network/mock_network_service.dart';

class MockAPIProvider extends Mock implements APIProvider{


  //region Variables
  static MockAPIProvider? _apiProvider;
  MockAPIProvider._createInstance();

  factory MockAPIProvider() {
    return _apiProvider = _apiProvider ?? MockAPIProvider._createInstance();
  }

  final _networkService = Get.find<MockNetworkService>();

  @override
  final MockReadConfigController apiConstant = Get.find<MockReadConfigController>();

  //endregion

  //region Login API call
  @override
  Future<LoginResponse> callLoginAPI(LoginRequest loginRequest) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.apiLoginUrl.value]! ??
            '',
        requestType: RequestType.post,
        params: loginRequest.toMap());
    LoginData? data;
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    if (response?.statusCode == StatusCodeEnum.success.statusValue) {
      data = loginResponseFromJson(response!.resultJson);
    }
    return LoginResponse(
        status: response!.statusCode, data: data, message: response.error);
  }
//endregion

  @override
  Future<StoreConfigData?> getStoreConfigData(
      {bool isCheck = false, String? ipAddress}) async {
    StoreConfigData? storeConfig;
    final res = await _networkService.makeGetAPICall(
        apiRequest: APIRequest(
            url:
            "${isCheck ? ipAddress:apiConstant.getBaseurl()}${apiConstant.appSettings!.api[ApiEnum.apiStoreConfigUrl.value]}" ??
                "",
            requestType: RequestType.get));
    if (res.statusCode == StatusCodeEnum.success.statusValue) {
      String data = res.body;
      storeConfig = storeConfigFromJson(data);
      return storeConfig;
    }
    return null;
  }















}