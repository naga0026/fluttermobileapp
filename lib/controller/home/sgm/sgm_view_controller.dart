import 'dart:async';

import 'package:base_project/controller/barcode/barcode_interpret_controller.dart';
import 'package:base_project/controller/printer/printer_list_controller.dart';
import 'package:base_project/controller/validation/fiscal_week.dart';
import 'package:base_project/controller/validation/validation_controller.dart';
import 'package:base_project/model/api_request/get_origin_reason_code.dart';
import 'package:base_project/model/api_response/get_origin_reason_code_response.dart';
import 'package:base_project/model/label_definition/sgm_label_data.dart';
import 'package:base_project/model/price_threshold_model.dart';
import 'package:base_project/services/printing/stock_type_service.dart';
import 'package:base_project/translations/translation_keys.dart';
import 'package:base_project/utility/constants/images_and_icons/icon_constants.dart';
import 'package:base_project/utility/enums/pricetype_enums.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/api_request/perform_sgm.dart';
import '../../../model/origin_reason_model.dart';
import '../../../model/printer/printing_parameters.dart';
import '../../../model/sbo_field_model.dart';
import '../../../model/sgm/sgm_data_model.dart';
import '../../../services/navigation/navigation_service.dart';
import '../../../services/network/network_service.dart';
import '../../../services/printing/model/print_label_model.dart';
import '../../../services/printing/zebra_print_service.dart';
import '../../../services/scanning/zebra_scan_service.dart';
import '../../../utility/constants/custom_dialog/custom_dialogsCLS.dart';
import '../../../utility/enums/departmentStatus_enum.dart';
import '../../../utility/enums/price_change_type_enum.dart';
import '../../../utility/enums/printerStatus_enum.dart';
import '../../../utility/enums/stock_type.dart';
import '../../../utility/enums/style_type_enum.dart';
import '../../../utility/enums/tag_type_enum.dart';
import '../../../utility/helpers/sgm_barcode_creating_helper.dart';
import '../../base/base_view_controller.dart';
import '../../login/user_management.dart';
import '../../read_configuration/read_config_files__controller.dart';
import '../../store_config/store_config_controller.dart';

class SGMViewController extends BaseViewController {
  final stockTypeService = Get.find<StockTypeService>();
  final storeConfigController = Get.find<StoreConfigController>();
  final validationController = Get.find<ValidationController>();
  final readConfigFileController = Get.find<ReadConfigFileController>();
  final userManagementController = Get.find<UserManagementController>();
  final printerListViewController = Get.find<PrinterListViewController>();
  final zebraPrintService = Get.find<ZebraPrintService>();
  final fiscalWeekC = Get.put(FiscalWeekCalculationService());
  final networkService = Get.find<NetworkService>();
  final langCode = Get.deviceLocale!.languageCode;
  Rxn<int> reprintLogId = Rxn<int>();
  SGMLabelData? rePrintLabelData;
  TagTypeEnum? rePrintTagType;

  final sgmStockType = [
    StockTypeEnum.markdown,
    StockTypeEnum.priceAdjust,
    StockTypeEnum.stickers,
  ];

  Rxn<List<String>> origins = Rxn<List<String>>();
  Rxn<List<String>> reasons = Rxn<List<String>>();
  Rxn<List<OriginReasonModel>> reasonsList = Rxn<List<OriginReasonModel>>();
  final _zebraScanService = Get.find<ZebraScanService>();
  late StreamSubscription<String> subscription;
  SgmInputScreenDataModel sgmFields = SgmInputScreenDataModel();

  final RxList<SBOFieldModel> controllerTextField = [
    SBOFieldModel(
        sboField: SBOField.department,
        textEditingController: TextEditingController(),
        focusNode: FocusNode()),
    SBOFieldModel(
        textEditingController: TextEditingController(),
        sboField: SBOField.sgmCategory,
        focusNode: FocusNode()),
    SBOFieldModel(
        textEditingController: TextEditingController(),
        sboField: SBOField.uline,
        focusNode: FocusNode()),
    SBOFieldModel(
        textEditingController: TextEditingController(),
        sboField: SBOField.style,
        focusNode: FocusNode()),
    SBOFieldModel(
        textEditingController: TextEditingController(),
        sboField: SBOField.currentPrice,
        focusNode: FocusNode()),
    SBOFieldModel(
        textEditingController: TextEditingController(),
        sboField: SBOField.newPrice,
        focusNode: FocusNode()),
    SBOFieldModel(
        textEditingController: TextEditingController(),
        sboField: SBOField.quantity),
  ].obs;

