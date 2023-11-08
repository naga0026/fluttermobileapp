part of 'init_subs_view_controller.dart';

extension InitSubsViewControllerValidationExtension on InitSubsViewController {
  Future<bool> validateInitialMarkdownFields() async {
    bool isValid = await validationController
        .validateGivenFields(arrayInitialMarkdownFields, priceTypeEnum: PriceTypeEnum.initial,
        appName: AppNameEnum.markdowns);
    return isValid;
  }

  String getOutputPriceBasedOnReKeyedInputPrice(
      String reKeyedInputPrice, MarkdownData foundItem) {

    var markdownPercentage = selectedOperation.value == MarkdownOperationEnum.mlu ? foundItem.mluPercent : foundItem.initialPercent;
    var reKeyedInputPriceWithoutDot = reKeyedInputPrice.priceWithoutDot;
    if (reKeyedInputPriceWithoutDot == foundItem.fromPrice) {
      return foundItem.toPrice ?? '';
    }

    var price =
        int.parse(reKeyedInputPrice) * (100 - (markdownPercentage ?? 0));
    int calculatedOutputPrice = ((price / 10000.0) * 100).round();
    return calculatedOutputPrice.calculatedReKeyPrice;
  }

  Future<bool> isInputPriceSameAsFromPrice() async {
    logger.d("Price is matching with fromPrice checking...");
    var markdownData = MarkdownData();
    markdownData.departmentCode = initialMarkdownFields.deptId;
    markdownData.style = initialMarkdownFields.styleOrULine;
    markdownData.uline = initialMarkdownFields.styleOrULine;
    markdownData.fromPrice = initialMarkdownFields.price?.priceWithoutDot;

    if(cachingService.isInitialMarkdownCachingInProgress || selectedOperation.value == MarkdownOperationEnum.mlu){
      logger.d("Comparing price from Live markdown data...");
      var foundItem = liveMarkdownData.firstWhereOrNull((element) {
        return
        element.departmentCode == markdownData.departmentCode &&
        (element.style == markdownData.style || element.uline == markdownData.uline) &&
        element.fromPrice == markdownData.fromPrice;
      });
      logger.d(
          "Price is matching with fromPrice = ${foundItem != null}");
      return foundItem != null;
    } else {
      logger.d("Comparing price from DB...");
      Map<String, dynamic>? markdownTableQueryResponse =
      await databaseService.selectQuery(
          tableName: TableNames.initialMarkdownTable,
          queryParams: markdownData.findMarkdownDataInDBQuery());
      logger.d(
          "Price is matching with fromPrice = ${markdownTableQueryResponse != null}");
      return markdownTableQueryResponse != null;
    }
  }

  /// This function checks if the ReEntered price doesn't match with fromPrice of the database
  /// or the input price from initial markdown fields it allows user to enter price two times
  /// then returns whether price is valid or not and last entered price
  Future<(bool, String)> isReKeyPriceValidated(MarkdownData foundItem) async {
    var isValidated = false;
    var newEnteredPrice = '';
    var validPrices = [foundItem.fromPrice, initialMarkdownFields.price?.priceWithoutDot];
    // Asked for one time, if price is from valid price then return true
    // Else give one more chance to fill in the price
    var firstAttemptPrice = await askReKeyPrice(foundItem: foundItem);
    if(validPrices.contains(firstAttemptPrice)){
      isValidated = true;
      newEnteredPrice = firstAttemptPrice;
    } else {
      // If not entered corrected ask again to fill price file price or previous entered price only
      // else show invalid price popup
      var secondAttemptPrice = await askReKeyPrice(foundItem: foundItem);
      if(validPrices.contains(secondAttemptPrice)){
        isValidated =  true;
        newEnteredPrice = secondAttemptPrice;
      }
    }
    return (isValidated, newEnteredPrice);
  }

  Future<String> askReKeyPrice({required MarkdownData foundItem}) async {
    var enteredPrice = '';
    await ReKeyInputDialog.showInputDialog(
        markdownData: foundItem,
        onReKeyPrice: (String newPrice) { enteredPrice = newPrice;});
    return enteredPrice;
  }

  Future<void> validatePriceOnMarkdownData({required MarkdownData markdownData}) async {
    bool isInputPriceAndFromPriceMatched =
        await isInputPriceSameAsFromPrice();
    if (isInputPriceAndFromPriceMatched) {
      await apiCallPerformInitialMarkdown(markdownData);
    } else {
      var isValidatedPriceResult = await isReKeyPriceValidated(markdownData);
      if (isValidatedPriceResult.$1) {
        var newOutPutPrice = getOutputPriceBasedOnReKeyedInputPrice(
            isValidatedPriceResult.$2, markdownData);
        markdownData.toPrice = newOutPutPrice;
        physicalResponseService.s2Beep();
        await apiCallPerformInitialMarkdown(markdownData);
      } else {
        onClickClear();
        NavigationService.showToast(TranslationKey.invalidComparePrice.tr);
      }
    }
  }
}
