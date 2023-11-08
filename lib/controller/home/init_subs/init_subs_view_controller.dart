//region Imports
import 'dart:async';

import 'package:base_project/controller/barcode/barcode_interpret_controller.dart';
import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/controller/printer/printer_list_controller.dart';
import 'package:base_project/model/api_request/markdowns/perform_initial_markdown_request.dart';
import 'package:base_project/model/api_request/markdowns/void_markdown_request.dart';
import 'package:base_project/model/api_response/markdowns/get_initial_markdown_response.dart';
import 'package:base_project/model/api_response/markdowns/markdown_week_response.dart';
import 'package:base_project/model/label_definition/markdown_label_data.dart';
import 'package:base_project/model/printer_setup.dart';
import 'package:base_project/model/store_config/store_details.dart';
import 'package:base_project/services/caching/caching_service.dart';
import 'package:base_project/services/printing/model/print_label_model.dart';
import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/utility/enums/app_name_enum.dart';
import 'package:base_project/utility/enums/markdown_type_enum.dart';
import 'package:base_project/utility/enums/stock_type.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:base_project/utility/extensions/int_to_enum_extension.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:base_project/utility/rekey_price_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/api_request/markdowns/markdown_candidate_request.dart';
import '../../../model/api_request/markdowns/markdown_week_open_request.dart';
import '../../../model/api_response/markdowns/mlu_candidate_response.dart';
import '../../../model/sbo_field_model.dart';
import '../../../services/database/database_service.dart';
import '../../../services/navigation/navigation_service.dart';
import '../../../services/network/network_service.dart';
import '../../../services/printing/zebra_print_service.dart';
import '../../../services/scanning/zebra_scan_service.dart';
import '../../../services/shared_preference/shared_preference_service.dart';
import '../../../ui_controls/loading_overlay.dart';
import '../../../utility/constants/app/regular_expressions.dart';
import '../../../utility/constants/app/table_names.dart';
import '../../../utility/constants/custom_dialog/custom_dialogsCLS.dart';
import '../../../utility/constants/images_and_icons/icon_constants.dart';
import '../../../utility/enums/markdown_operation_result_enum.dart';
import '../../../utility/enums/markdowns_operation_enum.dart';
import '../../../utility/enums/markdowns_printing_suffix.dart';
import '../../../utility/enums/pricetype_enums.dart';
import '../../../utility/enums/status_code_enum.dart';
import '../../../utility/enums/style_type_enum.dart';
import '../../../utility/helpers/markdown_barcode_creating_helper.dart';
import '../../barcode/scanned_item_model.dart';
import '../../login/user_management.dart';
import '../../store_config/store_config_controller.dart';
import '../../validation/fiscal_week.dart';
import '../../validation/validation_controller.dart';

part 'init_subs_controller_api_extension.dart';
part 'init_subs_controller_validation_extension.dart';
part 'mlu_view_controller.dart';
part 'subsquent_markdown_controller_extension.dart';
//endregion

class InitSubsViewController extends BaseViewController {
  //region Variables
  final storeConfigController = Get.find<StoreConfigController>();
  final barcodeInterpretController = Get.find<BarcodeInterpretController>();
  final validationController = Get.find<ValidationController>();
  var userManagementController = Get.find<UserManagementController>();
  var printerListViewController = Get.find<PrinterListViewController>();

  final zebraPrintService = Get.find<ZebraPrintService>();
  final zebraScanService = Get.find<ZebraScanService>();
  final networkService = Get.find<NetworkService>();
  final databaseService = Get.find<DatabaseService>();
  final sharedPrefService = Get.find<SharedPreferenceService>();
  final fiscalWeek = Get.find<FiscalWeekCalculationService>();

  /// Stores markdown data entered or scanned in a text field
  /// Once scanned or entered data initialize it and on successfully printing or clearing the data
  /// make it null so that we can manage isKeyed and also the fresh data
  late ScanOrEnteredItemModel initialMarkdownFields;
  PrintLabelModel? previousPrintDetails;
  int reprintCount = 1;

