import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base_project/services/network/models/api_request_model.dart';
import 'package:base_project/services/network/models/base_response.dart';
import 'package:base_project/services/network/network_service.dart';
import 'package:base_project/services/network/request_type.dart';
import 'package:base_project/ui_controls/loading_overlay.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';

import '../../utility/mock_logger_config.dart';

class MockClient extends Mock implements http.Client {}

class MockNetworkService extends GetxService
    with Mock
    implements NetworkService {
//region Variables

  @override
  Logger logger =  MockLoggerConfig.initLog();

  @override
  bool isConnectedToNetwork = true;
  @override
  String deviceIP = '192.168.001.110';

  //endregion

  @override
  Future<MockNetworkService> init() async {
    Future.delayed(const Duration(milliseconds: 200)).then((value){});
    return this;
  }

  //endregion

  //region Send Request
  @override
  Future<BaseResponse?> sendRequest(
      {required APIRequest apiRequest, bool showLoading = true, bool showErrorToast = false}) async {
    http.Response response;
    BaseResponse? baseResponse;
    if (!isConnectedToNetwork) {
      return BaseResponse(
          statusCode: 400, resultJson: '', error: 'No Internet Connection.');
    }

    switch (apiRequest.requestType) {
      case RequestType.get:
        response = await makeGetAPICall(apiRequest: apiRequest);
        break;
      case RequestType.post:
        response = await makePostAPICall(apiRequest: apiRequest);
        break;
      case RequestType.put:
        response = await makePutAPICall(apiRequest: apiRequest);
        break;
      case RequestType.delete:
        response = await makeDeleteAPICall(apiRequest: apiRequest);
        break;
    }
    baseResponse = BaseResponse(
        statusCode: response.statusCode, resultJson: response.body);

    return baseResponse;
  }

  //endregion

  //region Get/Post/Put/Delete API Calls
  @override
  Future<http.Response> makeGetAPICall({required APIRequest apiRequest}) async {
    // If parameters not null add it to the request
    Uri uri = Uri.parse(apiRequest.url);
    Uri getUri = uri;
    http.Response response;
    try {
      if (apiRequest.params != null) {
        getUri = uri.replace(
            queryParameters: apiRequest.params!
                .map((key, value) => MapEntry(key, value.toString())));
      }
      final client = MockClient();
      response =  await client.get(getUri);
      return response;
    } catch (error) {
      return handleError(uri.path, error);
    }
  }

  @override
  Future<http.Response> makePostAPICall(
      {required APIRequest apiRequest}) async {
    http.Response response;
    Uri uri = Uri.parse(apiRequest.url);
    final client = MockClient();
    try {
      if (apiRequest.params != null) {
        return client.post(uri, body: jsonEncode(apiRequest.params));
      } else {
        return client.post(uri);
      }
    } catch (error) {
      return handleError(uri.path, error);
    }
  }

  @override
  Future<http.Response> makePutAPICall({required APIRequest apiRequest}) async {
    http.Response response;
    Uri uri = Uri.parse(apiRequest.url);
    final client = MockClient();
    try {
      if (apiRequest.params != null) {
        return client.put(uri, body: jsonEncode(apiRequest.params));
      } else {
        return client.put(uri);
      }
    } catch (error) {
      return handleError(uri.path, error);
    }
  }

  @override
  Future<http.Response> makeDeleteAPICall(
      {required APIRequest apiRequest}) async {
    http.Response response;
    Uri uri = Uri.parse(apiRequest.url);
    final client = MockClient();
    try {
      if (apiRequest.params != null) {
        response =
            await client.post(uri, body: jsonEncode(apiRequest.params));
      } else {
        response = await client.post(uri);
      }
      return response;
    } catch (error) {
      return handleError(uri.path, error);
    }
  }

  //endregion

  //region Handle Error
  @override
  http.Response handleError(String url, dynamic error) {
    LoadingOverlay.hide();
    if (error is TimeoutException) {

      return http.Response("TimeoutException occurred! | $error", 400);
    } else if (error is SocketException) {

      return http.Response("SocketException occurred! | $error", 400);
    } else {
      return http.Response("An error occurred! | $error", 400);
    }
  }
//endregion
}
