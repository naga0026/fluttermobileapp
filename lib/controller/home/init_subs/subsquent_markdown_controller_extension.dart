part of 'init_subs_view_controller.dart';

extension SubsMarkdownControllerExtension on InitSubsViewController {

  Future<void> apiCallPerformSubsMarkdown(MarkdownData markdownData) async {

  }

  Future<void> apiCallGetOpenMarkdownWeekForSubs() async {
    MarkdownWeekOpenRequest request = MarkdownWeekOpenRequest(
        divisionCode: storeConfigController.selectedStoreDetails.value?.storeDivision ?? '',
        storeNumber: storeConfigController.selectedStoreDetails.value?.storeNumber ?? '',
        markdownType: MarkdownTypeEnum.subs.rawValue);
    MarkdownWeekResponse? response =
    await repository.markdownWeekOpen(request: request);
    if (response?.status == StatusCodeEnum.success.statusValue) {
      isMarkdownWeekOpenForSubs.value =
          (response?.markdownWeek?.weekId ?? '').isNotEmpty;
      openMarkdownWeek = response?.markdownWeek;
    } else {
      isMarkdownWeekOpenForSubs.value = false;
    }
  }

}