import 'dart:async';
import 'dart:convert';

import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controller/initial_view_controller.dart';
import '../../controller/read_configuration/read_config_files__controller.dart';
import '../../utility/enums/api_enum.dart';
import 'models/fault_response.dart';

class CustomRequest extends http.BaseRequest {
  CustomRequest(Uri uri, String requestType) : super(requestType, uri);
}

class NwtInterceptor extends http.BaseClient {
  //region Variables
  static NwtInterceptor? nwtInterceptor;
  final ReadConfigFileController apiConstants =
  Get.find<ReadConfigFileController>();
  final InitialController initialController = Get.find<InitialController>();

  NwtInterceptor._nwtInstance();

  final http.Client _client = http.Client();
  String? _token;
  static int timeOutInSecond = 120;

  factory NwtInterceptor() {
    return NwtInterceptor.nwtInterceptor ?? NwtInterceptor._nwtInstance();
  }
  //endregion

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await setHeader(request);
    return _client
        .send(request)
        .timeout(Duration(seconds: timeOutInSecond));
  }

  Future<Map<String, String>> setHeader(http.BaseRequest request) async {
    try {
      if (!(initialController.isRemoteEnabled.value)) {
        request.headers['ApiKey'] =
        apiConstants.appSettings!.api[ApiEnum.apiKey.value]!;
        request.headers["Content-type"] = "application/json";
        request.headers["Accept"] = "application/json";
      } else {
        if (_token != null) {
          request.headers['Authorization'] = "Bearer $_token";
          request.headers['ApiKey'] =
          apiConstants.appSettings!.api[ApiEnum.apiKey.value]!;
          request.headers["Content-type"] = "application/json";
          request.headers["Accept"] = "application/json";
        } else {
          debugPrint("Getting token...");
          _token = await _getToken();
          setHeader(request);
        }
      }
    } catch (e) {
      debugPrint(
          "Issue while Fetching data via API URL:${request.url} and the Error is => $e");
    }
    return request.headers;
  }

  Future<bool> _checkTokenExpiration(http.Response response) async {
    // If token expired then remove the token
    bool isTokenExpire = false;
    if (response.statusCode != 200) {
      var fault = faultResponseFromJson(response.body);
      if(fault.fault != null){
        if (fault.fault?.isTokenExpired ?? false) {
          _token = null;
          isTokenExpire = true;
        }
      }
    }
    return isTokenExpire;
  }

  //region Get Token
  _getToken() async {
    final url = Uri.parse(apiConstants.appBaseURL?.apigeeUrl ?? '');
    http.Response? response = await _client.post(url, headers: {
      "Authorization":
      "Basic ${"${apiConstants.appBaseURL?.apigeeClientId}:${apiConstants.appBaseURL?.apigeeSecret}".toBase64}" ??
          ''
    });
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final token = jsonData['access_token'];
      return token;
    }
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    http.BaseRequest request = CustomRequest(url, 'GET');
    var headers = await setHeader(request);
    // Send the modified GET request using the inner client.
      var response = await _client.get(url, headers: headers);
      if (initialController.isRemoteEnabled.value) {
        bool isTokenExpired = await _checkTokenExpiration(response);
        if (isTokenExpired) {
          _client.get(url, headers: headers);
        }
      }
      return response;
  }

  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    http.BaseRequest request = CustomRequest(url, 'POST');
    var headers = await setHeader(request);
    final response = await _client.post(url, headers: headers, body: body, encoding: encoding);
    if (initialController.isRemoteEnabled.value) {
      bool isTokenExpired = await _checkTokenExpiration(response);
      if (isTokenExpired) {
        var headers = await setHeader(request);
        _client.post(url, headers: headers, body: body, encoding: encoding);
      }
    }
    return response;
  }

  @override
  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    http.BaseRequest request = CustomRequest(url, 'PUT');
    var headers = await setHeader(request);
    final response = await _client.put(url, headers: headers, body: body, encoding: encoding);
    if (initialController.isRemoteEnabled.value) {
      bool isTokenExpired = await _checkTokenExpiration(response);
      if (isTokenExpired){
        var headers = await setHeader(request);
        _client.put(url, headers: headers, body: body, encoding: encoding);
      }
    }
    return response;
  }

  @override
  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    http.BaseRequest request = CustomRequest(url, 'DELETE');
    var headers = await setHeader(request);
    final response = await _client.delete(url, headers: headers, body: body, encoding: encoding);
    if (initialController.isRemoteEnabled.value) {
      bool isTokenExpired = await _checkTokenExpiration(response);
      if (isTokenExpired) _client.delete(url, headers: headers, body: body, encoding: encoding);
    }
    return response;
  }

//endregion
}