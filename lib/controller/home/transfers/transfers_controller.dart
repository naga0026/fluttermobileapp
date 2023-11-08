import 'dart:async';
import 'package:base_project/controller/base/base_view_controller.dart';
import 'package:base_project/controller/login/user_management.dart';
import 'package:base_project/controller/read_configuration/read_config_files__controller.dart';
import 'package:base_project/controller/store_config/store_config_controller.dart';
import 'package:base_project/controller/validation/validation_controller.dart';
import 'package:base_project/model/api_request/transfers/add_or_delete_item_tobox_transfers_request.dart';
import 'package:base_project/model/api_request/transfers/change_receiver_transfer_req_model.dart';
import 'package:base_project/model/api_request/transfers/end_item_inbox_transfers_request.dart';
import 'package:base_project/model/api_request/transfers/reprint_label_transfers_request.dart';
import 'package:base_project/model/api_request/transfers/validate_control_number_transfers_request.dart';
import 'package:base_project/model/api_request/transfers/void_box_transfers_request.dart';
import 'package:base_project/model/api_response/transfers/inquire_box_transfers_response.dart';
import 'package:base_project/model/api_response/transfers/store_address_transfers_response.dart';
import 'package:base_project/model/label_definition/transfer_label_data.dart';
import 'package:base_project/model/transfers/damged_jewelry_json_model.dart';
import 'package:base_project/model/transfers/transfers_model.dart';
import 'package:base_project/services/scanning/zebra_scan_service.dart';
import 'package:base_project/ui_controls/sbo_text_field.dart';
import 'package:base_project/ui_controls/transfer_item_screen.dart';
import 'package:base_project/utility/constants/app/app_constants.dart';
import 'package:base_project/utility/constants/custom_dialog/custom_dialogsCLS.dart';
import 'package:base_project/utility/constants/images_and_icons/icon_constants.dart';
import 'package:base_project/utility/enums/transfers_response_enums.dart';
import 'package:base_project/utility/extensions/int_extension.dart';
import 'package:base_project/utility/extensions/int_to_enum_extension.dart';
import 'package:base_project/utility/extensions/string_extension.dart';
import 'package:base_project/utility/logger/logger_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/api_response/transfers/end_item_inbox_transfers_response.dart';
import '../../../model/sbo_field_model.dart';
import '../../../model/transfers/control_number_model.dart';
import '../../../services/navigation/navigation_service.dart';
import '../../../services/printing/model/print_label_model.dart';
import '../../../services/printing/zebra_print_service.dart';
import '../../../translations/translation_keys.dart';
import '../../../utility/enums/departmentStatus_enum.dart';
import '../../../utility/enums/division_enum.dart';
import '../../../utility/enums/pricetype_enums.dart';
import '../../../utility/enums/transfers_enum.dart';
import '../../../view/home/transfers/receiving_item_confirmation.dart';
import '../../barcode/barcode_interpret_controller.dart';
import '../../barcode/scanned_item_model.dart';
import '../home_view_controller.dart';
part 'transfers_receiving_controller_extension.dart';
part 'transfers_receiving_item_confirmation_extension.dart';


class TransfersController extends BaseViewController {
  //region Variables
  final RxnString controlNumberStrValue = RxnString();
  final RxnString storedControlNumberForReprintPurpose = RxnString();

  final readController = Get.find<ReadConfigFileController>();
  StoreAddressResponse? storeAddress;


  Rxn<NewBoxOptions> selectedBoxMenuItem =
  Rxn<NewBoxOptions>(NewBoxOptions.addBox);
  final zebraPrintService = Get.find<ZebraPrintService>();
  final validationController = Get.find<ValidationController>();
  AddORDeleteItemToBoxTransferModel addItemModel =
  AddORDeleteItemToBoxTransferModel();
  late StreamSubscription<String> subscription;
  RxBool isAddItem = true.obs;
  DamagedJeweleryModel? dModelData;

  List<SBOFieldModel> scanFields = [
    SBOFieldModel(
        sboField: SBOField.department,
        textEditingController: TextEditingController()),
    SBOFieldModel(
        sboField: SBOField.style,
        textEditingController: TextEditingController()),
    SBOFieldModel(
        sboField: SBOField.price,
        textEditingController: TextEditingController()),
  ];
  RxBool canProceed = false.obs;

