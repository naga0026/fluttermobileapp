import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:base_project/model/api_request/get_depatment_data_request.dart';
import 'package:base_project/model/api_request/is_caching_required_request.dart';
import 'package:base_project/model/api_request/markdowns/subs_departmentcodes_request.dart';
import 'package:base_project/model/api_response/get_class_data_response.dart';
import 'package:base_project/model/api_response/get_department_data_response.dart';
import 'package:base_project/model/api_response/get_style_range_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_exceptions_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_guides_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_markdown_ranges_response.dart';
import 'package:base_project/model/api_response/markdowns/subs/subs_price_point_response.dart';
import 'package:base_project/model/department_item.dart';
import 'package:base_project/model/style_range_data.dart';
import 'package:base_project/services/base/base_service.dart';
import 'package:base_project/services/database/database_service.dart';
import 'package:base_project/services/network/api_repository.dart';
import 'package:base_project/services/shared_preference/shared_preference_service.dart';
import 'package:base_project/utility/constants/app/shared_preferences_constants.dart';
import 'package:base_project/utility/enums/mega_store_type_enum.dart';
import 'package:get/get.dart';

import '../../model/api_request/markdowns/initial_markdown_request.dart';
import '../../model/api_response/markdowns/get_initial_markdown_response.dart';
import '../../model/api_response/markdowns/subs/subs_department_codes_response.dart';
import '../../model/api_response/markdowns/subs/subs_uline_class_response.dart';
import '../../model/class_item.dart';
import '../../model/request_page_params.dart';
import '../../utility/constants/app/table_names.dart';
import '../../utility/enums/status_code_enum.dart';
import '../../utility/util.dart';

part 'caching_service_subs_extension.dart';

class CachingService extends BaseService {
  final repository = APIRepository();
  final storeConfigService = Get.find<StoreConfigController>();
  final databaseService = Get.find<DatabaseService>();
  final sharedPrefService = Get.find<SharedPreferenceService>();
  int initialMarkdownCurrentPage = 1;
  int initialMarkdownTotalPage = 0;
  int initialMarkdownPerPageRecords = 75000;
  List<MarkdownData> arrMarkdownData = [];
  bool isStyleRangeSupported = false;
  bool isInitialMarkdownCachingInProgress = true;
  RxBool isSubsMarkdownCachingInProgress = true.obs;

  // Subs
  RequestPageParam subsDepartmentCodeParams = RequestPageParam();
  RequestPageParam subsExceptionsParams = RequestPageParam();
  RequestPageParam subsGuidesParams = RequestPageParam();
  RequestPageParam subsRangesParams = RequestPageParam();
  RequestPageParam subsPricePointsParams = RequestPageParam();
  RequestPageParam subsUlineClassParams = RequestPageParam();

  int subsTotalRecords = 0;
  int subsCurrentRecords = 0;
  RxDouble subsCachingProgress = 0.0.obs;

  List<SubsDepartmentData> arrSubsDepartmentCode = [];
  List<GuideData> arrSubsGuide = [];
  List<RangeData> arrSubsRange = [];
  List<PricePointData> arrSubsPricePoint = [];
  List<UlineClassData> arrSubsUlineClass = [];
  List<ExceptionData> arrSubsException = [];


  @override
  void onInit() {
    logger.i("Caching service initializing...");
    super.onInit();
    initialize();
  }

  @override
  onClose() {
    sharedPrefService.clearCache();
    super.onClose();
    logger.i("Caching service closing...");
  }

