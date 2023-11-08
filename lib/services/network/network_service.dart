import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base_project/services/base/base_service.dart';
import 'package:base_project/services/navigation/navigation_service.dart';
import 'package:base_project/services/network/models/api_request_model.dart';
import 'package:base_project/services/network/models/base_response.dart';
import 'package:base_project/ui_controls/loading_overlay.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../model/api_response/base/error_response.dart';
import '../../translations/translation_keys.dart';
import 'network_interceptor.dart';
import 'request_type.dart';

class NetworkService extends BaseService {
  //region Variables
  final NwtInterceptor _interceptor = NwtInterceptor();
  bool isConnectedToNetwork = false;
  String deviceIP = '';

  //endregion

  Future<NetworkService> init() async {
    final ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    isConnectedToNetwork = connectivityResult != ConnectivityResult.none;

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Once connectivity changes fetch the ip address on which device is
      // running. It will be required to pass while adding a printer to database
      isConnectedToNetwork = result != ConnectivityResult.none;
      getDeviceLocalIP();
    });
    return this;
  }

  Future<void> getDeviceLocalIP() async {
    try {
      List<NetworkInterface> list = await NetworkInterface.list(
          includeLoopback: true, type: InternetAddressType.IPv4);
      var local =
          list.where((element) => element.name == 'wlan0').toList().first;
      deviceIP = local.addresses[0].address;
      logger.d('Local IP address: $deviceIP ');
    } catch (e) {
      logger.e('Error getting device local ip, ${e.toString()}');
    }
  }

  //region Send Request
  Future<BaseResponse?> sendRequest(
      {required APIRequest apiRequest,
      bool showLoading = true,
      bool showErrorToast = false}) async {
    http.Response response;
    BaseResponse? baseResponse;

    if (!isConnectedToNetwork) {
      NavigationService.showToast(TranslationKey.noInternetDescription.tr,);
      return BaseResponse(
          statusCode: 400, resultJson: '', error: 'No Internet Connection.');
    }
    if (showLoading) LoadingOverlay.show();

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
    ErrorResponse? errorResponse;
    if (response.statusCode == 400) {
      errorResponse = errorResponseFromJson(response.body);
      if(showErrorToast){
        NavigationService.showToast(errorResponse.title ?? TranslationKey.unknownError.tr);
      }
    }
    baseResponse = BaseResponse(
        statusCode: response.statusCode,
        resultJson: response.body,
        error: response.body,
        errorResponse: errorResponse);

    if (showLoading) LoadingOverlay.hide();

    return baseResponse;
  }

  //endregion

  //region Get/Post/Put/Delete API Calls
  Future<http.Response> makeGetAPICall({required APIRequest apiRequest}) async {
    // If parameters not null add it to the request
    Uri uri = Uri.parse(apiRequest.url);
    Uri getUri = uri;
    logger.d("URI: $uri");
    try {
      if (apiRequest.params != null) {
        getUri = uri.replace(
            queryParameters: apiRequest.params!
                .map((key, value) => MapEntry(key, value.toString())));
        logger.d("Parameters: ${apiRequest.params}");
      }
      http.Response response = await _interceptor.get(getUri);
      logger.d('API ${apiRequest.url} Response: ${response.body}');
      return response;
    } catch (error) {
      return handleError(uri.path, error);
    }
  }

  Future<http.Response> makePostAPICall(
      {required APIRequest apiRequest}) async {
    http.Response response;
    Uri uri = Uri.parse(apiRequest.url);
    logger.d("URI: $uri");
    try {
      if (apiRequest.params != null) {
        logger.d("Parameters: ${apiRequest.params}");
        response =
            await _interceptor.post(uri, body: jsonEncode(apiRequest.params));
      } else {
        response = await _interceptor.post(uri);
      }
      return response;
    } catch (error) {
      return handleError(uri.path, error);
    }
  }

  Future<http.Response> makePutAPICall({required APIRequest apiRequest}) async {
    http.Response response;
    Uri uri = Uri.parse(apiRequest.url);
    logger.d("URI: $uri");
    try {
      if (apiRequest.params != null) {
        logger.d("Parameters: ${apiRequest.params}");
        response =
            await _interceptor.put(uri, body: jsonEncode(apiRequest.params));
      } else {
        response = await _interceptor.post(uri);
      }
      return response;
    } catch (error) {
      return handleError(uri.path, error);
    }
  }

  Future<http.Response> makeDeleteAPICall(
      {required APIRequest apiRequest}) async {
    http.Response response;
    Uri uri = Uri.parse(apiRequest.url);
    try {
      if (apiRequest.params != null) {
        response =
            await _interceptor.delete(uri, body: jsonEncode(apiRequest.params));
      } else {
        response = await _interceptor.delete(uri);
      }
      return response;
    } catch (error) {
      return handleError(uri.path, error);
    }
  }

  //endregion

  //region Handle Error
  http.Response handleError(String url, dynamic error) {
    LoadingOverlay.hide();
    if (error is TimeoutException) {
      logger.e(
          "TimeoutException occurred while making a request to $url | Issue: $error");
      return http.Response("TimeoutException occurred! | $error", 400);
    } else if (error is SocketException) {
      logger.e(
          "SocketException occurred while making a request to $url | Issue: $error");
      return http.Response("SocketException occurred! | $error", 400);
    } else {
      logger.e("Error occurred while making a request to $url | Issue: $error");
      var customMap = {
        "type" : ""
      };
      return http.Response(json.encode(customMap), 400);
    }
  }

//endregion
}