  /// Stores the response from api call to get open markdown week
  MarkdownWeek? openMarkdownWeek;

  RxInt selectedIndex = 0.obs;
  RxBool isMarkdownWeekOpen = false.obs;
  RxBool isMarkdownWeekOpenForSubs = false.obs;
  RxBool isKeyed = true.obs;

  List<MarkdownOperationEnum> initialsOperations = [
    MarkdownOperationEnum.initials,
    MarkdownOperationEnum.subs,
    MarkdownOperationEnum.mlu,
    MarkdownOperationEnum.voidPrevious,
    MarkdownOperationEnum.reprint
  ];

  /// Array of initial markdown input fields
  final RxList<SBOFieldModel> arrayInitialMarkdownFields = [
    SBOFieldModel(
        sboField: SBOField.department,
        textEditingController: TextEditingController(),
        focusNode: FocusNode()),
    SBOFieldModel(
        sboField: SBOField.style,
        textEditingController: TextEditingController(),
        focusNode: FocusNode()),
    SBOFieldModel(
        sboField: SBOField.price,
        textEditingController: TextEditingController(),
        focusNode: FocusNode()),
  ].obs;

  final RxList<SBOFieldModel> arraySubsMarkdownFields = [
    SBOFieldModel(
        sboField: SBOField.department,
        textEditingController: TextEditingController(), focusNode: FocusNode()),
    SBOFieldModel(
        sboField: SBOField.classSubs,
        textEditingController: TextEditingController(), focusNode: FocusNode()),
    SBOFieldModel(
        sboField: SBOField.style,
        textEditingController: TextEditingController(), focusNode: FocusNode()),
    SBOFieldModel(
        sboField: SBOField.price,
        textEditingController: TextEditingController(), focusNode: FocusNode()),
  ].obs;

  StyleTypeEnum styleTypeForStore = StyleTypeEnum.style;

  /// Listener to read the barcode scan results
  late StreamSubscription<String> subscription;
  late StreamSubscription<StoreDetails?> storeChangeSubscription;
  Rx<MarkdownOperationEnum> selectedOperation =
      MarkdownOperationEnum.initials.obs;
  final cachingService = Get.find<CachingService>();
  List<MarkdownData> liveMarkdownData = [];
  RxDouble subsCachingProgress = 0.0.obs;

  //endregion

  @override
  onClose() {
    subscription.cancel();
    storeChangeSubscription.cancel();
    super.onClose();
  }

  runCheckStockBeforeMovingInInitial() {
    final status = checkStockBeforeNavigatingToView(
        [StockTypeEnum.priceAdjust, StockTypeEnum.markdown]);
    if (status == null) {
      CustomDialog.showNoPrinterFoundDialog();
    } else if (!status) {
      CustomDialog.showStockMismatchDialog();
    }
  }

  //endregion

  //region Initial setup
  void initialize() {
    subscription = zebraScanService.scannedBarcodeStreamController.stream
        .listen((barcode) {
      logger.d('Scanned initial barcode: $barcode');
      bool isValidBarcode = barcodeInterpretController.fillScannedBarcodeData(
          barcode, arrayInitialMarkdownFields,
          regExpToValidatePrice: RegularExpressions.initialPriceEnding99);
      if (isValidBarcode) {
        initialMarkdownFields = ScanOrEnteredItemModel();
        initialMarkdownFields.isKeyed = false;
        isKeyed.value = false;
        onClickPrint();
      }
    });

    cachingService.subsCachingProgress.listen((value) {
      subsCachingProgress.value = value;
    });
    onChangeDivisionSubscribe();
  }

  void updateInitSubsFields() {
    if (styleTypeForStore == StyleTypeEnum.uline) {
      arrayInitialMarkdownFields[1] = SBOFieldModel(
          sboField: SBOField.uline,
          textEditingController: TextEditingController(),
          focusNode: FocusNode());
    } else {
      arrayInitialMarkdownFields[1] = SBOFieldModel(
          sboField: SBOField.style,
          textEditingController: TextEditingController(),
          focusNode: FocusNode());
    }
  }