  //region Initial setup
  Future<void> initialize() async {
    var isCachingRequired = await isInitialCachingRequired();
    if (isCachingRequired) {
      await databaseService.clearTable(TableNames.initialMarkdownTable);
      await databaseService.clearTable(TableNames.subsExceptionsTable);
      await databaseService.clearTable(TableNames.subsDepartmentCodeTable);
      await databaseService.clearTable(TableNames.subsGuidesTable);
      await databaseService.clearTable(TableNames.subsRangesTable);
      await databaseService.clearTable(TableNames.subsUlineClassTable);
      await databaseService.clearTable(TableNames.subsPricePointsTable);
      apiCallGetInitialMarkdownsForCaching();
      apiCallGetSubsExceptions();
      apiCallGetSubsUlineClass();
      apiCallGetSubsPricePoints();
      apiCallGetSubsRanges();
      apiCallGetSubsDepartmentCodes();
      apiCallGetSubsGuides();
    } else {
      isInitialMarkdownCachingInProgress = false;
      isSubsMarkdownCachingInProgress.value = false;
      subsCachingProgress.value = 100.0;
    }
    bool isDeptDataAvailable = sharedPrefService.get(
            key: SharedPreferenceConstants.isDeptDataAvailable, type: bool) ??
        false;
    bool isClassDataAvailable = sharedPrefService.get(
            key: SharedPreferenceConstants.isClassDataAvailable, type: bool) ??
        false;
    if (!isDeptDataAvailable) {
      await databaseService.clearTable(TableNames.departmentItemTable);
      apiCallGetDepartmentData();
    }
    if (!isClassDataAvailable) {
      await databaseService.clearTable(TableNames.classItemTable);
      apiCallGetClassData();
    }
    checkIfStyleRangeSupportedAndUpdateData();
  }

  //endregion

  //region Helper functions
  Future<bool> isInitialCachingRequired() async {
    bool isCachingRequired = false;
    var lastCachedDate = sharedPrefService.get(
        key: SharedPreferenceConstants.lastMarkdownDate,
        type: String) as String;

    if (lastCachedDate.isNotEmpty) {
      IsInitialCachingRequiredRequest request = IsInitialCachingRequiredRequest(
          divisionCode: storeConfigService.selectedDivision,
          storeNumber: storeConfigService.selectedStoreNumber ?? '',
          lastUpdated: lastCachedDate);
      if (storeConfigService.isMega) {
        request.divisionCode = storeConfigService.firstMegaStoreDetails?.storeDivision ?? '';
        request.storeNumber = storeConfigService.firstMegaStoreDetails?.storeNumber ?? '';
        request.secondDivisionCode = storeConfigService.secondMegaStoreDetails?.storeDivision ?? '';
        request.secondStoreNumber = storeConfigService.secondMegaStoreDetails?.storeNumber ?? '';
      }
      var response =
          await repository.isInitialCachingRequired(request: request);
      if (response?.status == StatusCodeEnum.success.statusValue) {
        isCachingRequired = response!.cachingRequired!.isRequired;
      }
    } else {
      isCachingRequired = true;
    }

    return isCachingRequired;
  }

  void checkIfStyleRangeSupportedAndUpdateData() {
    // Style range data will only be available for mega stores and if the divisions are TJ Max and HomeGoods
    bool isMegaStore = storeConfigService.isMega;
    if (isMegaStore) {
      if (storeConfigService.megaStoreType ==
          MegaStoreTypeEnum.tjMaxxWithHomeGoods) {
        isStyleRangeSupported = true;
        bool isStyleRangeDataAvailable = sharedPrefService.get(
                key: SharedPreferenceConstants.isStyleRangeDataAvailable,
                type: bool) ??
            false;
        if (!isStyleRangeDataAvailable) apiCallGetStyleRangeData();
      }
    }
  }

  //endregion

