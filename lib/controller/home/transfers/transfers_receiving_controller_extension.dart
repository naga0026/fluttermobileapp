part of 'package:base_project/controller/home/transfers/transfers_controller.dart';

extension TransfersReceivingControllerExtension on TransfersController {

  //region Interpret barcode and fill data
  void onScannedTransfersReceivingBarcode(String barcode) {
    ScanOrEnteredTransferReceivingItem? interpretedBarcode =
        barcodeController.interpretTransfersReceivingBarcode(
            barcode, storeToStoreReceivingFields);
    if(interpretedBarcode != null) receivedItemData = interpretedBarcode;
    receivedItemData.isKeyed = false;
    if (interpretedBarcode == null) {
      NavigationService.showToast(TranslationKey.invalidBarcode.tr);
    }
  }
  //endregion

  //region Validations
  Future<ReceivingValidationResult> validateTransferReceivingFields() async {
    bool isValid = await commonFieldsValidation();
    if (isValid) {
      logger.d("Common Validation completed for receiving box");
      bool isValidControlNum = await isValidControlNumber();
      if(isValidControlNum) {
        bool isBoxReceived = await checkIsBoxReceived(
            receivedItemData.controlNumber);
        if (isBoxReceived) {
          return ReceivingValidationResult.notValid;
        }
        var isValidStore = await checkIsValidStoreNumber(
            receivedItemData.receivingStoreNumber.padLeft(4, '0'));
        if (isValidStore) {
          return receivedItemData.receivingStoreNumber ==
              storeConfigController.selectedStoreDetails.value?.storeNumber
              ?
          ReceivingValidationResult.validStoreSameStore
              : ReceivingValidationResult.validStoreCrossStore;
        }
      }
    }
    return ReceivingValidationResult.notValid;
  }

  /// This function is a common validation function which will validate
  /// the empty fields and any other specific length related validations
  // Future<bool> commonFieldValidation() async {
  //   return await validationController
  //       .validateGivenFields(storeToStoreReceivingFields);
  // }

  Future<bool> commonFieldsValidation() async {
    String message = '';
    if (receivedItemData.controlNumber.isEmpty) {
      message += TranslationKey.controlNumberLabel.tr;
    }
    if (receivedItemData.receivingStoreNumber.isEmpty) {
      message = message.addCommaIfNotEmpty() + TranslationKey.storeLabel.tr;
    }
    if (receivedItemData.itemCount.isEmpty) {
      message = message.addCommaIfNotEmpty() + TranslationKey.itemCountLabel.tr;
    }
    if (message.isEmpty) return true;
    NavigationService.showToast('${TranslationKey.invalidInputs.tr} $message');
    return false;
  }

  /// This function interprets the control number and gets the division for
  /// which the package is intended, the number of items in box and the
  /// shipping store number,
  /// validates a box division if its the current user division then moves forward
  /// then validates shipping store number with an API call,
  /// validates a control number with an API call
  Future<bool> isValidControlNumber() async {
    ControlNumberModel? interpretedControlNumber = barcodeController
        .interpretControlNumberBarcode(receivedItemData.controlNumber);
    if (interpretedControlNumber == null) {
      NavigationService.showToast(TranslationKey.invalidControlNumber.tr);
      return false;
    }
    receivedItemData.interpretedControlNumber = interpretedControlNumber;
    bool isValidBoxDivision =
        await validateBoxDivision(interpretedControlNumber);
    if (isValidBoxDivision) {
      var isValidShippingStoreNumber = await checkIsValidStoreNumber(
          interpretedControlNumber.shippingStoreNumber.toStringWithPadLeft(4));
      if (!isValidShippingStoreNumber) {
        NavigationService.showToast(TranslationKey.invalidStoreNumber.tr);
        return false;
      }
      return await validateControlNumberInAPI(
          controlNumberModel: interpretedControlNumber);
    }
    return false;
  }

  Future<bool> validateBoxDivision(
      ControlNumberModel interpretedControlNumber) async {
    var division = interpretedControlNumber.receivingDivision;
    if (storeConfigController.isMarshallsUSA()) {
      division = division == AppConstants.marshallsUsDepartmentPrefix
          ? int.parse(DivisionEnum.marshallsUsa.rawValue)
          : division;
    }
    if (storeConfigController.isCurrentDivision(division)) {
      return true;
    }
    NavigationService.showToast(TranslationKey.boxNotIntendedForDivision.tr);
    return false;
  }
  //endregion

