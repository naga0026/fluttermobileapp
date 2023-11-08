part of 'init_subs_view_controller.dart';

extension MLUViewController on InitSubsViewController {
  // If scanned item is on initial markdown table
  // and for the week that is not open
  // from price matched with the from file price
  // MLU take with toPrice and recorded with SGM
  // markdown ticket printer

  Future<bool> isProceedAsInitialMarkdown() async {
    // If scanned data is in initial markdowns table and week is open
    // show perform as initial markdown toast message
    var isDataOnOpenMarkdownWeek = await isDepartmentInCurrentWeek();
    if (isDataOnOpenMarkdownWeek) {
      NavigationService.showToast(TranslationKey.processAsInitMarkDown.tr);
      onClickClear();
    }
    return isDataOnOpenMarkdownWeek;
  }

  Future<void> proceedWithMLU() async {
    bool isMLUInInitialMarkdownWeek = await isProceedAsInitialMarkdown();
    // If data is available in markdown table and is in the week which is not open
    // If From price of the file and entered from price match
    // Perform MLU with markdown ToPrice and MLU is recorded as SGM
    // Print markdown ticket
    if (!isMLUInInitialMarkdownWeek) {
      var fetchedMarkdownData = await apiCallGetMarkdownCandidate();
      if (fetchedMarkdownData?.markdownData != null) {
        liveMarkdownData = fetchedMarkdownData?.markdownData ?? [];
        if(liveMarkdownData.isNotEmpty){
          var foundItem = fetchedMarkdownData!.markdownData!.first;
          logger.d("=== $foundItem====");
          await validatePriceOnMarkdownData(markdownData: foundItem);
        } else {
          showNoMarkdownDialog();
          onClickClear();
        }
      } else {
        showNoMarkdownDialog();
        onClickClear();
        // No markdown
      }
    }
  }
}
