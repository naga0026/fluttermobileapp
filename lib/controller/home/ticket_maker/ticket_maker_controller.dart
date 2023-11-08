import 'dart:async';

import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/controller/home/ticket_maker/shoe/shoes_%20Final_controller.dart';
import 'package:base_project/controller/login/user_management.dart';
import 'package:base_project/controller/printer/printer_list_controller.dart';
import 'package:base_project/controller/tab/main_tab_controller.dart';
import 'package:base_project/controller/validation/fiscal_week.dart';
import 'package:base_project/controller/validation/validation_controller.dart';
import 'package:base_project/model/sbo_field_model.dart';
import 'package:base_project/model/ticket_maker/ticket_maker_log_model.dart';
import 'package:base_project/model/ticket_maker/ticketmaker_printer_model.dart';
import 'package:base_project/services/printing/stock_type_service.dart';
import 'package:base_project/services/printing/zebra_print_service.dart';
import 'package:base_project/utility/constants/custom_dialog/custom_dialogsCLS.dart';
import 'package:base_project/utility/enums/sign_buttons.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/label_definition/ticketmaker_label_data.dart';
import '../../../services/navigation/navigation_service.dart';
import '../../../services/navigation/routes/route_names.dart';
import '../../../services/printing/model/print_label_model.dart';
import '../../../services/scanning/zebra_scan_service.dart';
import '../../../translations/translation_keys.dart';
import '../../../utility/enums/departmentStatus_enum.dart';
import '../../../utility/enums/pricetype_enums.dart';
import '../../../utility/enums/printerStatus_enum.dart';
import '../../../utility/enums/stock_type.dart';
import '../../../utility/helpers/ticketmaker_barcode_creating_helper.dart';
import '../../barcode/barcode_interpret_controller.dart';
import '../../store_config/store_config_controller.dart';

class TicketMakerController extends BaseViewController {
  final stockTypeService = Get.find<StockTypeService>();
  final storeConfigController = Get.find<StoreConfigController>();
  final validationController = Get.find<ValidationController>();
  final barcodeInterpreter = Get.find<BarcodeInterpretController>();
  final zebraPrintService = Get.find<ZebraPrintService>();
  final userManagementController = Get.find<UserManagementController>();
  final RxBool _isLoading = false.obs;
  final fiscalWeek = Get.find<FiscalWeekCalculationService>();

  final printerListViewController = Get.find<PrinterListViewController>();
  RxInt currentIndex = 0.obs;