  //region Validation with API calls
  Future<bool> validateControlNumberInAPI(
      {required ControlNumberModel controlNumberModel}) async {
    final controlNumberValidationRequest = ValidateControlNumberModel(
        divisionNumber: controlNumberModel.receivingDivision.toString(),
        storeNumber: storeConfigController.selectedStoreNumber,
        controlNumber: receivedItemData.controlNumber,
        transferType: TransferTypeEnum.storeToStore.rawValue,
        transferRequestType:
            TransferRequestTypeEnum.adjustOrInquireBox.rawValue);
    TResponseData status =
        await repository.validateControlNumber(controlNumberValidationRequest);
    var controlNumberStatusEnum = status.responseCode.rawValue;
    switch (controlNumberStatusEnum) {
      case ControlNumberStatusEnum.itemFound:
        return true;
      case ControlNumberStatusEnum.transferTypeDoesNotMatch:
        buildAndShowWrongTransferTypeMessage(TransferTypeEnum.storeToStore);
        return false;
      case ControlNumberStatusEnum.notExists:
        NavigationService.showToast(TranslationKey.invalidControlNumber.tr);
        return false;
      case ControlNumberStatusEnum.wrongDivision:
        NavigationService.showToast(
            TranslationKey.boxNotIntendedForDivision.tr);
        return false;
      case ControlNumberStatusEnum.invalidStateForAction:
        NavigationService.showToast(TranslationKey.unknownError.tr);
        return false;
    }
  }

  Future<bool> checkIsBoxReceived(String controlNumber) async {
    final status = await repository.checkIfBoxReceived(controlNumber);
    var boxStatus = status.responseCode.enumBoxState;
    switch (boxStatus) {
      case BoxStateEnum.boxReceived:
        clearStoreToStoreReceivingFields();
        NavigationService.showToast(TranslationKey.boxAlreadyReceived.tr);
        return true;
      default:
        return false;
    }
  }

  Future<bool> checkIsValidStoreNumber(String shippingStoreNumber) async {
    // If the divisions are same and store numbers are different move to next screen
    // ask confirmation not intended store and if want to continue
    // If the divisions are not same then show toast
    // not intended for this division and clear fields
    final status = await repository.validateStoreNumber(
        shippingStoreNumber, storeConfigController.selectedStoreDetails.value!.storeDivision);
    if (status.responseCode == ValidateStoreNumberStatusEnum.valid.index) {
      return true;
    }
    NavigationService.showToast(TranslationKey.invalidStoreNumber.tr);
    clearStoreToStoreReceivingFields();
    return false;
  }
  //endregion

  //region Helpers

  /// On clicking of enter button,
  /// If all the validations are done, last step is to compare current
  /// store number with the interpreted receiving store numbbeeer
  /// If both store are same ask for item confirmation else store confirmation
  /// to continue with different store
  Future<void> onClickEnter() async {
    ReceivingValidationResult validationResult = await validateTransferReceivingFields();
    switch(validationResult){
      case ReceivingValidationResult.validStoreCrossStore:
        NavigationService.showDialog(
            subtitle: TranslationKey.boxNotIntended.tr,
            title: TranslationKey.receivingLabel.tr,
            buttonText: TranslationKey.yes.tr,
            cancelButtonText: TranslationKey.no.tr,
            isAddCancelButton: true,
            buttonCallBack: (){
              Get.back();
              itemConfirmationPopUp();
            },
            cancelButtonCallBack: (){
              clearStoreToStoreReceivingFields();
              Get.back();
            },
            icon: IconConstants.alertBellIcon
        );
        break;
      case ReceivingValidationResult.validStoreSameStore:
        itemConfirmationPopUp();
        break;
      case ReceivingValidationResult.notValid:
        break;

    }
  }

  void clearStoreToStoreReceivingFields() {
    for (var element in storeToStoreReceivingFields) {
      element.textEditingController.text = '';
    }
    receivedItemData = ScanOrEnteredTransferReceivingItem.empty();
  }

  Future<void> buildAndShowWrongTransferTypeMessage(
      TransferTypeEnum transferType) async {
    var title = TranslationKey.wrongTransferType.tr.toUpperCase();
    var message = '${TranslationKey.pleaseSelectType.tr.toUpperCase()}\n';
    switch (transferType) {
      case TransferTypeEnum.storeToStore:
        await NavigationService.showDialogWithOk(
          title: title,
          message: '$message${TranslationKey.storeToStore.tr.toUpperCase()}',
        );
        break;
      case TransferTypeEnum.merchandiseRecall:
        await NavigationService.showDialogWithOk(
          title: title,
          message:
              '$message${TranslationKey.merchRecallLabel.tr.toUpperCase()}',
        );
        break;
      case TransferTypeEnum.damagedJewelery:
        await NavigationService.showDialogWithOk(
          title: title,
          message:
              '$message${TranslationKey.damagedJewelryLabel.tr.toUpperCase()}',
        );
        break;
      case TransferTypeEnum.specialProject:
        await NavigationService.showDialogWithOk(
          title: title,
          message:
              '$message${TranslationKey.specialProjectsLabel.tr.toUpperCase()}',
        );
        break;
      default:
        throw ArgumentError.value(transferType, 'transferType', null);
    }
  }
//endregion
}
