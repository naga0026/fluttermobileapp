part of 'api_provider.dart';

extension APIProviderPrinterExtension on APIProvider {
  Future<BaseResponse?> apiCallAddPrinter(PrinterSetUp printerSetUp) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.printerSetupAssignUrl.value]!,
        requestType: RequestType.post,
        params: printerSetUp.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest, showLoading: false);
    return response;
  }

  Future<BaseResponse?> apiCallUnAssignPrinter(PrinterSetUp printerSetUp) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant
                .appSettings!.api[ApiEnum.printerSetupUnassignUrl.value]!,
        requestType: RequestType.post,
        params: printerSetUp.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    return response;
  }

  Future<GetPrinterResponse> apiCallGetPreviousPrinters() async {
    String appID = _networkService.deviceIP.stationID;
    APIRequest apiRequest = APIRequest(
      url: apiConstant.getBaseurl()! +
          apiConstant
              .appSettings!.api[ApiEnum.getAssignedPrintersForDevice.value]! +
          appID,
      requestType: RequestType.get,
    );
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Get previous printers response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var printers = getPrintersResponseFromJson(response.resultJson);
      return GetPrinterResponse(
          status: response.statusCode, assignedPrinters: printers);
    } else {
      return GetPrinterResponse(
          status: response?.statusCode ?? 400, error: response?.error);
    }
  }

  Future<BaseResponse?> apiCallDeletePrinter(PrinterSetUp printerSetUp) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant
                .appSettings!.api[ApiEnum.printerSetupUnassignUrl.value]!,
        requestType: RequestType.delete,
        params: printerSetUp.toJsonDeletePrinter());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    return response;
  }
}