part of 'transfers_controller.dart';

extension TransfersReceivingItemConfirmationControllerExtension
    on TransfersController {
  /// Shows a pop up with Total number of item count in a given box
  /// User can confirm and select yes/no accordingly
  void itemConfirmationPopUp() {
    NavigationService.alertDialogWithTwoActions(
        title: Text(
          '${TranslationKey.receivingLabel.tr}\n${TranslationKey.storeToStore.tr}',
          textAlign: TextAlign.center,
        ),
        content: ItemConfirmationView(receivedItem: receivedItemData),
        onClickNo: () {
          Get.back();
          itemTextFieldPopUp();
        },
        onClickYes: () {
          Get.back();
          receivedItemData.receivedItemCount =
              int.parse(receivedItemData.itemCount);
          apiCallReceiveBox();
          logger.d("Item confirmed continue with API call");
        });
  }

  /// If user selects no In item confirmation popup
  /// user is asked to enter the number of items they
  /// have received in a box and proceed further
  void itemTextFieldPopUp() {
    NavigationService.alertDialogWithTwoActions(
        title: Text(
            '${TranslationKey.receivingLabel.tr}\n${TranslationKey.storeToStore.tr}',
            textAlign: TextAlign.center),
        content: SBOInputField(sboFieldModel: itemConfirmationField),
        yesButtonText: TranslationKey.enterLabel.tr,
        noButtonText: TranslationKey.clear.tr,
        onClickNo: () {
          itemConfirmationField.textEditingController.text = '';
        },
        onClickYes: () {
          var count =
              int.tryParse(itemConfirmationField.textEditingController.text) ??
                  0;
          if (count <= 0) {
            NavigationService.showToast(
                itemConfirmationField.sboField.errorMessage);
          } else {
            receivedItemData.receivedItemCount = count;
            Get.back();
            apiCallReceiveBox();
            logger.d("Item confirmed continue with API call");
          }
        });
  }

  Future<void> apiCallReceiveBox() async {
    var request = TransfersModel.fromScanOrEnteredTransferReceivingItem(
        receivedItem: receivedItemData,
        direction: TransfersDirection.receiving,
        transferType: TransferTypeEnum.storeToStore);
    logger.d("Attempting to receiving API, " +
        "ctrl num: ${request.control}, transfer type: ${request.transferType}, direction: ${request.transferDirection}");
    var result = await repository.postTransfersData(request);
    if (result.responseCode == TransferStateEnum.boxCreated.rawValue) {
      physicalResponseService.s1Beep();
      NavigationService.showDialog(
          isAddCancelButton: true,
          title: TranslationKey.boxSuccessReceived.tr,
          subtitle: TranslationKey.moreBoxesQuestion.tr,
          buttonText: TranslationKey.yes.tr,
          cancelButtonText: TranslationKey.no.tr,
          buttonCallBack: () {
            Get.back();
            clearStoreToStoreReceivingFields();
          },
          cancelButtonCallBack: () {
            Get.back();
            clearAllTextFieldValues();
            clearStoreToStoreReceivingFields();
            onSwitchClear();
          },
          icon: IconConstants.alertBellIcon);
    }
    logger.d(
        "Receive box api result ${result.responseCode} data: ${result.data}");
  }
}
