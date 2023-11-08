import '../request_type.dart';

class APIRequest {
  String url;
  Map<String, dynamic>? params;
  RequestType requestType;
  String? mockResponse;

  APIRequest({required this.url, required this.requestType, this.params, this.mockResponse});
}