  SBOFieldModel storeNumber = SBOFieldModel(
      sboField: SBOField.storeNumber,
      textEditingController: TextEditingController());
  SBOFieldModel controlNumber = SBOFieldModel(
      sboField: SBOField.controlNumber,
      textEditingController: TextEditingController());

  List<NewBoxOptions> options = [
    NewBoxOptions.addBox,
    NewBoxOptions.deleteBox,
    NewBoxOptions.voidBox,
    NewBoxOptions.inquireBox,
    NewBoxOptions.endBox,
  ];
  final scanResult = Rxn<String>();
  final storeConfigController = Get.find<StoreConfigController>();
  final barcodeController = Get.find<BarcodeInterpretController>();
  final userMgmtController = Get.find<UserManagementController>();
  final zebraServices = Get.find<ZebraScanService>();

  //Shipping or Receiving
  final Rx<TransfersDirection> currentSegment = Rx<TransfersDirection>(TransfersDirection.shipping);

  // Store to store, damaged jewelry etc
  final Rxn<TransferType> selectedTransferType = Rxn<TransferType>();

  // New box/ end box etc
  final Rxn<ShippingActions> selectedShippingAction = Rxn<ShippingActions>();

  final RxInt _currentStep = 0.obs;
  get currentStep => _currentStep;
  get storeNumberString =>
      storeNumber.textEditingController.text.makeFourDigitStoreNumber;
  get damagedJeweleryJsonData=>readController.damagedJeweleryModel;

  setCurrentStep(index) {
    _currentStep.value = index;
  }

  // Receiving fields
  List<SBOFieldModel> storeToStoreReceivingFields = [
    SBOFieldModel(
        sboField: SBOField.controlNumber,
        textEditingController: TextEditingController(),
        focusNode: FocusNode()),
    SBOFieldModel(
        sboField: SBOField.storeNumber,
        textEditingController: TextEditingController(),
        focusNode: FocusNode()),
    SBOFieldModel(
        sboField: SBOField.itemCount,
        textEditingController: TextEditingController(),
        focusNode: FocusNode()),
  ];
  ScanOrEnteredTransferReceivingItem receivedItemData =
  ScanOrEnteredTransferReceivingItem.empty();
  SBOFieldModel itemConfirmationField = SBOFieldModel(
      sboField: SBOField.itemCount,
      textEditingController: TextEditingController());

  //endregion



  Future<StoreAddressResponse> getStoreAddress(storeNumber)async{
    return await repository.getStoreAddress(
        storeNumber, storeConfigController.selectedDivision);
  }

  Future<(String, StoreAddressResponse?)> getControllerNumber(
      String storeNumber,{isDamagedJewellery=false}) async {
    try {
      if(isDamagedJewellery){
        retrieveDJDataFromJsonFile();
      }
      final transfersModel = getTModel(storeNumber: storeNumber);
      logger.d(":::::::::::::::::::${transfersModel.toJson()}");
      final res = await repository.getControlNumber(transfersModel);
      storeAddress = isDamagedJewellery?null:await getStoreAddress(storeNumber);
      LoggerConfig.logger.d("Controller Number:$res");
      if (res != "") {
        controlNumberStrValue.value = res;
        canProceed.value = true;
        var labelDefinition = TransfersLabelData(controlNumber: res)
            .getLabelDefinition(cnd: LabelCondition.controlNumber);
        printGivenData(labelDefinition);
      } else {
        CustomDialog.showDialogInTransferError("Invalid Store or Control Number");
      }
      return (res, storeAddress);
    } catch (e) {
      logger.e("Unable to fetch ControlNumber due to | Issue: $e");
      NavigationService.showToast("Unable to fetch ControlNumber");
      return ("",storeAddress);
    }
  }

  //region Overrides
  @override
  void onInit() {
    super.onInit();
    _updateFields();
  }

  //endregion

  void initializeScan() {
    subscription =
        zebraServices.scannedBarcodeStreamController.stream.listen((barcode) {
          if ((barcode ?? '').isNotEmpty &&
              barcode.length == AppConstants.transfersControlNumberLength) {
            controlNumber.textEditingController.text = barcode;
          } else if (barcode.length == AppConstants.transfersBarcodeLength) {
            onScannedTransfersReceivingBarcode(barcode);
          } else {
            barcodeController.fillScannedBarcodeData(barcode, scanFields);
            addItem();
          }
          logger.i("Scanned barcode for TRANSFERS $barcode");
        });
  }