  void initialSetUp() {
    styleTypeForStore = storeConfigController.checkForStyleOrULine();
    updateInitSubsFields();
    apiCallGetOpenMarkdownWeek();
  }

  //endregion

  //region Handlers
  Future<void> onDestinationChange(int index) async {
    logger.d(index);
    selectedIndex.value = index;
    selectedOperation.value = initialsOperations[index];
    switch(selectedOperation.value){
      case MarkdownOperationEnum.initials:
        apiCallGetOpenMarkdownWeek();
        break;
      case MarkdownOperationEnum.subs:
        apiCallGetOpenMarkdownWeekForSubs();
        break;
      case MarkdownOperationEnum.mlu:
        LoadingOverlay.hide();
        break;
      case MarkdownOperationEnum.voidPrevious:
        await apiCallVoidMarkdown().then((_){
          _setInitialIndex();
        });
        break;
      case MarkdownOperationEnum.reprint:
        await onClickReprintLabel().then((_){
          _setInitialIndex();
        });
        break;
    }
  }

  void onClickClear() {
    isKeyed.value = true;
    for (var element in arrayInitialMarkdownFields) {
      element.textEditingController.clear();
    }
  }

  void onClickClearSubs() {
    isKeyed.value = true;
    for (var element in arraySubsMarkdownFields) {
      element.textEditingController.clear();
    }
  }

  Future<void> onClickPrint() async {
    fillValuesInInitialMarkdownFields();
    bool isValid = await validateInitialMarkdownFields();
    if (isValid) {
      selectedOperation.value = initialsOperations[selectedIndex.value];
      switch (selectedOperation.value) {
        case MarkdownOperationEnum.mlu:
          proceedWithMLU();
          break;
        default:
          await proceedWithInitialMarkdowns();
      }
    }
  }

  void onChangeDivisionSubscribe() {
    storeChangeSubscription =
        storeConfigController.selectedStoreDetails.stream.listen((division) {
          logger.d(
              'Store changed initial subs controller: ${division?.storeName}');
          if (division != null) {
            onClickClear();
            selectedOperation.value = MarkdownOperationEnum.initials;
            selectedIndex.value = 0;
            initialSetUp();
          }
        });
  }

  Future<void> onClickReprintLabel() async {
    if (previousPrintDetails != null) {
      StockTypeEnum stockType =
          previousPrintDetails!.printer.printerStock.stock;
      PrinterSetUp? printer =
      checkAvailablePrinterForStockAndReturnPrinter(stockType);
      if (printer != null) {
        bool isAPISuccess = await apiCallReprintMarkdown();
        if (isAPISuccess) zebraPrintService.printLabel(previousPrintDetails!);
      }
    } else {
      NavigationService.showDialog(
        title: TranslationKey.error.tr,
        subtitle: TranslationKey.noDataToReprint.tr,
        buttonCallBack: () => onBack(),
        icon: IconConstants.failedIcon,
      );
    }
  }

  void onBack() {
    Get.back();
    selectedIndex.value = 0;
  }

  void onScreenClose() {
    reprintCount = 1;
    previousPrintDetails = null;
    sharedPrefService.setRecentMarkdown();
  }

  //endregion

