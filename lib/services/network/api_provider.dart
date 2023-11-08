import 'dart:convert';

import 'package:base_project/model/api_request/get_depatment_data_request.dart';
import 'package:base_project/model/api_request/perform_sgm.dart';
import 'package:base_project/model/api_request/transfers/change_receiver_transfer_req_model.dart';
import 'package:base_project/model/api_request/transfers/reprint_label_transfers_request.dart';
import 'package:base_project/model/api_response/get_class_data_response.dart';
import 'package:base_project/model/api_response/get_department_data_response.dart';
import 'package:base_project/model/api_response/get_origin_reason_code_response.dart';
import 'package:base_project/model/api_response/markdowns/perform_markdown_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_exceptions_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_guides_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_markdown_ranges_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_price_point_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_uline_class_response.dart';
import 'package:base_project/model/api_response/transfers/end_item_inbox_transfers_response.dart';
import 'package:base_project/model/api_response/transfers/inquire_box_transfers_response.dart';
import 'package:base_project/model/api_response/transfers/void_box_tranfers_response.dart';
import 'package:base_project/model/class_item.dart';
import 'package:base_project/model/origin_reason_model.dart';
import 'package:base_project/model/printer_setup.dart';
import 'package:base_project/model/store_config/store_config_model.dart';
import 'package:base_project/model/style_range_data.dart';
import 'package:base_project/model/ticket_maker/ticket_maker_log_model.dart';
import 'package:base_project/model/transfers/transfers_model.dart';
import 'package:base_project/services/network/models/api_request_model.dart';
import 'package:base_project/services/network/models/base_response.dart';
import 'package:base_project/services/network/request_type.dart';
import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/utility/enums/api_enum.dart';
import 'package:base_project/utility/enums/status_code_enum.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:get/get.dart';

import '../../controller/read_configuration/read_config_files__controller.dart';
import '../../model/api_request/get_origin_reason_code.dart';
import '../../model/api_request/is_caching_required_request.dart';
import '../../model/api_request/login_request.dart';
import '../../model/api_request/markdowns/initial_markdown_request.dart';
import '../../model/api_request/markdowns/markdown_candidate_request.dart';
import '../../model/api_request/markdowns/markdown_week_open_request.dart';
import '../../model/api_request/markdowns/perform_initial_markdown_request.dart';
import '../../model/api_request/markdowns/subs_departmentcodes_request.dart';
import '../../model/api_request/markdowns/subs_request.dart';
import '../../model/api_request/markdowns/void_markdown_request.dart';
import '../../model/api_request/shoe_store_request.dart';
import '../../model/api_request/transfers/add_or_delete_item_tobox_transfers_request.dart';
import '../../model/api_request/transfers/end_item_inbox_transfers_request.dart';
import '../../model/api_request/transfers/validate_control_number_transfers_request.dart';
import '../../model/api_request/transfers/void_box_transfers_request.dart';
import '../../model/api_request/update_stock_request.dart';
import '../../model/api_response/get_printer_response.dart';
import '../../model/api_response/get_sgm_response.dart';
import '../../model/api_response/get_style_range_response.dart';
import '../../model/api_response/is_initial_caching_required_response.dart';
import '../../model/api_response/is_shoe_store_response.dart';
import '../../model/api_response/login_response.dart';
import '../../model/api_response/markdowns/get_initial_markdown_response.dart';
import '../../model/api_response/markdowns/markdown_week_response.dart';
import '../../model/api_response/markdowns/mlu_candidate_response.dart';
import '../../model/api_response/markdowns/subs/subs_department_codes_response.dart';
import '../../model/api_response/transfers/store_address_transfers_response.dart';
import '../../model/department_item.dart';
import '../../model/ticket_maker/shoe/shoe_model.dart';
import '../../utility/logger/logger_config.dart';
import '../navigation/navigation_service.dart';
import 'network_service.dart';

part 'api_provider_markdowns_extension.dart';
part 'api_provider_printer_extension.dart';

/// Makes an API call for given request, parses the response data and returns it to api repository
class APIProvider {
  //region Variables
  final logger = LoggerConfig.initLog();
  static APIProvider? _apiProvider;

  APIProvider._createInstance();

  factory APIProvider() {
    return _apiProvider = _apiProvider ?? APIProvider._createInstance();
  }

  final _networkService = Get.find<NetworkService>();
  final ReadConfigFileController apiConstant =
      Get.find<ReadConfigFileController>();

