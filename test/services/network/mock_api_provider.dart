import 'package:base_project/controller/read_configuration/read_config_files__controller.dart';
import 'package:base_project/model/api_request/get_depatment_data_request.dart';
import 'package:base_project/model/api_request/get_origin_reason_code.dart';
import 'package:base_project/model/api_request/is_caching_required_request.dart';
import 'package:base_project/model/api_request/login_request.dart';
import 'package:base_project/model/api_request/markdowns/initial_markdown_request.dart';
import 'package:base_project/model/api_request/markdowns/markdown_week_open_request.dart';
import 'package:base_project/model/api_request/markdowns/perform_initial_markdown_request.dart';
import 'package:base_project/model/api_request/perform_sgm.dart';
import 'package:base_project/model/api_request/shoe_store_request.dart';
import 'package:base_project/model/api_request/transfers/add_or_delete_item_tobox_transfers_request.dart';
import 'package:base_project/model/api_request/transfers/change_receiver_transfer_req_model.dart';
import 'package:base_project/model/api_request/transfers/end_item_inbox_transfers_request.dart';
import 'package:base_project/model/api_request/transfers/reprint_label_transfers_request.dart';
import 'package:base_project/model/api_request/transfers/validate_control_number_transfers_request.dart';
import 'package:base_project/model/api_request/transfers/void_box_transfers_request.dart';
import 'package:base_project/model/api_request/update_stock_request.dart';
import 'package:base_project/model/api_response/get_class_data_response.dart';
import 'package:base_project/model/api_response/get_department_data_response.dart';
import 'package:base_project/model/api_response/get_origin_reason_code_response.dart';
import 'package:base_project/model/api_response/get_printer_response.dart';
import 'package:base_project/model/api_response/get_sgm_response.dart';
import 'package:base_project/model/api_response/get_style_range_response.dart';
import 'package:base_project/model/api_response/is_initial_caching_required_response.dart';
import 'package:base_project/model/api_response/is_shoe_store_response.dart';
import 'package:base_project/model/api_response/login_response.dart';
import 'package:base_project/model/api_response/markdowns/get_initial_markdown_response.dart';
import 'package:base_project/model/api_response/markdowns/markdown_week_response.dart';
import 'package:base_project/model/api_response/transfers/inquire_box_transfers_response.dart';
import 'package:base_project/model/api_response/transfers/store_address_transfers_response.dart';
import 'package:base_project/model/printer_setup.dart';
import 'package:base_project/model/store_config/store_config_model.dart';
import 'package:base_project/model/ticket_maker/shoe/shoe_model.dart';
import 'package:base_project/model/ticket_maker/ticket_maker_log_model.dart';
import 'package:base_project/model/transfers/transfers_model.dart';
import 'package:base_project/services/network/api_provider.dart';
import 'package:base_project/services/network/models/api_request_model.dart';
import 'package:base_project/services/network/models/base_response.dart';
import 'package:base_project/services/network/request_type.dart';
import 'package:base_project/utility/enums/api_enum.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:get/get.dart';

import '../../controllers/read/mock_read_config_controller.dart';
import '../../utility/mock_logger_config.dart';
import 'mock_network_service.dart';

class MockAPIProvider implements APIProvider {
  //region Variables
  @override
  final logger = MockLoggerConfig.initLog();
  static MockAPIProvider? _apiProvider;

  MockAPIProvider._createInstance();

  factory MockAPIProvider() {
    return _apiProvider = _apiProvider ?? MockAPIProvider._createInstance();
  }

  final _networkService = Get.find<MockNetworkService>();
  final MockReadConfigController APIConstants =
      Get.find<MockReadConfigController>();

  //endregion