  /// Depending on the division the app is running, Style/ULine fields will
  /// be changed in the fields. This function will check if that change is required
  /// if so, it will update the array of field
  void _updateFields() {
    if (storeConfigController.selectedDivision.getDivisionName ==
        DivisionEnum.marshallsUsa) {
      scanFields[1] = SBOFieldModel(
          sboField: SBOField.uline,
          textEditingController: TextEditingController());
    }
  }

  //endregion

  changeReceiverStoreNumberTransfer(EndItemToBoxTransferModel tModel) async {
    openPopUpToEnterStoreNumber(() async {
      final response = await repository.changeReceiverTransfer(
          ChangeReceiverTransfersModel(
              currentDivision: tModel.currentDivision,
              currentStore: tModel.currentStore,
              userId: tModel.userId,
              controlNumber: tModel.controlNumber,
              oldReceiverDivision: tModel.currentDivision,
              oldReceiverId: tModel.currentStore,
              newReceiverDivision: storeConfigController.selectedDivision,
              newReceiverId: storeNumber
                  .textEditingController.text.makeFourDigitStoreNumber,
              transferType: tModel.transferType));
      print("::::::::::::::::$response");
      Get.back();
    });
  }

  performEndBoxTransfer({String? cNum}) async {
    final endBoxModel = EndItemToBoxTransferModel(
        currentDivision: storeConfigController.selectedDivision,
        currentStore: storeConfigController
            .selectedStoreNumber, //storeNumber.textEditingController.text.makeFourDigitStoreNumber,
        userId: userMgmtController.userData!.data!.userId,
        controlNumber: cNum ?? controlNumber.textEditingController.text,
        transferDirection: getTransferDirection(),
        transferType: getTransferType(),
        alternativeShippingDivision: null,
        alternativeShippingLocation: null);

    EndBoxTransfersResponse status = await repository.endItemInBox(endBoxModel);
    print("::::::::::${status.toJson()}");
    switch(status.boxResultStatus.getBoxResultStatusEnumFromInt){
      case BoxResultStatusEnum.noEnd:
        CustomDialog.showDialogInTransferError("There is no End!");
        break;
      case BoxResultStatusEnum.wrongTransferType:
        CustomDialog.showDialogInTransferError("Wrong Transfer Type Error!");
        break;
      case BoxResultStatusEnum.noItems:
        CustomDialog.showDialogInTransferError("There are no items in Box!");
        break;
      case BoxResultStatusEnum.confirmLocation:
        CustomDialog.showDialogInTransferError("Please Confirm Location");
        break;
      case BoxResultStatusEnum.systemError:
        CustomDialog.showDialogInTransferError("There is an System error!");
        break;
      case BoxResultStatusEnum.boxEnded:
        CustomDialog.showEndBoxWithParameters(
            storeNumber: status.locationId.toString(),
            onClickYes: () {
              Get.back();
              printEndBoxData(status);
              Get.back();
            },
            onClickNo: () {
              changeReceiverStoreNumberTransfer(endBoxModel);
              Get.back();
            });
        break;
      case BoxResultStatusEnum.noBox:
        CustomDialog.showDialogInTransferError("There is No Box!");
        break;
      default:
        return CustomDialog.showDialogInTransferError("There is an error!");
    }
  }

  openPopUpToEnterStoreNumber(VoidCallback onClick) {
    return CustomDialog.showDialogInTransferScreen(
        title: "Enter Destination",
        buttonCallBack: onClick,
        icon: IconConstants.alertBellIcon,
        isCancelButtonRequired: true,
        content: SBOInputField(sboFieldModel: storeNumber),
        buttonText: "Add",
        cancelButtonText: "Cancel",
        subtitle: "",
        showTitle: true,
        cancelButtonCallBack: () {
          clearSelectedActionButton();
        });
  }

  Future<String> performDamagedJewellery() async {
    final response = await repository.damagedJewelleryDatePicker(
        storeNumber: storeConfigController.selectedStoreNumber,
        divisionNumber: storeConfigController.selectedDivision);
    final date = DateTime.parse(response);
    return DateFormat("MM/dd/yy").format(date);
  }

  openPopUpToEnterControlNumber(VoidCallback onClick) {
    return CustomDialog.showDialogInTransferScreen(
        title: "Enter Control Number",
        buttonCallBack: onClick,
        icon: IconConstants.alertBellIcon,
        isCancelButtonRequired: true,
        content: SBOInputField(sboFieldModel: controlNumber),
        buttonText: "Proceed",
        cancelButtonText: "Cancel",
        subtitle: "",
        showTitle: true,
        cancelButtonCallBack: () {
          clearSelectedActionButton();
        });
  }