  String scannedData = "";
  RxList<StockTypeEnum> stockList =
      <StockTypeEnum>[].obs; //only for navigation rail
  final _zebraScanService = Get.find<ZebraScanService>();
  late StreamSubscription<String> subscription;
  Rx<SignTypeEnum> selectedSignButton = SignTypeEnum.vertical.obs;
  RxBool fromShoes = false.obs;

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
  }

  void initializeScan() {
    subscription = _zebraScanService.scannedBarcodeStreamController.stream
        .listen((barcode) {
      scannedData = barcode;
      logger.i("Scanned barcode for TICKET MAKER $barcode");
      barcodeInterpreter.fillScannedBarcodeData(barcode, controllerTextField);
    });
  }

  void initialize() {
    fromShoes.value = false;
    storeConfigController.selectedStoreDetails.listen((_) {
      separateStockType();
    });
  }

  bool get isLoading => _isLoading.value;
  set setIsLoading(bool loading) {
    _isLoading.value = loading;
  }
  runCheckStockBeforeMovingInTM() {
    final status = checkStockBeforeNavigatingToView(stockList);
    if (status == null) {
      CustomDialog.showNoPrinterFoundDialog();
    } else if (!status) {
      CustomDialog.showStockMismatchDialog();
    }
  }
  List<SBOFieldModel> controllerTextField = [
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.department,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.category,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.uline,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.style,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.price,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(),
      sboField: SBOField.compareAt,
    ),
    SBOFieldModel(
      textEditingController: TextEditingController(text: "1"),
      sboField: SBOField.quantity,
    ),
  ];

  @override
  onInit() {
    super.onInit();
    separateStockType();
    initialize();
  }

  separateStockType() {
    var stockType = stockTypeService.updateStockTypes();
    stockType.remove(StockTypeEnum.transfers);
    bool isSign = stockType.remove(StockTypeEnum.smallSign) &&
        stockType.remove(StockTypeEnum.largeSign);
    if (isSign) {
      stockType.add(StockTypeEnum.smallSign);
    }
    stockList.value = stockType;
  }

  updateNavigationPaneOnSelectedStock(int selectedStockIndex) {
    onClickClear();
    currentIndex.value = selectedStockIndex;
    checkValidStockBeforePrinting();
  }

  fromShoesOrSignNavigationToPrinter() {
    final mainTabController = Get.find<MainTabController>();
    Get.toNamed(RouteNames.homePage)!.then((_) {
      mainTabController.currentIndex.value = 1;
      Get.back();
    });
  }

  navigateToPrinter() {
    final mainTabController = Get.find<MainTabController>();
    mainTabController.currentIndex.value = 1;
    Get.back();
  }


  Future<void> makeTmLogCall(PerformTicketMaker data,int printerStatus) async {
  await repository.apiCallAddTicketMakerLog(getTicketMakerLogData(data,printerStatus));
  }

  void printTicketMakerLabel(int? printerIndex, PerformTicketMaker data) {
    final shoeFinalScreenController = Get.find<ShoesFinalScreenController>();
    TicketMakerLabelData ticketMakerLabelData = TicketMakerLabelData(
        digiUserId: userManagementController.userData!.data!.userId,
        dept: data.department,
        compareAt: data.compareAt == null
            ? ""
            : storeConfigController.isMarshallsUSA()
                ? data.formattedPriceMarshalls(data.compareAt)
                : data.formattedPrice(data.compareAt),
        category: data.category??"00",
        division: storeConfigController.selectedDivision,
        style: storeConfigController.isMarshallsUSA() ? null : data.style,
        uline: storeConfigController.isMarshallsUSA() ? data.uline : null,
        classCode:data.category==""?"00":data.category.substring(0,2)??"00",
        line1: data.line1,
        line2: data.line2,
        YAline: data.YAline,
        quantity: fromShoes.value?int.parse(
            shoeFinalScreenController.finalTextFieldControllers.where((fields) => fields.sboField == SBOField.quantity)
            .first
            .textEditingController
            .text): int.parse(controllerTextField
            .where((fields) => fields.sboField == SBOField.quantity)
            .first
            .textEditingController
            .text),
        price: storeConfigController.isMarshallsUSA()
            ? data.price.toString().length > 5
                ? data.price.toString()
                : data.price.toString().addLeadingZeroLengthFive
            : data.price.toString().addLeadingZero,
        formattedPrice: storeConfigController.isMarshallsUSA()
            ? fromShoes.value
                ? data.formatShoesPrice(data.price)
                : data.formattedPriceMarshalls(data.price)
            : data.formattedPrice(data.price),
        weekNumber: fiscalWeek.getCurrentFiscalWeek().toString(),
        weekNumberLabel: fiscalWeek.getCurrentFiscalWeekBarcodeFormatted());
    ticketMakerLabelData.barcode = TicketMakerBarcodeCreatingHelper()
        .generateBarcode(ticketMakerLabelData);
    var labelDefinition = ticketMakerLabelData.getLabelDefinition();
    var printDetails = PrintLabelModel(
        printer: zebraPrintService.connectedPrinters[printerIndex!],
        label: labelDefinition);
    try{
      zebraPrintService.printLabel(printDetails);
    }catch(e){
      for (var itr
      in List.generate(ticketMakerLabelData.quantity, (index) => index + 1)) {
        makeTmLogCall(data,PrinterStatusEnum.printerError.index+1);
      }
    }
    for (var itr
        in List.generate(ticketMakerLabelData.quantity, (index) => index + 1)) {
      makeTmLogCall(data,itr==ticketMakerLabelData.quantity?PrinterStatusEnum.printComplete.index+1:PrinterStatusEnum.continuePrint.index+1);
    }
    onClickClear();
  }

  onClickEnter() async {
    setIsLoading = true;
    try {
      final validationStatus = await validateTMFields();
      if (validationStatus) {
        var (status, printIndex) = checkValidStockBeforePrinting();
        PerformTicketMaker printerTicketMaker = getTicketMakerDataForPrinting();
        if (printIndex != null &&
            status == PrinterStockStatusEnum.stockMatched) {
          printTicketMakerLabel(printIndex, printerTicketMaker);
        }
      }
      setIsLoading = false;
    } catch (e) {
      setIsLoading = false;
      logger.e(
          "Error in Printing Ticket Maker ${stockList[currentIndex.value].rawValue} Label | Error:$e");
    }
    setIsLoading = false;
  }

  Future<bool> validateTMFields() async {
    Map<SBOField, bool> validationStatus = {};
    for (var itr in controllerTextField) {
      if (itr.textEditingController.text.isNotEmpty) {
        switch (itr.sboField) {
          case SBOField.department:
            var (status, deptValidation) = await validationController
                .validateDepartment(itr.textEditingController.text);
            if (deptValidation == DeptValidEnum.deptInvalid ||
                deptValidation == DeptValidEnum.notFound && !status) {
              validationStatus[itr.sboField] = false;
            }
          case SBOField.style:
            if (!storeConfigController.isMarshallsUSA()) {
              if (itr.textEditingController.text.length ==
                  itr.sboField.maxLength) {
                validationStatus[itr.sboField] = validationController
                    .validateStyle(itr.textEditingController.text);
              } else {
                validationStatus[itr.sboField] = false;
              }
            }

          case SBOField.uline:
            if (storeConfigController.isMarshallsUSA()) {
              if (itr.textEditingController.text.length ==
                  itr.sboField.maxLength) {
                validationStatus[itr.sboField] = validationController
                    .validateUline(itr.textEditingController.text);
              } else {
                validationStatus[itr.sboField] = false;
              }
            }
          case SBOField.category:
            validationStatus[itr.sboField] =
                itr.textEditingController.text.length != itr.sboField.maxLength
                    ? false
                    : validationController
                        .validateCategory(itr.textEditingController.text);
          case SBOField.compareAt:
          case SBOField.price:
            validationStatus[itr.sboField] = validationController.validatePrice(
                itr.textEditingController.text,
                stockList[currentIndex.value] == StockTypeEnum.markdown
                    ? PriceTypeEnum.subs
                    : PriceTypeEnum.initial);
          default:
            break;
        }
      }
    }
    List failedValidation = [];
    validationStatus.forEach((key, value) {
      if (!value) {
        failedValidation.add(key.name);
      }
    });
    if (failedValidation.isNotEmpty) {
      NavigationService.showToast(
          "${TranslationKey.invalidInputValidation.tr} ${failedValidation.toString().replaceAll("[", "").replaceAll("]", "")}");
      onClickClear();
      return false;
    }
    return true;
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


  (PrinterStockStatusEnum, int?) checkValidStockBeforePrinting() {
    final currentStock = stockList[currentIndex.value];
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

  TicketMakerLog getTicketMakerLogData(PerformTicketMaker printerTicketMaker,int printerStatus) {
    final styleOruLine = getStyleOrUlineBasedOnDivision(printerTicketMaker);
    return TicketMakerLog(
        division: storeConfigController.selectedDivision,
        dateTime: DateTime.now(),
        userId: userManagementController.userData!.data!.userId,
        quantity: int.parse(controllerTextField
            .where((field) => field.sboField == SBOField.quantity)
            .first
            .textEditingController
            .text),
        printerStatus:printerStatus,
        handKeyed: 1,
        department: printerTicketMaker.department.length>2?printerTicketMaker.department.substring(2):printerTicketMaker.department,
        category: printerTicketMaker.category,
        styleUline: styleOruLine,
        price: int.parse(printerTicketMaker.price.replaceAll(".", "")));
  }

  PerformTicketMaker getTicketMakerDataForPrinting() {
    return PerformTicketMaker(
        department: controllerTextField
            .where((field) => field.sboField == SBOField.department)
            .first
            .textEditingController
            .text,
        compareAt: controllerTextField
            .where((field) => field.sboField == SBOField.compareAt)
            .first
            .textEditingController
            .text,
        category: controllerTextField
            .where((field) => field.sboField == SBOField.category)
            .first
            .textEditingController
            .text,
        price: controllerTextField
            .where((field) => field.sboField == SBOField.price)
            .first
            .textEditingController
            .text
            .replaceAll(".", ""),
        style: controllerTextField
            .where((field) => field.sboField == SBOField.style)
            .first
            .textEditingController
            .text,
        uline: controllerTextField
            .where((field) => field.sboField == SBOField.uline)
            .first
            .textEditingController
            .text);
  }

  getStyleOrUlineBasedOnDivision(PerformTicketMaker data) {
    return storeConfigController.isMarshallsUSA() ? data.uline : data.style;
  }
}