  //endregion

  //region Login API call
  Future<LoginResponse> callLoginAPI(LoginRequest loginRequest) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.apiLoginUrl.value]!,
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

  Future<StoreConfigData?> getStoreConfigData(
      {bool isCheck = false, String? ipAddress}) async {
    StoreConfigData? storeConfig;
    final res = await _networkService.sendRequest(
        apiRequest: APIRequest(
            url:
                "${isCheck ? ipAddress : apiConstant.getBaseurl()!}${apiConstant.appSettings!.api[ApiEnum.apiStoreConfigUrl.value]}",
            requestType: RequestType.get));
    if (res?.statusCode == StatusCodeEnum.success.statusValue) {
      String data = res?.resultJson ?? '';
      storeConfig = storeConfigFromJson(data);
      return storeConfig;
    }
    return null;
  }

  Future<IsShoeStoreResponse> apiCallCheckShoesStock(
      ShoeStoreRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.isShoeStore.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Check shoes store response: ${response?.resultJson}");
    if (response != null) {
      var result = isShoeStoreResponseFromJson(response.resultJson);
      return IsShoeStoreResponse(status: response.statusCode, data: result);
    } else {
      return IsShoeStoreResponse(
          status: response?.statusCode ?? 400, message: response?.error);
    }
  }

  Future<BaseResponse?> apiCallUpdateStock(UpdateStockRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.printerSetupUrl.value]! +
            request.printerId,
        requestType: RequestType.put,
        params: request.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Update stock response: ${response?.resultJson}");
    return response;
  }

  // Caching

  Future<IsInitialCachingRequiredResponse> apiCallIsInitialCachingRequired(
      IsInitialCachingRequiredRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant
                .appSettings!.api[ApiEnum.isInitialCachingRequired.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Is initial caching required response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result =
          isInitialCachingRequiredResponseFromJson(response.resultJson);
      return IsInitialCachingRequiredResponse(
          status: response.statusCode, cachingRequired: result);
    } else {
      return IsInitialCachingRequiredResponse(
          status: response?.statusCode ?? 400,
          error: response?.errorResponse?.title ?? response?.error);
    }
  }

  Future<GetInitialMarkdownResponse?> apiCallGetInitialMarkdown(
      InitialMarkdownRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.getInitialMarkdowns.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Get initial markdown response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = initialsSubsModelFromJson(response.resultJson);
      return GetInitialMarkdownResponse(
          status: response.statusCode, markdownsData: result);
    } else {
      return GetInitialMarkdownResponse(
          status: response?.statusCode ?? 400, error: response?.error);
    }
  }

  Future<GetDepartmentDataResponse> apiCallGetDepartmentData(
      GetDepartmentOrClassDataRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.getDepartmentData.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Get department data response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = getDepartmentDataFromJson(response.resultJson);
      return GetDepartmentDataResponse(
          status: response.statusCode, data: result);
    } else {
      return GetDepartmentDataResponse(
          status: response?.statusCode ?? 400, error: response?.error);
    }
  }

  Future<GetClassDataResponse> apiCallGetClassData(
      GetDepartmentOrClassDataRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.getClassData.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Get class data response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = getClassDataFromJson(response.resultJson);
      return GetClassDataResponse(status: response.statusCode, data: result);
    } else {
      return GetClassDataResponse(
          status: response?.statusCode ?? 400, error: response?.error);
    }
  }

  Future<GetStyleRangeDataResponse> apiCallStyleRangeData() async {
    // Only for mega stores with TJMAXX and HOMEGOODS combination
    APIRequest apiRequest = APIRequest(
      url: apiConstant.getBaseurl()! +
          apiConstant.appSettings!.api[ApiEnum.getStyleRangeData.value]!,
      requestType: RequestType.get,
    );
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Get style range data response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = getStyleRangeDataFromJson(response.resultJson);
      return GetStyleRangeDataResponse(
          status: response.statusCode, data: result);
    } else {
      return GetStyleRangeDataResponse(
          status: response?.statusCode ?? 400,
          error: response?.errorResponse?.title ?? response?.error);
    }
  }

  Future<GetOriginAndReasonDataResponse> apiCallGetOriginCode(
      GetOriginReasonCodeRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.getOriginCodes.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Get class data response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = originAndReasonModelFromJson(response.resultJson);
      return GetOriginAndReasonDataResponse(
          status: response.statusCode, data: result);
    } else {
      return GetOriginAndReasonDataResponse(
          status: response?.statusCode ?? 400,
          error: response?.errorResponse?.title ?? response?.error);
    }
  }

  Future<GetOriginAndReasonDataResponse> apiCallGetReasonCode(
      GetOriginReasonCodeRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.getReasonCodes.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Get class data response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = originAndReasonModelFromJson(response.resultJson);
      return GetOriginAndReasonDataResponse(
          status: response.statusCode, data: result);
    } else {
      return GetOriginAndReasonDataResponse(
          status: response?.statusCode ?? 400,
          error: response?.errorResponse?.title ?? response?.error);
    }
  }

  Future<ShoeModel> getTicketMakerVendorData() async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.ticketMakerVendors.value]!,
        requestType: RequestType.get);
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      return ShoeModel(
          status: StatusCodeEnum.success.statusValue,
          data: List<String>.from(jsonDecode(response.resultJson)));
    } else {
      return ShoeModel(
          status: StatusCodeEnum.success.statusValue,
          data: [],
          error: response?.errorResponse?.title ?? response?.error);
    }
  }

  Future<String> apiCallAddTicketMakerLog(TicketMakerLog logData) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.ticketMakerLog.value]!,
        requestType: RequestType.post,
        params: logData.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      return response.resultJson;
    } else {
      return response?.errorResponse?.title ?? response?.error ?? "Error";
    }
  }

  Future<GetPostSGMResponse?> postSGM(PerformSgmPostDataModel request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.performSgm.value]!,
        requestType: RequestType.post,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Perform SGM response: ${response?.resultJson}");
    if (response?.statusCode == StatusCodeEnum.success.statusValue) {
      PerformSgmResponseModel res =
          performSgmResponseModelFromJson(response!.resultJson);
      return GetPostSGMResponse(status: response.statusCode, data: res);
    }
    return GetPostSGMResponse(
        status: response?.statusCode ?? 400,
        error: response?.errorResponse?.title ?? response?.error,
        data: null);
  }

  Future<bool> rePrintSGM(int rePrintId) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.reprintSgm.value]! +
            rePrintId.toString(),
        requestType: RequestType.get);
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Perform re-Print SGM response:${response!.resultJson}");
    if (response.statusCode == StatusCodeEnum.success.statusValue) {
      return true;
    }
    return false;
  }

  Future<String> getControlNumber(TransfersModel tModel) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! + ApiEnum.transfers.value,
        requestType: RequestType.post,
        params: tModel.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    try {
      if (response!.statusCode == StatusCodeEnum.success.statusValue) {
        return tResponseDataFromJson(response.resultJson).data;
      }
    } catch (e) {
      logger.e("Error in fetching the control Number");
      return "";
    }
    return tResponseDataFromJson(response.resultJson).data;
  }

  Future<bool> addItemToBox(AddORDeleteItemToBoxTransferModel tModel) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.addItemToBoxTransfers.value]!,
        requestType: RequestType.post,
        params: tModel.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    if (response!.statusCode == StatusCodeEnum.success.statusValue) {
      return true;
    }
    return false;
  }

  Future<bool> deleteItemInBox(AddORDeleteItemToBoxTransferModel tModel) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.deleteItemInBox.value]!,
        requestType: RequestType.delete,
        params: tModel.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    if (response!.statusCode == StatusCodeEnum.success.statusValue) {
      return true;
    }
    return false;
  }

  Future<EndBoxTransfersResponse> endItemInBox(
      EndItemToBoxTransferModel tModel) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.endBoxTransfers.value]!,
        requestType: RequestType.post,
        params: tModel.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    if (response!.statusCode == StatusCodeEnum.success.statusValue) {
      return endBoxTransfersResponseFromJson(response.resultJson);
    }
    return endBoxTransfersResponseFromJson(response.resultJson);
  }

  Future<VoidBoxResponseT> voidBox(VoidBoxTransferModel tModel) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.voidBox.value]!,
        requestType: RequestType.post,
        params: tModel.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    if (response!.statusCode == StatusCodeEnum.success.statusValue) {
      return voidBoxResponseTFromJson(response.resultJson);
    }
    return voidBoxResponseTFromJson(response.resultJson);
  }

  Future<InquireBoxModelT> inquireBox(
      String controlNumber, bool showLoading) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.inquireBox.value]!,
        requestType: RequestType.get,
        params: {"controlNumber": controlNumber});
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: showLoading);
    if (response!.statusCode == StatusCodeEnum.success.statusValue) {
      return inquireBoxModelTFromJson(response.resultJson);
    }
    return inquireBoxModelTFromJson(response.resultJson);
  }

  Future<TResponseData> validateStoreNumber(
      String storeNumber, divisionNumber) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant
                .appSettings!.api[ApiEnum.validateStoreNumberTransfers.value]!,
        requestType: RequestType.get,
        params: {"DivisionNumber": divisionNumber, "StoreNumber": storeNumber});
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    try {
      if (response!.statusCode == StatusCodeEnum.success.statusValue) {
        return tResponseDataFromJson(response.resultJson);
      }
    } catch (e) {
      return TResponseData(responseCode: 2, data: "");
    }
    return TResponseData(responseCode: 1, data: "");
  }

  Future<TResponseData> validateControlNumber(
      ValidateControlNumberModel tModel) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant
                .appSettings!.api[ApiEnum.controlNumberValidStatus.value]!,
        requestType: RequestType.get,
        params: tModel.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    try {
      if (response!.statusCode == StatusCodeEnum.success.statusValue) {
        return tResponseDataFromJson(response.resultJson);
      }
    } catch (e) {
      return TResponseData(responseCode: 2, data: "");
    }
    return TResponseData(responseCode: 2, data: "");
  }

  Future<EndBoxTransfersResponse> reprintLabelTransfer(
      ReprintLabelTransfersRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.reprintTransfers.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    try {
      if (response!.statusCode == StatusCodeEnum.success.statusValue) {
        return endBoxTransfersResponseFromJson(response.resultJson);
      }
    } catch (e) {
      return endBoxTransfersResponseFromJson(response!.resultJson);
    }
    return endBoxTransfersResponseFromJson(response.resultJson);
  }

  Future<StoreAddressResponse> getStoreAddress(
      {required String storeNumber, required String divisionNumber}) async {
    APIRequest apiRequest = APIRequest(
        url: '${apiConstant.getBaseurl()!}/${apiConstant.appSettings!.api[ApiEnum.getStoreAddress.value]!}',
        requestType: RequestType.get,
        params: {"storeNumber": storeNumber, "divisionCode": divisionNumber});
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    if (response!.statusCode == StatusCodeEnum.success.statusValue) {
      return storeAddressResponseFromJson(response.resultJson);
    } else {
      return storeAddressResponseFromJson(response.resultJson);
    }
  }

  Future<String> changeReceiverTransfer(
      ChangeReceiverTransfersModel tModel) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant
                .appSettings!.api[ApiEnum.changeReceiverTransfers.value]!,
        requestType: RequestType.post,
        params: tModel.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    if (response!.statusCode == StatusCodeEnum.success.statusValue) {
      logger.d("Changing Receiver location $response");
      return response.resultJson;
    } else {
      return "";
    }
  }

  Future<String> damagedJewelleryDatePicker(String storeNumber, divisionNumber)async{
    APIRequest apiRequest = APIRequest(url: apiConstant.getBaseurl()!+apiConstant.appSettings!.api[ApiEnum.getDamagedJewelryCreatedDate.value]!
        , requestType: RequestType.get,
    params: {
      "storeNumber":storeNumber,
      "divisionNumber":divisionNumber
    });
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    if(response!.statusCode==StatusCodeEnum.success.statusValue){
      logger.d(response.resultJson);
      return tResponseDataFromJson(response.resultJson).data;
    }else{
      return "";
    }
  }

  Future<TResponseData> apiCallCheckIfBoxReceived(
      String controlNumber) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant
                .appSettings!.api[ApiEnum.inquireBoxReceived.value]!,
        requestType: RequestType.get,
        params: {"controlNumber": controlNumber});
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Box received response: ${response?.resultJson}");
    if (response!.statusCode == StatusCodeEnum.success.statusValue) {
      return tResponseDataFromJson(response.resultJson);
    }
    return TResponseData(responseCode: 2, data: "");
  }

  Future<TResponseData> apiCallPostTransfers(TransfersModel tModel) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! + ApiEnum.transfers.value,
        requestType: RequestType.post,
        params: tModel.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Post transfers response ${response?.resultJson}");
    if (response!.statusCode == StatusCodeEnum.success.statusValue) {
      return tResponseDataFromJson(response.resultJson);
    }
    return TResponseData(responseCode: 2, data: "");
  }
}