  StyleTypeEnum styleTypeForStore = StyleTypeEnum.style;
  final barcodeInterpreter = Get.find<BarcodeInterpretController>();

  String newPriceString = "";

  int moosPriceThreshold = 9900;

  GetOriginAndReasonDataResponse? originDataResponse;

  GetOriginAndReasonDataResponse? reasonDataResponse;

  @override
  void onInit() {
    super.onInit();
    onClickClear();
    getSGMData();
  }

  // void updateInitSubsFields() {
  //   if (styleTypeForStore == StyleTypeEnum.uline) {
  //     controllerTextField[2] = SBOFieldModel(
  //         sboField: SBOField.uline,
  //         textEditingController: TextEditingController());
  //   }else
  //     {
  //       controllerTextField[2] = SBOFieldModel(
  //           sboField: SBOField.style,
  //           textEditingController: TextEditingController());
  //     }
  // }

  // void initialSetUp() {
  //   styleTypeForStore = storeConfigController.checkForStyleOrULine();
  //   updateInitSubsFields();
  // }

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
  }

  void initialize() {
    subscription = _zebraScanService.scannedBarcodeStreamController.stream
        .listen((barcode) {
      logger.i("Scanned barcode for SGM $barcode");
      barcodeInterpreter.fillScannedBarcodeData(barcode, controllerTextField);
    });
    storeConfigController.selectedStoreDetails.listen((_) {
      // separateStockType();
    });
  }

  onChangeTabClear() {
    selectedOrigin.value = null;
    selectedReason.value = null;
  }

  onChangeDivision() async {
    origins.value = null;
    reasons.value = null;
    if (origins.value == null && reasons.value == null) {
      await getSGMData();
    }
  }

  var selectedOrigin = Rxn<String>();
  var selectedReason = Rxn<String>();
  var quantity = 0;

  Future<void> getOriginCodes() async {
    origins.value = null;
    // LoadingOverlay.show();
    GetOriginReasonCodeRequest originCodeRequest = GetOriginReasonCodeRequest(
        divisionCode: storeConfigController.selectedDivision,
        languageCode: langCode);
    originDataResponse =
        await repository.getOriginCodeData(request: originCodeRequest);
    origins.value =
        originDataResponse?.data?.map((e) => e.shortDescription ?? '').toList();
    //LoadingOverlay.hide();
  }

  Future<void> getReasonCodes() async {
    reasons.value = null;
    reasonsList.value = null;
    //LoadingOverlay.show();
    GetOriginReasonCodeRequest reasonCodeRequest = GetOriginReasonCodeRequest(
        divisionCode: storeConfigController.selectedDivision,
        languageCode: langCode);
    reasonDataResponse =
        await repository.getReasonCodeData(request: reasonCodeRequest);

    reasons.value =
        reasonDataResponse?.data?.map((e) => e.shortDescription ?? '').toList();
    reasonsList.value = reasonDataResponse?.data;
    //LoadingOverlay.hide();
  }

  bool getIsZeroPriceForReason() {
    if (reasonsList.value != null) {
      for (OriginReasonModel element in reasonsList.value!) {
        if (element.shortDescription == selectedReason.value) {
          //logger.d("${element.shortDescription} and  ${element.isZeroPrice}");
          return element.isZeroPrice ?? false;
        }
      }
    }
    return false;
  }

  Future<void> getSGMData() async {
    await getOriginCodes();
    await getReasonCodes();
  }

  void onOriginChange(String origin) {
    selectedOrigin.value = origin;
    selectedReason.value = null;
    logger.i("Origin has been set to $origin");
  }

  onClickClear() {
    for (var e in controllerTextField) {
      if (e.sboField == SBOField.quantity) {
        e.textEditingController.text = "1";
      } else {
        e.textEditingController.clear();
      }
    }
  }

  void onReasonChange(String reason) {
    selectedReason.value = reason;
    onClickClear();
    logger.i("Reason has been changed to $reason");
    // var homeController = Get.find<HomeController>();
    // homeController.changeDataWedgeStatus(isEnable: true);
  }

  onClickEnter() async {
    (Map<SBOField, bool>, int?, int?) validationStatus =
        await validateSGMFields();
    List failedValidation = [];
    validationStatus.$1.forEach((key, value) {
      if (!value) {
        failedValidation.add(key.name);
      }
    });
    if (failedValidation.isNotEmpty) {
      NavigationService.showToast(
          "${TranslationKey.invalidInputValidation.tr} ${failedValidation.toString().replaceAll("[", "").replaceAll("]", "")}");
      onClickClear();
    } else {
      await getNewPriceTypeAndPerformAction(
          validationStatus.$2, validationStatus.$3);
    }
  }

  Future<(Map<SBOField, bool>, int?, int?)> validateSGMFields() async {
    Map<SBOField, bool> validationStatus = {};
    int? fromPrice = 0;
    int? toPrice = 0;
    for (var fields in controllerTextField) {
      if (fields.textEditingController.text.isNotEmpty) {
        switch (fields.sboField) {
          case SBOField.department:
            if (fields.textEditingController.text.length == 4) {
              sgmFields.deptId =
                  fields.textEditingController.text.substring(2, 4);
            } else {
              sgmFields.deptId = fields.textEditingController.text;
            }
            var (status, deptValidation) = await validationController
                .validateDepartment(fields.textEditingController.text);
            if (deptValidation == DeptValidEnum.deptInvalid ||
                deptValidation == DeptValidEnum.notFound && !status) {
              validationStatus[fields.sboField] = false;
            }
          case SBOField.style:
            if (!storeConfigController.isMarshallsUSA()) {
              if (fields.textEditingController.text.length ==
                  fields.sboField.maxLength) {
                sgmFields.styleOrULine = fields.textEditingController.text;
                validationStatus[fields.sboField] =
                    await validationController.validateWithStyleRanges(
                        fields.textEditingController.text, sgmFields.deptId!);
              } else {
                validationStatus[fields.sboField] = false;
              }
            }

          case SBOField.uline:
            if (storeConfigController.isMarshallsUSA()) {
              if (fields.textEditingController.text.length ==
                  fields.sboField.maxLength) {
                sgmFields.styleOrULine = fields.textEditingController.text;
                validationStatus[fields.sboField] = validationController
                    .validateUline(fields.textEditingController.text);
              } else {
                validationStatus[fields.sboField] = false;
              }
            }
          case SBOField.sgmCategory:
            sgmFields.classOrCategoryId = fields.textEditingController.text;
            validationStatus[fields.sboField] =
                fields.textEditingController.text.length !=
                        fields.sboField.maxLength
                    ? false
                    : validationController
                        .validateCategory(fields.textEditingController.text);
          case SBOField.currentPrice:
            sgmFields.currentPriceInDisplay = fields.textEditingController.text;
            validationStatus[fields.sboField] =
                validationController.validatePrice(
                    fields.textEditingController.text,
                    PriceTypeEnum.initialOrSubs);
            fromPrice = int.parse(
                fields.textEditingController.text.replaceAll('.', ''));
          case SBOField.newPrice:
            sgmFields.newPriceInDisplayFormat =
                fields.textEditingController.text;
            if (getIsZeroPriceForReason()) {
              validationStatus[fields.sboField] =
                  validationController.validatePrice(
                      fields.textEditingController.text,
                      PriceTypeEnum.initialOrSubs);
            }
            toPrice = int.parse(
                fields.textEditingController.text.replaceAll('.', ''));
            newPriceString = fields.textEditingController.text;
          case SBOField.quantity:
            quantity = int.tryParse(fields.textEditingController.text) ?? 1;
          default:
            break;
        }
      }
    }
    return (validationStatus, fromPrice, toPrice);
  }

  getNewPriceTypeAndPerformAction(int? fromPrice, int? toPrice) async {
    var priceChangeType = getChangeType(fromPrice, toPrice);
    logger.d(priceChangeType);
    if (priceChangeType == PriceChangeType.NoChange) {
      NavigationService.showDialog(
          title: "Error",
          subtitle: "New price cannot equal current price.",
          buttonText: "OK",
          buttonCallBack: () async {
            onClickClear();
            Get.back();
          },
          icon: IconConstants.failedIcon);
      return;
    }
    if (await checkStockTypeIsCorrectForGivenPriceType(priceChangeType)) {
      if (quantity > 1) {
        NavigationService.showDialog(
            title: "VERIFY QUANTITY: $quantity",
            subtitle: "ARE YOU SURE?",
            buttonText: "YES",
            isAddCancelButton: true,
            cancelButtonText: "NO",
            buttonCallBack: () async {
              Get.back();
              await printOrDisplayPrintingAlert(
                  priceChangeType, fromPrice, toPrice);
            },
            icon: IconConstants.successIcon);
        return;
      } else {
        await printOrDisplayPrintingAlert(priceChangeType, fromPrice, toPrice);
      }
    }
  }

  PriceChangeType getChangeType(int? fromPrice, int? toPrice) {
    if (fromPrice != null && toPrice != null) {
      logger.d("fromPrice = $fromPrice, toPrice = $toPrice");
      if (toPrice == 0 && fromPrice != 0) {
        return PriceChangeType.ToZeroMarkdown;
      } else if (toPrice > fromPrice) {
        return PriceChangeType.Markup;
      } else if (toPrice < fromPrice) {
        return PriceChangeType.Markdown;
      }
      return PriceChangeType.NoChange;
    }
    return PriceChangeType.NoChange;
  }

  checkStockTypeIsCorrectForGivenPriceType(PriceChangeType priceChangeType) {
    var newPriceType = validationController.getPriceType(newPriceString);
    logger.d(newPriceType);
    PrintingParameters? printingParameters =
        chooseLabelTypeForPrinting(newPriceType, priceChangeType);
    if (printingParameters != null) {
      var (status, _) =
          checkValidStockBeforePrinting(printingParameters.stockType);
      if (status == PrinterStockStatusEnum.stockMatched) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  PrintingParameters? chooseLabelTypeForPrinting(
      PriceTypeEnum newPriceType, PriceChangeType priceChangeType) {
    if (storeConfigController.isEurope.value ||
        newPriceType == PriceTypeEnum.subs) {
      logger.d(
          "SubsCondition = $newPriceString, PriceChange-type = $priceChangeType");
      var tagType = priceChangeType == PriceChangeType.ToZeroMarkdown
          ? TagTypeEnum.markdownToZero
          : TagTypeEnum.markdown;
      return PrintingParameters(StockTypeEnum.markdown, tagType);
    } else if (newPriceType == PriceTypeEnum.initial) {
      logger.d(
          "Condition = $newPriceString, PriceChange-type = $priceChangeType");
      return priceChangeType == PriceChangeType.Markup
          ? PrintingParameters(StockTypeEnum.stickers, TagTypeEnum.sticker)
          : PrintingParameters(
              StockTypeEnum.priceAdjust, TagTypeEnum.priceAdjust);
    }
    return null;
  }

  Future<void> printOrDisplayPrintingAlert(
      PriceChangeType priceChangeType, int? fromPrice, int? toPrice) async {
    bool isExcessive = checkIfPriceChangeIsExcessive(
        fromPrice, toPrice, getIsZeroPriceForReason());
    if (isExcessive && storeConfigController.isEurope.value) {
      //TO DO: For EU authorization code need to add
      return;
    }
    if (priceChangeType == PriceChangeType.Markup) {
      displayMarkupPrintingAlert(
          priceChangeType, fromPrice, toPrice, isExcessive);
    } else if (!storeConfigController.isEurope.value &&
        showExcessiveWarning(priceChangeType, fromPrice, toPrice)) {
      //PhysicalResponseService.S2Beep();
      displayMarkdownExcessivePrintingAlert(
          priceChangeType, fromPrice, toPrice);
    } else {
      await performSGM(priceChangeType, fromPrice, toPrice);
    }
  }

  bool checkIfPriceChangeIsExcessive(
      int? fromPrice, int? toPrice, bool isMOOS) {
    if (isMOOS) {
      return fromPrice! > moosPriceThreshold;
    }
    if (toPrice == 0) return true;

    double threshold = thresholdForSelectedDivision();

    var maxPrice = fromPrice! * (1 + (threshold / 100));
    var minPrice = fromPrice * (1 - (threshold / 100));

    if (storeConfigController.isEurope.value) {
      return toPrice! >= maxPrice.toInt() || toPrice <= minPrice.toInt();
    }
    return toPrice! >= maxPrice || toPrice <= minPrice;
  }

  double thresholdForSelectedDivision() {
    final List<PriceThresholdParameters>? thresholdForDivisions =
        readConfigFileController.priceThresholdParameters;
    var threshold = double.parse(thresholdForDivisions!
        .where((p) => p.divisionCode == storeConfigController.selectedDivision)
        .first
        .threshold);
    return threshold;
  }

  displayMarkupPrintingAlert(PriceChangeType priceChangeType, int? fromPrice,
      int? toPrice, bool isExcessive) {
    final currentPrice = controllerTextField
        .where((field) => field.sboField == SBOField.currentPrice)
        .first
        .textEditingController
        .text;
    final newPrice = controllerTextField
        .where((field) => field.sboField == SBOField.newPrice)
        .first
        .textEditingController
        .text;

    String label = "";
    if (storeConfigController.isEurope.value) {
      label = "This is a Markup";
    } else {
      label = isExcessive ? "Markup is excessive" : "This is a Markup";
    }
    var message =
        "Curr Price: ${storeConfigController.getCurrencySymbol()}$currentPrice\n"
        "New Price: ${storeConfigController.getCurrencySymbol()}$newPrice\n\n"
        "$label\n\n";
    NavigationService.showDialog(
        title: message,
        subtitle: "ARE YOU SURE?",
        buttonText: "YES",
        isAddCancelButton: true,
        cancelButtonText: "NO",
        buttonCallBack: () async {
          Get.back();
// final field = controllerTextField.where((element) => element.sboField==SBOField.currentPrice).first.textEditingController.text="";
// field.first.textEditingController.text = ""
          await performSGM(priceChangeType, fromPrice, toPrice);
        },
        icon: IconConstants.successIcon);
    return;
  }

  bool showExcessiveWarning(
      PriceChangeType priceChangeType, int? fromPrice, int? toPrice) {
    var isExcessive = checkIfPriceChangeIsExcessive(
        fromPrice, toPrice, getIsZeroPriceForReason());

    var markdownExcessiveAlertCondition =
        priceChangeType == PriceChangeType.Markdown && isExcessive;
    var moosMarkdownExcessiveAlertCondition =
        getIsZeroPriceForReason() && isExcessive;
    if (!getIsZeroPriceForReason()) {
      markdownExcessiveAlertCondition |=
          priceChangeType == PriceChangeType.ToZeroMarkdown;
    }
    return markdownExcessiveAlertCondition ||
        moosMarkdownExcessiveAlertCondition;
  }

  displayMarkdownExcessivePrintingAlert(
      PriceChangeType priceChangeType, int? fromPrice, int? toPrice) {
    final currentPrice = controllerTextField
        .where((field) => field.sboField == SBOField.currentPrice)
        .first
        .textEditingController
        .text;
    final newPrice = controllerTextField
        .where((field) => field.sboField == SBOField.newPrice)
        .first
        .textEditingController
        .text;
    var message =
        "Curr Price: ${storeConfigController.getCurrencySymbol()}$currentPrice\n"
        "New Price: ${storeConfigController.getCurrencySymbol()}$newPrice\n\n"
        "Markdown is excessive\n\n";
    NavigationService.showDialog(
        title: message,
        subtitle: "ARE YOU SURE?",
        buttonText: "YES",
        isAddCancelButton: true,
        cancelButtonText: "NO",
        buttonCallBack: () async {
          Get.back();
// final field = controllerTextField.where((element) => element.sboField==SBOField.currentPrice).first.textEditingController.text="";
// field.first.textEditingController.text = ""
          await performSGM(priceChangeType, fromPrice, toPrice);
        },
        icon: IconConstants.successIcon);
    return;
  }

  Future<void> performSGM(
      PriceChangeType priceChangeType, int? fromPrice, int? toPrice) async {
    var newPriceType = validationController.getPriceType(newPriceString);
    PrintingParameters? printingParameters =
        chooseLabelTypeForPrinting(newPriceType, priceChangeType);
    var sgmPostDataModel =
        getPerformSgmDataModel(sgmFields, fromPrice, toPrice);

    var performSgmResult = await repository.postSGM(request: sgmPostDataModel);

    if (performSgmResult == null) {
      return;
    }
    var fiscalWeekCalculationRequired =
        performSgmResult.data?.activeWeekNumber.isEmpty;
    reprintLogId.value = performSgmResult.data!.id;

    if (printingParameters != null) {
      if (fiscalWeekCalculationRequired!) {
        printRespectiveLabelForSGM(
            toPrice.toString(),
            fiscalWeekC.getCurrentFiscalWeekBarcodeFormatted(),
            printingParameters.tagType);
      } else {
        printRespectiveLabelForSGM(
            toPrice.toString(),
            performSgmResult.data?.activeWeekNumber,
            printingParameters.tagType);
      }
    }
  }

  PerformSgmPostDataModel getPerformSgmDataModel(
      SgmInputScreenDataModel sgmFields, int? fromPrice, int? toPrice) {
    var ulineID =
        storeConfigController.isMarshallsUSA() ? sgmFields.styleOrULine : null;
    var styleID =
        storeConfigController.isMarshallsUSA() ? null : sgmFields.styleOrULine;
    var division = storeConfigController.selectedDivision;
    var storeNum = storeConfigController.selectedStoreNumber;
    var digiUserId = userManagementController.userData?.data?.userId;
    var deviceType = "PDA";
    var deviceId = networkService.deviceIP;

    var originCodeId = originDataResponse?.data
        ?.firstWhere(
            (element) => element.shortDescription == selectedOrigin.value)
        .code;

    var reasonCodeId = reasonDataResponse?.data
        ?.firstWhere(
            (element) => element.shortDescription == selectedReason.value)
        .code;
    var intFromPrice = fromPrice;
    var intToPrice = toPrice;
    var quant = quantity;
    var itemSize = "";
    var type = "";
    var pieces = "";

    return PerformSgmPostDataModel(
        departmentCode: sgmFields.deptId,
        divisionCode: division,
        storeNumber: storeNum,
        reasonCode: reasonCodeId,
        originCode: originCodeId,
        style: styleID,
        uline: ulineID,
        userId: digiUserId,
        deviceType: deviceType,
        deviceId: deviceId,
        fromPrice: intFromPrice,
        toPrice: intToPrice,
        category: sgmFields.classOrCategoryId,
        quantity: quant,
        isKeyed: true,
        itemSize: itemSize,
        type: type,
        pieces: pieces,
        method: "SGM",
        authorizingUserId: "");
  }

  runCheckStockBeforeMovingInSGM() {
    final status = checkStockBeforeNavigatingToView(sgmStockType);
    if (status == null) {
      CustomDialog.showNoPrinterFoundDialog();
    } else if (!status) {
      CustomDialog.showStockMismatchDialog();
    }
  }

  (PrinterStockStatusEnum, int?) checkValidStockBeforePrinting(
      StockTypeEnum currentStock) {
    // final currentStock = stockList[currentIndex.value];
    if (printerListViewController.connectedPrinters.isEmpty) {
      CustomDialog.showNoPrinterFoundDialog();
      return (PrinterStockStatusEnum.printerNotFound, null);
    } else {
      for (var printerData in printerListViewController.connectedPrinters) {
        if (printerData.printerStock.getPrinterStockTypeFromString ==
                currentStock ||
            printerData.printerStock.getPrinterStockTypeFromString ==
                    StockTypeEnum.smallSign &&
                currentStock == StockTypeEnum.largeSign ||
            printerData.printerStock.getPrinterStockTypeFromString ==
                    StockTypeEnum.largeSign &&
                currentStock == StockTypeEnum.smallSign) {
          return (
            PrinterStockStatusEnum.stockMatched,
            printerListViewController.connectedPrinters.indexOf(printerData)
          );
        } else {
          CustomDialog.showStockMismatchDialog();
          return (PrinterStockStatusEnum.stockMismatched, null);
        }
      }
    }
    return (PrinterStockStatusEnum.printerNotFound, null);
  }
  //
  // bool? checkStockBeforeNavigatingToViewSGM() {
  //   bool? status;
  //   if (printerListViewController.connectedPrinters.isNotEmpty ||
  //       printerListViewController.connectedPrinters != []) {
  //     for (var printer in printerListViewController.connectedPrinters) {
  //       if (sgmStockType
  //           .contains(printer.printerStock.getPrinterStockTypeFromString)) {
  //         status = true;
  //       } else {
  //         status = false;
  //       }
  //     }
  //   }
  //   return status;
  // }

  void printRespectiveLabelForSGM(
      String toPrice, String? fiscalWeek, TagTypeEnum tagType) {
    final sgmLabelData = SGMLabelData(
        division: storeConfigController.selectedDivision,
        departmentCode: controllerTextField
            .where((field) => field.sboField == SBOField.department)
            .first
            .textEditingController
            .text,
        category: controllerTextField
            .where((field) => field.sboField == SBOField.sgmCategory)
            .first
            .textEditingController
            .text,
        classCode: controllerTextField
            .where((field) => field.sboField == SBOField.sgmCategory)
            .first
            .textEditingController
            .text.substring(0,2),
        uline: storeConfigController.isMarshallsUSA()
            ? controllerTextField
                .where((field) => field.sboField == SBOField.uline)
                .first
                .textEditingController
                .text
            : "",
        style: storeConfigController.isMarshallsUSA()
            ? ""
            : controllerTextField
                .where((field) => field.sboField == SBOField.style)
                .first
                .textEditingController
                .text,
        userId: userManagementController.userData!.data!.userId,
        toPrice: storeConfigController.isMarshallsUSA()
            ? toPrice.length > 5
                ? toPrice
                : toPrice.addLeadingZeroLengthFive
            : toPrice.addLeadingZero,
        weekNumber: fiscalWeek,
        weekNumberLabel: fiscalWeek,
        quantity: int.parse(controllerTextField
            .where((field) => field.sboField == SBOField.quantity)
            .first
            .textEditingController
            .text));
    sgmLabelData.barcode =
        SGMBarcodeCreatingHelper().generateBarcode(sgmLabelData);
    var labelDefinition = sgmLabelData.getLabelDefinition(tagType: tagType);

    var printDetails = PrintLabelModel(
        printer: zebraPrintService.connectedPrinters[0],
        label: labelDefinition);
    rePrintLabelData = sgmLabelData;
    rePrintTagType = tagType;
    zebraPrintService.printLabel(printDetails);
    onClickClear();
  }

  void reprint() {
    if (reprintLogId.value != null &&
        rePrintLabelData != null &&
        rePrintTagType != null) {
      repository.rePrintSGM(rePrintId: reprintLogId.value!).then((value) {
        rePrintLabelData!.quantity = 1;
        zebraPrintService.printLabel(PrintLabelModel(
            label:
                rePrintLabelData!.getLabelDefinition(tagType: rePrintTagType!),
            printer: zebraPrintService.connectedPrinters[0]));
      });
    }
  }
}
