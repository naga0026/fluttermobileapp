import 'package:base_project/model/api_request/get_depatment_data_request.dart';
import 'package:base_project/model/api_request/get_origin_reason_code.dart';
import 'package:base_project/model/api_request/is_caching_required_request.dart';
import 'package:base_project/model/api_request/login_request.dart';
import 'package:base_project/model/api_request/markdowns/initial_markdown_request.dart';
import 'package:base_project/model/api_request/markdowns/markdown_candidate_request.dart';
import 'package:base_project/model/api_request/markdowns/markdown_week_open_request.dart';
import 'package:base_project/model/api_request/markdowns/perform_initial_markdown_request.dart';
import 'package:base_project/model/api_request/markdowns/subs_departmentcodes_request.dart';
import 'package:base_project/model/api_request/markdowns/void_markdown_request.dart';
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
import 'package:base_project/model/api_response/markdowns/mlu_candidate_response.dart';
import 'package:base_project/model/api_response/markdowns/perform_markdown_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_department_codes_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_exceptions_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_guides_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_markdown_ranges_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_price_point_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_uline_class_response.dart';
import 'package:base_project/model/api_response/transfers/end_item_inbox_transfers_response.dart';
import 'package:base_project/model/api_response/transfers/inquire_box_transfers_response.dart';
import 'package:base_project/model/api_response/transfers/store_address_transfers_response.dart';
import 'package:base_project/model/api_response/transfers/void_box_tranfers_response.dart';
import 'package:base_project/model/printer_setup.dart';
import 'package:base_project/model/store_config/store_config_model.dart';
import 'package:base_project/model/ticket_maker/shoe/shoe_model.dart';
import 'package:base_project/model/transfers/transfers_model.dart';
import 'package:base_project/services/network/api_repository.dart';
import 'package:base_project/services/network/models/base_response.dart';

import 'mock_api_provider.dart';

class MockAPIRepository implements APIRepository {

  @override
  final apiProvider = MockAPIProvider();

  @override
  Future<IsShoeStoreResponse> isShoesStore({required ShoeStoreRequest request}) => apiProvider.apiCallCheckShoesStock(request);
  @override
  Future<BaseResponse?> updatePrinterStock({required UpdateStockRequest request}) => apiProvider.apiCallUpdateStock(request);

  @override
  Future<StoreConfigData?> getStoreConfigData(isCheck_, ipAddress_) {
    // TODO: implement getStoreConfigData
    throw UnimplementedError();
  }