  //region Checkers
  Future<(bool, Map<String, dynamic>?)> checkIfMarkdownNeeded() async {
    // Check if the details are matching with the record available in database
    // Check if data entered is available in markdown table
    // fetch markdown data for deptId and uline/style
    // compare toPrice from DB and price from field
    var markdownData = MarkdownData();
    markdownData.departmentCode = initialMarkdownFields.deptId;
    if (storeConfigController.isMarshallsUSA()) {
      markdownData.uline = initialMarkdownFields.styleOrULine;
    } else {
      markdownData.style = initialMarkdownFields.styleOrULine;
    }
    markdownData.divisionCode = storeConfigController.selectedDivision;
    // If caching is not completed, find data from api else from cached data
    if (cachingService.isInitialMarkdownCachingInProgress) {
      var fetchedMarkdownData = await apiCallGetMarkdownCandidate();
      if ((fetchedMarkdownData?.markdownData ?? []).isEmpty) {
        showNoMarkdownDialog();
        return (false, null);
      } else {
        liveMarkdownData = fetchedMarkdownData?.markdownData ?? [];
        return (true, fetchedMarkdownData!.markdownData!.first.toJson());
      }
    } else {
      Map<String, dynamic>? res = await databaseService.selectQuery(
          tableName: TableNames.initialMarkdownTable,
          queryParams: markdownData.findMarkdownDataInDBQuery());
      if (res != null) {
        return (true, res);
      } else {
        showNoMarkdownDialog();
        return (false, null);
      }
    }
  }

  Future<bool> isDepartmentInCurrentWeek() async {
    // Check from the cached initial markdown table if the department and weekId matches with any data
    logger.d("Department in current week checking...");
    if ((openMarkdownWeek?.weekId ?? '').isNotEmpty) {
      // MLU is always LIVE
      // Open WeekId is null or empty, department cannot be in current open week.
      if (cachingService.isInitialMarkdownCachingInProgress || selectedOperation.value == MarkdownOperationEnum.mlu) {
        var fetchedData = selectedOperation.value == MarkdownOperationEnum.mlu
            ? await apiCallGetMLUCandidate()
            : await apiCallGetMarkdownCandidate();
        return fetchedData != null;
      } else {
        var markdownData = MarkdownData();
        markdownData.departmentCode = initialMarkdownFields.deptId;

        Map<String, dynamic>? fetchedData = await databaseService.selectQuery(
            tableName: TableNames.initialMarkdownTable,
            queryParams: markdownData.findMarkdownDataInDBQuery(
                openWeekId: openMarkdownWeek?.weekId ?? ''));
        logger.d("Department in current week = ${fetchedData != null}");
        return fetchedData != null;
      }
    } else {
      return false;
    }
  }

  //endregion

  //region Helper functions

