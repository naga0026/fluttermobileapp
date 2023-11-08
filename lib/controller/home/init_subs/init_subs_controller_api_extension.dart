part of 'init_subs_view_controller.dart';

extension InitSubsControllerAPIExtension on InitSubsViewController {
  //region API Calls
  Future<void> apiCallPerformInitialMarkdown(MarkdownData markdownData) async {
    // If api call gives success print the   label else show error popup
    // var markdownData = MarkdownData.fromJson(res);
    var stock = getStockType(markdownData);
    var printer = checkAvailablePrinterForStockAndReturnPrinter(stock);
    if (printer != null) {
      var request = await createPerformInitialMarkdownRequest(markdownData);
      var response = await repository.performMarkdown(request: request);
      if (response?.statusCode == StatusCodeEnum.success.statusValue) {
        if (response!.response?.responseCode ==
                MarkdownOperationResultEnum.initialMarkdownTaken.rawValue ||
            response.response?.responseCode ==
                MarkdownOperationResultEnum.missedMarkdown.rawValue) {
          sharedPrefService.setRecentMarkdown(
              logId: response.response?.data?.logId);
          printMarkdownLabel(request, printer);
        } else {
          updateIfNotInitialMarkdownTaken(response.response?.responseCode ?? 0);
        }
      } else {
        NavigationService.showToast(
            response?.error ?? TranslationKey.initialMarkdownError.tr);
      }
    }
  }

  Future<void> apiCallVoidMarkdown() async {
    int? logId = sharedPrefService.getRecentMarkdown();
    if (logId != null) {
      VoidOrReprintMarkdownRequest request =
          VoidOrReprintMarkdownRequest(logId: logId);
      var response = await repository.voidMarkdown(request: request);
      if (response?.statusCode == StatusCodeEnum.success.statusValue) {
        sharedPrefService.setRecentMarkdown(logId: null);
        previousPrintDetails = null;
        NavigationService.showToast(TranslationKey.markdownVoided.tr);
      }
    } else {
      NavigationService.showDialog(
        title: TranslationKey.error.tr,
        subtitle: TranslationKey.noMarkdownToVoid.tr,
        buttonCallBack: () => onBack(),
        icon: IconConstants.failedIcon,
      );
    }
  }

  Future<void> apiCallGetOpenMarkdownWeek() async {
    MarkdownWeekOpenRequest request = MarkdownWeekOpenRequest(
        divisionCode:
            storeConfigController.selectedStoreDetails.value?.storeDivision ??
                '',
        storeNumber:
            storeConfigController.selectedStoreDetails.value?.storeNumber ?? '',
        markdownType: MarkdownTypeEnum.initials.rawValue);
    MarkdownWeekResponse? response =
        await repository.markdownWeekOpen(request: request);
    if (response?.status == StatusCodeEnum.success.statusValue) {
      isMarkdownWeekOpen.value =
          (response?.markdownWeek?.weekId ?? '').isNotEmpty;
      openMarkdownWeek = response?.markdownWeek;
    } else {
      physicalResponseService.errorBeep();
      isMarkdownWeekOpen.value = false;
    }
  }

  Future<bool> apiCallReprintMarkdown() async {
    bool isSuccess = false;
    int? logId = sharedPrefService.getRecentMarkdown();
    if (logId != null) {
      VoidOrReprintMarkdownRequest request = VoidOrReprintMarkdownRequest(
          logId: logId, reprintCount: reprintCount);
      var response = await repository.reprintMarkdownLabel(request: request);
      if (response?.statusCode == StatusCodeEnum.success.statusValue) {
        reprintCount += 1;
        // TODO: Handle operation on reprint
        isSuccess = true;
      }
    } else {
      NavigationService.showDialog(
        title: TranslationKey.error.tr,
        subtitle: TranslationKey.noDataToReprint.tr,
        buttonCallBack: () => onBack(),
        icon: IconConstants.failedIcon,
      );
    }
    return isSuccess;
  }

  Future<MarkdownData?> apiCallGetMLUCandidate() async {
    MLUCandidateRequest request = MLUCandidateRequest(
        departmentCode: initialMarkdownFields.deptId ?? '',
        divisionCode: storeConfigController.selectedDivision,
        storeNumber: storeConfigController.selectedStoreNumber,
        weekId: openMarkdownWeek?.weekId ?? '');
    MarkdownCandidateResponse? fetchedMarkdownData =
        await repository.getMLUCandidate(request: request);
    if (fetchedMarkdownData?.statusCode == StatusCodeEnum.success.statusValue &&
        (fetchedMarkdownData?.markdownData ?? []).isNotEmpty) {
      var markdownData = fetchedMarkdownData!.markdownData!.first;
      return markdownData;
    }
    return null;
  }

  Future<MarkdownCandidateResponse?> apiCallGetMarkdownCandidate() async {
    MarkdownCandidateRequest markdownCandidateRequest =
        MarkdownCandidateRequest(
            departmentCode: initialMarkdownFields.deptId ?? '',
            divisionCode: storeConfigController.selectedDivision,
            storeNumber: storeConfigController.selectedStoreNumber,
            styleOrLine: initialMarkdownFields.styleOrULine ?? '',
            isMLU: selectedOperation.value == MarkdownOperationEnum.mlu);
    MarkdownCandidateResponse? fetchedMarkdownData = await repository
        .getMarkdownCandidate(request: markdownCandidateRequest);
    return fetchedMarkdownData;
  }

  void updateIfNotInitialMarkdownTaken(int statusCode) {
    MarkdownOperationResultEnum status = statusCode.enumMarkdownOperationResult;
    switch (status) {
      case MarkdownOperationResultEnum.noMarkdown:
        NavigationService.showToast(TranslationKey.noMarkdownNeeded.tr);
        break;
      case MarkdownOperationResultEnum.weekGotClosed:
        physicalResponseService.errorBeep();
        NavigationService.showToast(TranslationKey.noMarkdownWeek.tr);
        break;
      case MarkdownOperationResultEnum.subsMarkdownTaken:
        physicalResponseService.errorBeep();
        NavigationService.showToast(TranslationKey.invalidInputs.tr + TranslationKey.priceTitle.tr);
        break;
      default:
        logger.d('Initial markdown not taken');
        break;
    }
  }
//endregion
}
