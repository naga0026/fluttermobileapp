import 'package:base_project/model/api_request/login_request.dart';
import 'package:base_project/model/api_response/login_response.dart';
import 'package:base_project/model/store_config/store_config_model.dart';
import 'package:base_project/services/network/api_repository.dart';
import 'package:mockito/mockito.dart';

import 'mock_api_provider.dart';

class MockAPIRepository extends APIRepository with Mock{


  @override
  final apiProvider = MockAPIProvider();

  @override
  Future<LoginResponse> login({required LoginRequest request}) => apiProvider.callLoginAPI(request);
  @override
  Future<StoreConfigData?> getStoreConfigData(isCheck_,ipAddress_) => apiProvider.getStoreConfigData(isCheck:isCheck_,ipAddress: ipAddress_);


}