  @override
  Future<LoginResponse> login({required LoginRequest request}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<GetInitialMarkdownResponse?> getInitialMarkdownsData({required InitialMarkdownRequest request}) {
    // TODO: implement getInitialMarkdownsData
    throw UnimplementedError();
  }

  @override
  Future<IsInitialCachingRequiredResponse?> isInitialCachingRequired({required IsInitialCachingRequiredRequest request}) {
    // TODO: implement isInitialCachingRequired
    throw UnimplementedError();
  }

  @override
  Future<GetClassDataResponse> getClassData({required GetDepartmentOrClassDataRequest request}) {
    // TODO: implement getClassData
    throw UnimplementedError();
  }

  @override
  Future<GetDepartmentDataResponse> getDepartmentData({required GetDepartmentOrClassDataRequest request}) {
    // TODO: implement getDepartmentData
    throw UnimplementedError();
  }

  @override
  Future<GetStyleRangeDataResponse> getStyleRangeData() {
    // TODO: implement getStyleRangeData
    throw UnimplementedError();
  }

  @override
  Future<PerformInitialMarkdownResponse?> performMarkdown({required PerformInitialMarkdownRequest request}) {
    // TODO: implement performMarkdown
    throw UnimplementedError();
  }

  @override
  Future<MarkdownWeekResponse> markdownWeekOpen({required MarkdownWeekOpenRequest request}) {
    // TODO: implement markdownWeekOpen
    throw UnimplementedError();
  }

  @override
  Future<GetOriginAndReasonDataResponse> getOriginCodeData({required GetOriginReasonCodeRequest request}) {
    // TODO: implement getOriginCodeData
    throw UnimplementedError();
  }

  @override
  Future<GetOriginAndReasonDataResponse> getReasonCodeData({required GetOriginReasonCodeRequest request}) {
    // TODO: implement getReasonCodeData
    throw UnimplementedError();
  }

  @override
  Future<ShoeModel> getTMVendorData() {
    // TODO: implement getTMVendorData
    throw UnimplementedError();
  }

  @override
  Future<PerformInitialMarkdownResponse?> voidMarkdown({required VoidOrReprintMarkdownRequest request}) {
    // TODO: implement voidMarkdown
    throw UnimplementedError();
  }
  Future<String> apiCallAddTicketMakerLog(logData) {
    // TODO: implement apiCallAddTicketMakerLog
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse?> deletePrinter({required PrinterSetUp request}) {
    // TODO: implement deletePrinter
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse?> addPrinter({required PrinterSetUp request}) {
    // TODO: implement addPrinter
    throw UnimplementedError();
  }

  @override
  Future<GetPrinterResponse> getAssignedPrinters() {
    // TODO: implement getAssignedPrinters
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse?> unAssignPrinter({required PrinterSetUp request}) {
    // TODO: implement unAssignPrinter
    throw UnimplementedError();
  }

  @override
  Future<GetPostSGMResponse?> postSGM({required PerformSgmPostDataModel request}) {
    // TODO: implement postSGM
    throw UnimplementedError();
  }

  @override
  Future<PerformInitialMarkdownResponse?> reprintMarkdownLabel({required VoidOrReprintMarkdownRequest request}) {
    // TODO: implement reprintMarkdownLabel
    throw UnimplementedError();
  }

  @override
  Future<bool> rePrintSGM({required int rePrintId}) {
    // TODO: implement rePrintSGM
    throw UnimplementedError();
  }

  @override
  Future<String> getControlNumber(TransfersModel tModel) {
    // TODO: implement getControlNumber
    throw UnimplementedError();
  }
  
  


  @override
  validateControlNumber(ValidateControlNumberModel tModel) {
    // TODO: implement validateControlNumber
    throw UnimplementedError();
  }

  @override
  Future<EndBoxTransfersResponse> endItemInBox(EndItemToBoxTransferModel tModel) {
    // TODO: implement endItemInBox
    throw UnimplementedError();
  }

  @override
  validateStoreNumber(String storeNumber, divisionNumber) {
    // TODO: implement validateStoreNumber
    throw UnimplementedError();
  }

  @override
  Future<bool> addItemToBox(AddORDeleteItemToBoxTransferModel tModel) {
    // TODO: implement addItemToBox
    throw UnimplementedError();
  }
  

  @override
  Future<bool> deleteItemInBox(AddORDeleteItemToBoxTransferModel tModel) {
    // TODO: implement deleteItemInBox
    throw UnimplementedError();
  }

  @override
  Future<VoidBoxResponseT> voidBox(VoidBoxTransferModel tModel) {
    // TODO: implement voidBox
    throw UnimplementedError();
  }

  @override
  reprintLabelTransfer(ReprintLabelTransfersRequest req) {
    // TODO: implement reprintLabelTransfer
    throw UnimplementedError();
  }

  @override
  Future<StoreAddressResponse> getStoreAddress(String storeNumber, divisionNumber) {
    // TODO: implement getStoreAddress
    throw UnimplementedError();
  }

  @override
  Future<MarkdownCandidateResponse?> getMLUCandidate({required MLUCandidateRequest request}) {
    // TODO: implement getMLUCandidate
    throw UnimplementedError();
  }

  @override
  Future<MarkdownCandidateResponse?> getMarkdownCandidate({required MarkdownCandidateRequest request}) {
    // TODO: implement getMarkdownCandidate
    throw UnimplementedError();
  }

  @override
  Future<SubsMarkdownsDepartmentCodesResponse> subsMarkdownsDepartmentCodesAPI({required SubsMarkdownsCachingRequest request}) {
    // TODO: implement subsMarkdownsDepartmentCodesAPI
    throw UnimplementedError();
  }

  @override
  Future<SubsMarkdownsExceptionResponse> subsMarkdownsExceptionsAPI({required SubsMarkdownsCachingRequest request}) {
    // TODO: implement subsMarkdownsExceptionsAPI
    throw UnimplementedError();
  }

  @override
  Future<SubsMarkdownsGuidesResponse> subsMarkdownsGuidesAPI({required SubsMarkdownsCachingRequest request}) {
    // TODO: implement subsMarkdownsGuidesAPI
    throw UnimplementedError();
  }

  @override
  Future<SubsMarkdownsPricePointResponse> subsMarkdownsPricePointsAPI({required SubsMarkdownsCachingRequest request}) {
    // TODO: implement subsMarkdownsPricePointsAPI
    throw UnimplementedError();
  }

  @override
  Future<SubsMarkdownsRangesResponse> subsMarkdownsRangesAPI({required SubsMarkdownsCachingRequest request}) {
    // TODO: implement subsMarkdownsRangesAPI
    throw UnimplementedError();
  }

  @override
  Future<SubsMarkdownsClassUlineResponse> subsMarkdownsUlineClassAPI({required SubsMarkdownsCachingRequest request}) {
    // TODO: implement subsMarkdownsUlineClassAPI
    throw UnimplementedError();
  }

  @override
  Future<TResponseData> checkIfBoxReceived(String controlNumber) {
    // TODO: implement checkIfBoxReceived
    throw UnimplementedError();
  }

  @override
  Future<InquireBoxModelT> inquireBox(String controlNumber, bool showLoading) {
    // TODO: implement inquireBox
    throw UnimplementedError();
  }

  @override
  Future<TResponseData> postTransfersData(TransfersModel transfersModel) {
    // TODO: implement postTransfersData
    throw UnimplementedError();
  }
  @override
  changeReceiverTransfer(ChangeReceiverTransfersModel tModel) {
    // TODO: implement changeReceiverTransfer
    throw UnimplementedError();
  }

  @override
  damagedJewelleryDatePicker({required String storeNumber, required String divisionNumber}) {
    // TODO: implement damagedJewelleryDatePicker
    throw UnimplementedError();
  }

}