  //region API Calls
  Future<void> apiCallGetInitialMarkdownsForCaching() async {
    InitialMarkdownRequest request = InitialMarkdownRequest(
        divisionCode: storeConfigService.selectedDivision,
        storeNumber: storeConfigService.selectedStoreNumber ?? '',
        pageNumber: initialMarkdownCurrentPage,
        pageSize: initialMarkdownPerPageRecords);
    if (storeConfigService.isMega) {
      request.divisionCode = storeConfigService.firstMegaStoreDetails?.storeDivision ?? '';
      request.storeNumber = storeConfigService.firstMegaStoreDetails?.storeNumber ?? '';
      request.secondDivisionCode = storeConfigService.secondMegaStoreDetails?.storeDivision;
      request.secondStoreNumber = storeConfigService.secondMegaStoreDetails?.storeNumber;
    }

    GetInitialMarkdownResponse? markdownResponse =
        await repository.getInitialMarkdownsData(request: request);
    if (markdownResponse?.status == StatusCodeEnum.success.statusValue) {
      if (markdownResponse?.markdownsData != null) {
        logger.d(
            'number of records = ${markdownResponse?.markdownsData?.data?.length ?? 0}');
        databaseService.addItems<MarkdownData>(
            markdownResponse!.markdownsData!.data!,
            TableNames.initialMarkdownTable);

        arrMarkdownData =
            arrMarkdownData + (markdownResponse.markdownsData?.data ?? []);
        initialMarkdownTotalPage =
            markdownResponse.markdownsData?.totalPages ?? 1;
        if (initialMarkdownCurrentPage <
            (markdownResponse.markdownsData?.totalPages ?? 1)) {
          initialMarkdownCurrentPage += 1;
          apiCallGetInitialMarkdownsForCaching();
        } else {
          // Got all the data
          sharedPrefService.set(
              key: SharedPreferenceConstants.lastMarkdownDate,
              value: Util.currentDateFormatted());
          isInitialMarkdownCachingInProgress = false;
        }
      }
    }
  }

  Future<void> apiCallGetClassData() async {
    GetDepartmentOrClassDataRequest request = GetDepartmentOrClassDataRequest(
        divisionCode: storeConfigService.selectedDivision);
    if (storeConfigService.isMega) {
      request.divisionCode = storeConfigService.firstDivisionCode;
      request.secondDivisionCode = storeConfigService.secondDivisionCode;
    }

    GetClassDataResponse? response =
        await repository.getClassData(request: request);
    if (response.status == StatusCodeEnum.success.statusValue) {
      if (response.data != null) {
        logger.d('number of class records = ${response.data?.length ?? 0}');
        databaseService.addItems<GetClassData>(
            response.data!, TableNames.classItemTable);
        sharedPrefService.set(
            key: SharedPreferenceConstants.isClassDataAvailable, value: true);
      }
    }
  }

  Future<void> apiCallGetDepartmentData() async {
    GetDepartmentOrClassDataRequest request = GetDepartmentOrClassDataRequest(
        divisionCode: storeConfigService.selectedDivision);
    if (storeConfigService.isMega) {
      request.divisionCode = storeConfigService.firstDivisionCode;
      request.secondDivisionCode = storeConfigService.secondDivisionCode;
    }

    GetDepartmentDataResponse? response =
        await repository.getDepartmentData(request: request);
    if (response.status == StatusCodeEnum.success.statusValue) {
      if (response.data != null) {
        logger
            .d('number of department records = ${response.data?.length ?? 0}');
        databaseService.addItems<GetDepartmentData>(
            response.data!, TableNames.departmentItemTable);
        sharedPrefService.set(
            key: SharedPreferenceConstants.isDeptDataAvailable, value: true);
      }
    }
  }

  Future<void> apiCallGetStyleRangeData() async {
    GetStyleRangeDataResponse? response = await repository.getStyleRangeData();
    if (response.status == StatusCodeEnum.success.statusValue) {
      if (response.data != null) {
        logger
            .d('number of style range records = ${response.data?.length ?? 0}');
        databaseService.addItems<GetStyleRangeData>(
            response.data!, TableNames.styleRangeItemTable);
        sharedPrefService.set(
            key: SharedPreferenceConstants.isStyleRangeDataAvailable,
            value: true);
      }
    }
  }
//endregion
}