  Future<bool> validateBeforeAddItems() async {
    Map<SBOField, bool> validationStatus = {};
    for (var itr in scanFields) {
      if (itr.textEditingController.text.isNotEmpty) {
        switch (itr.sboField) {
          case SBOField.department:
            var (status, deptValidation) = await validationController
                .validateDepartment(itr.textEditingController.text);
            if (deptValidation == DeptValidEnum.deptInvalid ||
                deptValidation == DeptValidEnum.notFound && !status) {
              validationStatus[itr.sboField] = false;
            }
            addItemModel.department = itr.textEditingController.text;
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
            addItemModel.style = itr.textEditingController.text;

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
            addItemModel.style = itr.textEditingController.text;
          case SBOField.price:
            validationStatus[itr.sboField] = validationController.validatePrice(
                itr.textEditingController.text, PriceTypeEnum.initialOrSubs);
            addItemModel.price =
                int.parse(itr.textEditingController.text.replaceAll('.', ""));
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
      clearAllTextFieldValues();
      NavigationService.showToast(
          "${TranslationKey.invalidInputValidation.tr} ${failedValidation.toString().replaceAll("[", "").replaceAll("]", "")}");
      return false;
    }
    return true;
  }

  //region Add/Delete Item from box
  void addItem() async {
    final status = await validateBeforeAddItems();
    if (status) {
      addItemModel.controlNumber = controlNumberStrValue.value!;
      addItemModel.division = storeConfigController.selectedDivision;
      addItemModel.storeNumber = storeConfigController.selectedStoreNumber;
      addItemModel.transferDirection = getTransferDirection();
      final status = await repository.addItemToBox(addItemModel);
      if (status) {
        NavigationService.showToast("Item Added");
      } else {
        NavigationService.showToast("Error!,Item Not Added");
      }
    }
    for (var element in scanFields) {
      element.textEditingController.text = '';
    }
  }

  void deleteItem() async {
    final status = await validateBeforeAddItems();
    if (status) {
      addItemModel.controlNumber = controlNumberStrValue.value!;
      addItemModel.division = storeConfigController.selectedDivision;
      addItemModel.storeNumber = storeConfigController.selectedStoreNumber;
      addItemModel.transferDirection = getTransferDirection();
      final status = await repository.deleteItemInBox(addItemModel);
      if (status) {
        clearAllTextFieldValues();
        NavigationService.showToast("Item Deleted.");
      } else {
        NavigationService.showToast("Error!,Failed to delete Item.");
      }
    }
  }

//endregion
  void performVoidBox({String? cNumber}) async {
    final vBoxModel = VoidBoxTransferModel(
        currentDivision: storeConfigController.selectedDivision,
        currentStore: storeConfigController.selectedStoreNumber,
        userId: userMgmtController.userData!.data!.userId,
        controlNumber: cNumber ?? controlNumber.textEditingController.text,
        transferDirection: getTransferDirection(),
        transferType: getTransferType());
    final status = await repository.voidBox(vBoxModel);
    if (status.voidBoxStatus == BoxStateEnum.boxVoidTransmitted.index) {
      CustomDialog.showDialogInTransferScreen(
          title: "Box Void",
          cancelButtonText: "Cancel",
          buttonText: "Okay",
          subtitle: "This Box has been Voided",
          buttonCallBack: () {
            print(":shadjhjsahd");
            final backOnTransferScreen = Get.find<HomeViewController>();
            Get.back();
            Get.back();
            backOnTransferScreen.currentTabIndex.value = 3;
            onSwitchClear();
          },
          icon: IconConstants.successIcon,
          showTitle: false,
          isCancelButtonRequired: false,
          cancelButtonCallBack: () {
            Get.back();
          });
    }
  }
//endregion

  onSegmentChange(TransfersDirection segment) {
    currentSegment.value = segment;
  }

  onTransferTypeChange(TransferType type) {
    selectedTransferType.value = type;
  }

  onShippingActionChange(ShippingActions action) {
    selectedShippingAction.value = action;
  }

  clearAllTextFieldValues() {
    selectedTransferType.value = null;
    selectedShippingAction.value = null;
    for (var fields in scanFields) {
      fields.textEditingController.clear();
    }
  }

  getReceiverDivision() {
    if (selectedTransferType.value == TransferType.damagedJewelry) {
      return dModelData!.returnDivisionId;
    }
    if (selectedTransferType.value == TransferType.specialProjects) {
      return "";
    }
    return storeConfigController.selectedDivision;
  }

  getReceiverId(String storeNumber) {
    if (selectedTransferType.value == TransferType.damagedJewelry
    ) {
      return dModelData!.returnStoreNumberId;
    }
    return storeNumber;
  }

  getDirectiveNumber() {
    return "";
  }

  getTransferType() => selectedTransferType.value!.index + 1;
  getTransferDirection() => currentSegment.value!.index + 1;
  getTransferRequestType() => selectedShippingAction.value!.index + 1;

  TransfersModel getTModel({String cNumber = "", required storeNumber}) {
    return TransfersModel(
        senderDivision: storeConfigController.selectedDivision,
        senderId: userMgmtController.userData!.data!.userId,
        currentStoreNumber: storeConfigController.selectedStoreNumber,
        currentDivision: storeConfigController.selectedDivision,
        transferType: getTransferType() ?? 1,
        transferDirection: getTransferDirection() ?? 1,
        userId: userMgmtController.userData!.data!.userId,
        receiverDivision: getReceiverDivision(),
        receiverId: getReceiverId(storeNumber),
        directiveNumber: getDirectiveNumber(),
        control: cNumber,
        expectedItemCount: 0,
        actualItemCount: 0,
        confirmDateRange: false,
        isMagicBox: false);
  }

  Future<bool> checkOrValidateStoreNumber() async {
    final String storeNumberFinal = storeNumberString;
    storeNumber.textEditingController.text = storeNumberFinal;
    final status = await repository.validateStoreNumber(
        storeNumberString, storeConfigController.selectedDivision);
    if (status.responseCode == 0) {
      await getControllerNumber(storeNumberFinal);
      return true;
    } else {
      CustomDialog.showDialogInTransferError("Invalid Store Number");
    }
    return false;
  }

  itemFoundExecution(ShippingActions fromButton,ValidateControlNumberModel cNumModel)async{
    switch (fromButton) {
      case ShippingActions.endBox:
        await performEndBoxTransfer();
      case ShippingActions.adjustInquireBox:
        performAdjustInquireTransfer(cNumModel.controlNumber);
        break;
      case ShippingActions.reprintLabel:
        performReprintLabel(cNumber: cNumModel.controlNumber);
        break;
      default:
        CustomDialog.showErrorDialog();
        break;
    }
  }

  checkOrValidateControlNumber(ShippingActions fromButton) async {
    final cNumModel = ValidateControlNumberModel(
        divisionNumber: storeConfigController.selectedDivision,
        storeNumber: storeConfigController.selectedStoreNumber,
        controlNumber: controlNumber.textEditingController.text,
        transferType: getTransferType(),
        transferRequestType: getTransferRequestType());
    TResponseData status = await repository.validateControlNumber(cNumModel);
    switch(status.responseCode.getControlNumberStatusEnumFromInt){
      case ControlNumberStatusEnum.itemFound:
        itemFoundExecution(fromButton,cNumModel);
        break;
      case ControlNumberStatusEnum.notExists:
        CustomDialog.showDialogInTransferError("ControlNumber Does Not Exist.");
        break;
      case ControlNumberStatusEnum.wrongDivision:
        CustomDialog.showDialogInTransferError("Wrong Division");
        break;
      case ControlNumberStatusEnum.invalidStateForAction:
        CustomDialog.showDialogInTransferError("Invalid State For Action.");
        break;
      case ControlNumberStatusEnum.transferTypeDoesNotMatch:
        CustomDialog.showDialogInTransferError("TransferType Does Not Match.");
        break;
      default:
        return CustomDialog.showErrorDialog();

    }
  }

  void printEndBoxData(EndBoxTransfersResponse data) async {
    String emptyField = "0000";
    final storeBarCode =
        "${data.controlNumber}${data.locationId ?? emptyField}${data.boxItemCount.toString().makeFourDigitStoreNumber}";
    TransfersLabelData labelDefinition = TransfersLabelData(
        controlNumber: data.controlNumber,
        divisionName: data.divisionName,
        storeAddress1: data.storeAddress1,
        storeAddress2: data.storeAddress2,
        storeAddress3: data.storeAddress3,
        postalCode:
        "${data.postalCode1 ?? emptyField}-${data.postalCode2 ?? emptyField}",
        boxItemCount: data.boxItemCount.toString().makeFourDigitStoreNumber,
        receivingStore: data.locationId,
        storeNumber: data.locationId,
        storeBarCode: storeBarCode);
    printGivenData(labelDefinition.getLabelDefinition(
        cnd: LabelCondition.boxItem)); //printing Address
    await Future.delayed((const Duration(seconds: 1)));
    printGivenData(labelDefinition.getLabelDefinition(
        cnd: LabelCondition.addressForRegion)); //printing Box
    storedControlNumberForReprintPurpose.value = labelDefinition.controlNumber;
  }

  void printGivenData(String labelDefinition) {
    try {
      final printData = PrintLabelModel(
          label: labelDefinition,
          printer: zebraPrintService.connectedPrinters[0]);
      zebraPrintService.printLabel(printData);
    } catch (e) {
      logger.e("Error in printing Transfer Data");
    }
  }

  RxString itemCount = "0".obs;
  Future<InquireBoxModelT> performInquireBoxTransfer(
      String controlNumber, bool showLoading) async {
    final status = await repository.inquireBox(controlNumber, showLoading);
    itemCount.value = status.quantityOfItems;
    return status;
  }

  performAdjustInquireTransfer(String controlNumber) {
    return Get.to(() => const TransferItemScreen(), arguments: {
      "controlNumber": controlNumber,
      "transferType": selectedTransferType.value!.title,
      "storeAddress": storeAddress,
      "DJ":selectedTransferType.value==TransferType.damagedJewelry?
      true:false
    });
  }

  void showInquireBoxDialog(controlNumber) async {
    final inquireBoxData = await performInquireBoxTransfer(controlNumber, true);
    CustomDialog.showDialogInTransferScreen(
        title: "Inquire Box",
        cancelButtonText: "No",
        buttonText: "Yes",
        subtitle:
        "${inquireBoxData.quantityOfItems} items scanned.\nDo you want to print the details ?",
        buttonCallBack: () {
          Get.back();
          NavigationService.showToast("DETAIL REPORT PRINTING IN MANAGERS OFFICE");
        },
        cancelButtonCallBack: () {
          Get.back();
        },
        icon: IconConstants.warningIcon,
        showTitle: false,
        isCancelButtonRequired: true);
  }

  onSwitchClear() {
    selectedTransferType.value = null;
    selectedShippingAction.value = null;
    currentSegment.value = TransfersDirection.shipping;
    addItemModel = AddORDeleteItemToBoxTransferModel();
    controlNumber.textEditingController.clear();
    storeNumber.textEditingController.clear();
    canProceed.value = false;
  }

  showReprintLabelDialog() {
    return CustomDialog.showDialogInTransferScreen(
        title: "Reprint Label",
        cancelButtonText: "Cancel",
        buttonText: "Yes",
        subtitle:
        "Do you want to re-print label\nfor current box #${storedControlNumberForReprintPurpose ?? ""} ?",
        buttonCallBack: () {
          performReprintLabel();
          Get.back();
        },
        icon: IconConstants.warningIcon,
        showTitle: false,
        isCancelButtonRequired: true,
        cancelButtonCallBack: () {
          clearSelectedActionButton();
        });
  }

  performReprintLabel({String cNumber = ""}) async {
    if (storedControlNumberForReprintPurpose.value != null || cNumber != "") {
      final status = await repository.reprintLabelTransfer(
          ReprintLabelTransfersRequest(
              currentDivision: storeConfigController.selectedDivision,
              currentStore: storeConfigController.selectedStoreNumber,
              controlNumber: cNumber == ""
                  ? storedControlNumberForReprintPurpose.value.toString()
                  : cNumber,
              alternativeDivision: "",
              alternativeLocation: ""));

      if (status.boxResultStatus == BoxResultStatusEnum.boxOK.index + 1) {
        printEndBoxData(status);
        NavigationService.showToast("Label has been re-printed.");
      } else {
        NavigationService.showToast("Label not printed.");
      }
    }
  }

  void clearSelectedActionButton() {
    selectedShippingAction.value = null;
    Get.back();
  }

  Future<void> createDamagedJewellery()async{
    final response = await getControllerNumber("",isDamagedJewellery:true);
    print(":::::::::::::::${response}:");
  }

  void retrieveDJDataFromJsonFile(){
    for (DamagedJeweleryModel itr in damagedJeweleryJsonData){
      if(itr.currentDivision==storeConfigController.selectedDivision){
        dModelData=itr;
        break;
      }
    }
  }
}