  String getUserIdForPrinting(bool isDepartmentInCurrentWeek) {
    String userId = userManagementController.userData?.data?.userId ?? '';
    String digiUserId =
        "$userId${isDepartmentInCurrentWeek ? MarkdownPrintingSuffix.suffixI
        .suffixValue : MarkdownPrintingSuffix.suffixL.suffixValue}";
    return digiUserId;
  }

  Future<PerformInitialMarkdownRequest> createPerformInitialMarkdownRequest(
      MarkdownData markdownData) async {
    bool isDeptInCurrentWeek = await isDepartmentInCurrentWeek();
    String digiUserId = getUserIdForPrinting(isDeptInCurrentWeek);
    PerformInitialMarkdownRequest request =
    PerformInitialMarkdownRequest.fromMarkdownData(markdownData);
    request.isKeyed = initialMarkdownFields.isKeyed;
    request.digiUserIdForPrinting = digiUserId;
    return request;
  }

  void fillValuesInInitialMarkdownFields() {
    for (var markdownField in arrayInitialMarkdownFields) {
      switch (markdownField.sboField) {
        case SBOField.department:
          initialMarkdownFields.deptId =
              markdownField.textEditingController.text;
        case SBOField.style:
          initialMarkdownFields.styleOrULine =
              markdownField.textEditingController.text;
        case SBOField.uline:
          initialMarkdownFields.styleOrULine =
              markdownField.textEditingController.text;
        case SBOField.price:
          initialMarkdownFields.price =
              markdownField.textEditingController.text;
          initialMarkdownFields.priceInDecimal =
          initialMarkdownFields.price != null
              ? markdownField.textEditingController.text.formattedPrice
              : 0.00;
        default:
          break;
      }
    }
  }

  void showNoMarkdownDialog() {
    NavigationService.showDialog(
      subtitle: TranslationKey.noMarkdownNeeded.tr,
      title: TranslationKey.error.tr,
      buttonCallBack: () {
        Get.back();
        onClickClear();
      },
      icon: IconConstants.alertBellIcon,
    );
  }

  //endregion

  //region Stock type and print
  void printMarkdownLabel(PerformInitialMarkdownRequest request,
      PrinterSetUp printer) {
    var weekNum = isMarkdownWeekOpen.value
        ? request.weekId.substring(0, 2)
        : fiscalWeek.getCurrentFiscalWeek().toString();
    var weekLabel = isMarkdownWeekOpen.value
        ? request.weekId.substring(0, 2)
        : fiscalWeek.getCurrentFiscalWeekBarcodeFormatted();
    MarkdownLabelData markdownLabelData = MarkdownLabelData(
        digiUserId: request.digiUserIdForPrinting!,
        dept: request.departmentCode,
        price: request.outputPrice.priceInInt,
        formattedPrice:
        request.outputPrice.formattedPriceInStringToFixedTwoDecimal,
        weekNumber: weekNum,
        weekNumberLabel: weekLabel,
        uline: request.uline,
        style: request.style,
        division: storeConfigController.selectedDivision,
        classCode: request.classOrCategoryForPrinting);
    markdownLabelData.barcode =
        MarkdownBarcodeCreatingHelper().generateBarcode(markdownLabelData);
    var labelDefinition = markdownLabelData.getLabelDefinition();

    previousPrintDetails =
        PrintLabelModel(printer: printer, label: labelDefinition);

    zebraPrintService.printLabel(previousPrintDetails!);
    onClickClear();
  }

  PrinterSetUp? checkAvailablePrinterForStockAndReturnPrinter(
      StockTypeEnum stockType) {
    var availablePrinter = zebraPrintService.getPrinterForStockType(stockType);
    if (availablePrinter == null) {
      physicalResponseService.errorBeep();
      NavigationService.showDialog(
        title: TranslationKey.error.tr,
        subtitle: TranslationKey.noPrinterAvailableForStock.tr,
        buttonCallBack: () {
          Get.back();
        },
        icon: IconConstants.failedIcon,
      );
    }
    return availablePrinter;
  }

  StockTypeEnum getStockType(MarkdownData foundMarkdownData) {
    // If to and from price both ends with 99 return price adjust
    if (storeConfigController.isEurope.value) {
      return StockTypeEnum.markdown;
    }
    double fileToPrice = foundMarkdownData.toPrice!.formattedPrice;
    double fieldFromPrice = initialMarkdownFields.priceInDecimal;
    var isFileToPriceEndWith99 = RegularExpressions.initialPriceEnding99
        .hasMatch(fileToPrice.toString());
    var isFieldFromPriceEndWith99 = RegularExpressions.initialPriceEnding99
        .hasMatch(fieldFromPrice.toString());
    if (isFileToPriceEndWith99 && isFieldFromPriceEndWith99) {
      return StockTypeEnum.priceAdjust;
      // else return markdown
    } else {
      return StockTypeEnum.markdown;
    }
  }

  void enableOrDisableScanWhileMarkingDown({bool enableScan = false}) {
    if (enableScan) {
      zebraScanService.enableDataWedge();
    } else {
      zebraScanService.disableDataWedge();
    }
  }

//endregion

  Future<void> proceedWithInitialMarkdowns() async {
    enableOrDisableScanWhileMarkingDown(enableScan: false);
    (bool, Map<String, dynamic>?) markdownNeededResponse =
    await checkIfMarkdownNeeded();
    if (markdownNeededResponse.$1 && markdownNeededResponse.$2 != null) {
      var markDownDataMap = markdownNeededResponse.$2!;
      var foundItem = MarkdownData.fromJson(markDownDataMap);
      await validatePriceOnMarkdownData(markdownData: foundItem);
    }
    enableOrDisableScanWhileMarkingDown(enableScan: true);
  }

  void _setInitialIndex() {
    selectedOperation.value = MarkdownOperationEnum.initials;
    selectedIndex.value = 0;
  }
}
