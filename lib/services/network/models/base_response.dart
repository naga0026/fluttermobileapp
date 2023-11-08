import '../../../model/api_response/base/error_response.dart';

class BaseResponse {
  int statusCode;
  String resultJson;
  String? error;
  ErrorResponse? errorResponse;

  BaseResponse({required this.statusCode, required this.resultJson, this.error, this.errorResponse});

}

