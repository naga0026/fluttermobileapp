import 'package:base_project/model/api_request/get_origin_reason_code.dart';
import 'package:base_project/model/api_request/transfers/reprint_label_transfers_request.dart';
import 'package:base_project/model/api_response/get_origin_reason_code_response.dart';
import 'package:base_project/model/api_response/get_style_range_response.dart';
import 'package:base_project/model/api_response/markdowns/markdown_week_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_exceptions_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_guides_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_markdown_ranges_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_price_point_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_uline_class_response.dart';
import 'package:base_project/model/api_response/transfers/void_box_tranfers_response.dart';
import 'package:base_project/model/store_config/store_config_model.dart';
import 'package:base_project/model/transfers/transfers_model.dart';
import 'package:base_project/services/network/api_provider.dart';
import 'package:base_project/services/network/models/base_response.dart';

import '../../model/api_request/get_depatment_data_request.dart';
import '../../model/api_request/is_caching_required_request.dart';
import '../../model/api_request/login_request.dart';
import '../../model/api_request/markdowns/initial_markdown_request.dart';
import '../../model/api_request/markdowns/markdown_candidate_request.dart';
import '../../model/api_request/markdowns/markdown_week_open_request.dart';
import '../../model/api_request/markdowns/perform_initial_markdown_request.dart';
import '../../model/api_request/markdowns/subs_departmentcodes_request.dart';
import '../../model/api_request/markdowns/subs_request.dart';
import '../../model/api_request/markdowns/void_markdown_request.dart';
import '../../model/api_request/perform_sgm.dart';
import '../../model/api_request/shoe_store_request.dart';
import '../../model/api_request/transfers/add_or_delete_item_tobox_transfers_request.dart';
import '../../model/api_request/transfers/change_receiver_transfer_req_model.dart';
import '../../model/api_request/transfers/end_item_inbox_transfers_request.dart';
import '../../model/api_request/transfers/validate_control_number_transfers_request.dart';
import '../../model/api_request/transfers/void_box_transfers_request.dart';
import '../../model/api_request/update_stock_request.dart';
import '../../model/api_response/get_class_data_response.dart';
import '../../model/api_response/get_department_data_response.dart';
import '../../model/api_response/get_printer_response.dart';
import '../../model/api_response/get_sgm_response.dart';
import '../../model/api_response/is_initial_caching_required_response.dart';
import '../../model/api_response/is_shoe_store_response.dart';
import '../../model/api_response/login_response.dart';
import '../../model/api_response/markdowns/get_initial_markdown_response.dart';
import '../../model/api_response/markdowns/mlu_candidate_response.dart';
import '../../model/api_response/markdowns/perform_markdown_response.dart';
import '../../model/api_response/markdowns/subs/subs_department_codes_response.dart';
import '../../model/api_response/transfers/end_item_inbox_transfers_response.dart';
import '../../model/api_response/transfers/inquire_box_transfers_response.dart';
import '../../model/api_response/transfers/store_address_transfers_response.dart';
import '../../model/printer_setup.dart';
import '../../model/ticket_maker/shoe/shoe_model.dart';

/// Stores all api calls with its result type
class APIRepository {
  final apiProvider = APIProvider();

  Future<LoginResponse> login({required LoginRequest request}) =>
      apiProvider.callLoginAPI(request);

  Future<StoreConfigData?> getStoreConfigData(isCheck_, ipAddress_) =>
      apiProvider.getStoreConfigData(isCheck: isCheck_, ipAddress: ipAddress_);

  Future<BaseResponse?> addPrinter({required PrinterSetUp request}) =>
      apiProvider.apiCallAddPrinter(request);

  Future<BaseResponse?> unAssignPrinter({required PrinterSetUp request}) =>
      apiProvider.apiCallUnAssignPrinter(request);

  Future<GetPrinterResponse> getAssignedPrinters() =>
      apiProvider.apiCallGetPreviousPrinters();

  Future<IsShoeStoreResponse> isShoesStore(
          {required ShoeStoreRequest request}) =>
      apiProvider.apiCallCheckShoesStock(request);

  Future<BaseResponse?> updatePrinterStock(
          {required UpdateStockRequest request}) =>
      apiProvider.apiCallUpdateStock(request);

  Future<GetInitialMarkdownResponse?> getInitialMarkdownsData(
          {required InitialMarkdownRequest request}) =>
      apiProvider.apiCallGetInitialMarkdown(request);

  Future<IsInitialCachingRequiredResponse?> isInitialCachingRequired(
          {required IsInitialCachingRequiredRequest request}) =>
      apiProvider.apiCallIsInitialCachingRequired(request);

  Future<GetDepartmentDataResponse> getDepartmentData(
          {required GetDepartmentOrClassDataRequest request}) =>
      apiProvider.apiCallGetDepartmentData(request);

  Future<GetClassDataResponse> getClassData(
          {required GetDepartmentOrClassDataRequest request}) =>
      apiProvider.apiCallGetClassData(request);

  Future<GetStyleRangeDataResponse> getStyleRangeData() =>
      apiProvider.apiCallStyleRangeData();

  Future<PerformInitialMarkdownResponse?> performMarkdown(
          {required PerformInitialMarkdownRequest request}) =>
      apiProvider.apiCallPerformInitialMarkdown(request);

  Future<MarkdownWeekResponse?> markdownWeekOpen(
          {required MarkdownWeekOpenRequest request}) =>
      apiProvider.apiCallIsMarkdownWeekOpen(request);