  @override
  Future<BaseResponse?> apiCallAddPrinter(PrinterSetUp printerSetUp) async {
    APIRequest apiRequest = APIRequest(
        url: APIConstants.appBaseURL!.apiBaseUrl +
            APIConstants.appSettings!.api[ApiEnum.printerSetupAssignUrl.value]!,
        requestType: RequestType.post,
        params: printerSetUp.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    return response;
  }

  @override
  Future<BaseResponse?> apiCallUnAssignPrinter(
      PrinterSetUp printerSetUp) async {
    APIRequest apiRequest = APIRequest(
        url: APIConstants.appBaseURL!.apiBaseUrl +
            APIConstants
                .appSettings!.api[ApiEnum.printerSetupUnassignUrl.value]!,
        requestType: RequestType.post,
        params: printerSetUp.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    return response;
  }

  @override
  Future<GetPrinterResponse> apiCallGetPreviousPrinters() async {
    String appID = _networkService.deviceIP.stationID;
    APIRequest apiRequest = APIRequest(
      url: APIConstants.appBaseURL!.apiBaseUrl +
          APIConstants
              .appSettings!.api[ApiEnum.getAssignedPrintersForDevice.value]! +
          appID,
      requestType: RequestType.get,
    );

    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Get previous printers response: ${response?.resultJson}");
    var printers = response?.resultJson != null
        ? getPrintersResponseFromJson(response!.resultJson)
        : <PrinterSetUp>[];
    return GetPrinterResponse(
        status: response?.statusCode ?? 200, assignedPrinters: printers);
  }

  @override
  Future<IsShoeStoreResponse> apiCallCheckShoesStock(
      ShoeStoreRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: APIConstants.appBaseURL!.apiBaseUrl +
            APIConstants.appSettings!.api[ApiEnum.isShoeStore.value]!,
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

  @override
  Future<BaseResponse?> apiCallUpdateStock(UpdateStockRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: APIConstants.appBaseURL!.apiBaseUrl +
            APIConstants.appSettings!.api[ApiEnum.printerSetupUrl.value]! +
            request.printerId,
        requestType: RequestType.put,
        params: request.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Update stock response: ${response?.resultJson}");
    return response;
  }

  @override
  Future<LoginResponse> callLoginAPI(LoginRequest loginRequest) {
    // TODO: implement callLoginAPI
    throw UnimplementedError();
  }

  @override
  Future<StoreConfigData?> getStoreConfigData(
      {bool isCheck = false, String? ipAddress}) {
    // TODO: implement getStoreConfigData
    throw UnimplementedError();
  }

  @override
  // TODO: implement apiConstant
  ReadConfigFileController get apiConstant => throw UnimplementedError();

  @override
  Future<GetInitialMarkdownResponse?> apiCallGetInitialMarkdown(
      InitialMarkdownRequest request) {
    // TODO: implement apiCallGetInitialMarkdown
    throw UnimplementedError();
  }

  @override
  Future<IsInitialCachingRequiredResponse> apiCallIsInitialCachingRequired(
      IsInitialCachingRequiredRequest request) {
    // TODO: implement apiCallIsInitialCachingRequired
    throw UnimplementedError();
  }

  @override
  Future<GetClassDataResponse> apiCallGetClassData(
      GetDepartmentOrClassDataRequest request) {
    // TODO: implement apiCallGetClassData
    throw UnimplementedError();
  }

  @override
  Future<GetDepartmentDataResponse> apiCallGetDepartmentData(
      GetDepartmentOrClassDataRequest request) {
    // TODO: implement apiCallGetDepartmentData
    throw UnimplementedError();
  }

  @override
  Future<GetStyleRangeDataResponse> apiCallStyleRangeData() {
    // TODO: implement apiCallStyleRangeData
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse?> apiCallPerformInitialMarkdown(
      PerformInitialMarkdownRequest request) {
    // TODO: implement apiCallPerformInitialMarkdown
    throw UnimplementedError();
  }

  @override
  Future<MarkdownWeekResponse> apiCallIsMarkdownWeekOpen(
      MarkdownWeekOpenRequest request) {
    // TODO: implement apiCallIsMarkdownWeekOpen
    throw UnimplementedError();
  }

  @override
  Future<GetOriginAndReasonDataResponse> apiCallGetOriginCode(
      GetOriginReasonCodeRequest request) {
    // TODO: implement apiCallGetOriginCode
    throw UnimplementedError();
  }

  @override
  Future<GetOriginAndReasonDataResponse> apiCallGetReasonCode(
      GetOriginReasonCodeRequest request) {
    // TODO: implement apiCallGetReasonCode
    throw UnimplementedError();
  }

  @override
  Future<ShoeModel> getTicketMakerVendorData() {
    // TODO: implement getTicketMakerVendorData
    throw UnimplementedError();
  }

  @override
  Future<String> apiCallAddTicketMakerLog(TicketMakerLog logData) {
    // TODO: implement apiCallAddTicketMakerLog
    throw UnimplementedError();
  }

  @override
  Future<GetPostSGMResponse?> postSGM(PerformSgmPostDataModel request) {
    // TODO: implement postSGM
    throw UnimplementedError();
  }

  @override
  Future<bool> rePrintSGM(int rePrintId) {
    // TODO: implement rePrintSGM
    throw UnimplementedError();
  }

  @override
  Future<String> getControlNumber(TransfersModel tModel) {
    // TODO: implement getControlNumber
    throw UnimplementedError();
  }

  @override
  addItemToBox(AddORDeleteItemToBoxTransferModel tModel) {
    // TODO: implement addItemToBox
    throw UnimplementedError();
  }

  @override
  deleteItemInBox(AddORDeleteItemToBoxTransferModel tModel) {
    // TODO: implement deleteItemInBox
    throw UnimplementedError();
  }

  @override
  endItemInBox(EndItemToBoxTransferModel tModel) {
    // TODO: implement endItemInBox
    throw UnimplementedError();
  }

  @override
  voidBox(VoidBoxTransferModel tModel) {
    // TODO: implement voidBox
    throw UnimplementedError();
  }

  @override
  validateControlNumber(ValidateControlNumberModel tModel) {
    // TODO: implement validateControlNumber
    throw UnimplementedError();
  }

  @override
  validateStoreNumber(String storeNumber, divisionNumber) {
    // TODO: implement validateStoreNumber
    throw UnimplementedError();
  }

  @override
  reprintLabelTransfer(ReprintLabelTransfersRequest request) {
    // TODO: implement reprintLabelTransfer
    throw UnimplementedError();
  }

  @override
  Future<StoreAddressResponse> getStoreAddress(
      {required String storeNumber, required String divisionNumber}) {
    // TODO: implement getStoreAddress
    throw UnimplementedError();
  }

  @override
  Future<TResponseData> apiCallCheckIfBoxReceived(String controlNumber) {
    // TODO: implement apiCallCheckIfBoxReceived
    throw UnimplementedError();
  }

  Future<InquireBoxModelT> inquireBox(String controlNumber, bool showLoading) {
    // TODO: implement inquireBox
    throw UnimplementedError();
  }

  @override
  Future<TResponseData> apiCallPostTransfers(TransfersModel tModel) {
    // TODO: implement apiCallPostTransfers
    throw UnimplementedError();
  }

  @override
  Future<String> changeReceiverTransfer(ChangeReceiverTransfersModel tModel) {
    // TODO: implement changeReceiverTransfer
    throw UnimplementedError();
  }

  @override
  Future<String> damagedJewelleryDatePicker(
      String storeNumber, divisionNumber) {
    // TODO: implement damagedJewelleryDatePicker
    throw UnimplementedError();
  }
}