  Future<GetOriginAndReasonDataResponse> getOriginCodeData(
          {required GetOriginReasonCodeRequest request}) =>
      apiProvider.apiCallGetOriginCode(request);

  Future<GetOriginAndReasonDataResponse> getReasonCodeData(
          {required GetOriginReasonCodeRequest request}) =>
      apiProvider.apiCallGetReasonCode(request);

  Future<ShoeModel> getTMVendorData() => apiProvider.getTicketMakerVendorData();
  Future<String> apiCallAddTicketMakerLog(logData) =>
      apiProvider.apiCallAddTicketMakerLog(logData);

  Future<PerformInitialMarkdownResponse?> voidMarkdown(
          {required VoidOrReprintMarkdownRequest request}) =>
      apiProvider.apiCallVoidPreviousMarkdown(request);

  Future<BaseResponse?> deletePrinter({required PrinterSetUp request}) =>
      apiProvider.apiCallDeletePrinter(request);

  Future<GetPostSGMResponse?> postSGM(
          {required PerformSgmPostDataModel request}) =>
      apiProvider.postSGM(request);

  Future<PerformInitialMarkdownResponse?> reprintMarkdownLabel(
          {required VoidOrReprintMarkdownRequest request}) =>
      apiProvider.apiCallReprintMarkdown(request);

  Future<bool> rePrintSGM({required int rePrintId}) =>
      apiProvider.rePrintSGM(rePrintId);

  Future<MarkdownCandidateResponse?> getMLUCandidate({required MLUCandidateRequest request}) =>
      apiProvider.apiCallGetMLUCandidate(request: request);

  Future<MarkdownCandidateResponse?> getMarkdownCandidate({required MarkdownCandidateRequest request}) =>
      apiProvider.apiCallGetMarkdownCandidate(request: request);

  Future<SubsMarkdownsPricePointResponse> subsMarkdownsPricePointsAPI({required SubsMarkdownsCachingRequest request}) =>
      apiProvider.subsMarkdownsPricePointsAPI(request);

  Future<SubsMarkdownsRangesResponse> subsMarkdownsRangesAPI({required SubsMarkdownsCachingRequest request}) =>
      apiProvider.subsMarkdownsRangesAPI(request);

  Future<SubsMarkdownsExceptionResponse> subsMarkdownsExceptionsAPI({required SubsMarkdownsCachingRequest request}) =>
      apiProvider.subsMarkdownsExceptionsAPI(request);

  Future<SubsMarkdownsGuidesResponse> subsMarkdownsGuidesAPI({required SubsMarkdownsCachingRequest request}) =>
      apiProvider.subsMarkdownsGuidesAPI(request);

  Future<SubsMarkdownsClassUlineResponse> subsMarkdownsUlineClassAPI({required SubsMarkdownsCachingRequest request}) =>
      apiProvider.subsMarkdownsUlineClassAPI(request);

  Future<SubsMarkdownsDepartmentCodesResponse> subsMarkdownsDepartmentCodesAPI({required SubsMarkdownsCachingRequest request}) =>
      apiProvider.subsMarkdownsDepartmentCodesAPI(request);

  Future<String> getControlNumber(TransfersModel tModel) =>
      apiProvider.getControlNumber(tModel);

  Future<bool> addItemToBox(AddORDeleteItemToBoxTransferModel tModel) =>
      apiProvider.addItemToBox(tModel);

  Future<bool> deleteItemInBox(AddORDeleteItemToBoxTransferModel tModel) =>
      apiProvider.deleteItemInBox(tModel);

  Future<EndBoxTransfersResponse> endItemInBox(
          EndItemToBoxTransferModel tModel) =>
      apiProvider.endItemInBox(tModel);

  Future<VoidBoxResponseT> voidBox(VoidBoxTransferModel tModel) =>
      apiProvider.voidBox(tModel);

  Future<TResponseData> validateControlNumber(
          ValidateControlNumberModel tModel) =>
      apiProvider.validateControlNumber(tModel);

  Future<TResponseData> validateStoreNumber(
          String storeNumber, divisionNumber) =>
      apiProvider.validateStoreNumber(storeNumber, divisionNumber);

  Future<InquireBoxModelT> inquireBox(String controlNumber,bool showLoading) =>
      apiProvider.inquireBox(controlNumber,showLoading);

  Future<EndBoxTransfersResponse> reprintLabelTransfer(
          ReprintLabelTransfersRequest req) =>
      apiProvider.reprintLabelTransfer(req);

  Future<StoreAddressResponse> getStoreAddress(
          String storeNumber, divisionNumber) =>
      apiProvider.getStoreAddress(storeNumber:storeNumber, divisionNumber:divisionNumber);

  Future<TResponseData> checkIfBoxReceived(
      String controlNumber) =>
      apiProvider.apiCallCheckIfBoxReceived(controlNumber);

  Future<TResponseData> postTransfersData(
      TransfersModel transfersModel) =>
      apiProvider.apiCallPostTransfers(transfersModel);

  Future<String> changeReceiverTransfer(ChangeReceiverTransfersModel tModel)=>apiProvider.changeReceiverTransfer(tModel);

  Future<String> damagedJewelleryDatePicker({required String storeNumber, required String divisionNumber})=>
      apiProvider.damagedJewelleryDatePicker(storeNumber,divisionNumber);
}
