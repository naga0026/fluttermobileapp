part of 'caching_service.dart';

extension CachingServiceSubsExtension on CachingService {
  Future<void> apiCallGetSubsDepartmentCodes() async {
    SubsMarkdownsCachingRequest request = SubsMarkdownsCachingRequest(
        pageNumber: subsDepartmentCodeParams.currentPage,
        pageSize: subsDepartmentCodeParams.perPageRecords);
    SubsMarkdownsDepartmentCodesResponse? response =
        await repository.subsMarkdownsDepartmentCodesAPI(request: request);
    if (response.status == StatusCodeEnum.success.statusValue) {
      if (response.data?.data != null) {
        logger.d(
            'number of subs department records = ${response.data?.data?.length ?? 0}');
        arrSubsDepartmentCode =
            arrSubsDepartmentCode + (response.data?.data ?? []);
        subsDepartmentCodeParams.totalPage = response.data?.totalPages ?? 1;
        subsDepartmentCodeParams.totalRecord = response.data?.totalRecords ?? 0;
        databaseService.addItems<SubsDepartmentData>(
            response.data!.data!, TableNames.subsDepartmentCodeTable,
            subsCachingParam: subsDepartmentCodeParams);
        if (subsDepartmentCodeParams.currentPage <
            (response.data?.totalPages ?? 1)) {
          // updateCachingProgress(subsDepartmentCodeParams, response.data?.totalRecords ?? 0,
          //     subsCurrentRecords += response.data?.data?.length ?? 0);
          subsDepartmentCodeParams.currentPage += 1;
          // API Call recursive
          apiCallGetSubsDepartmentCodes();
        }
      }
    }
  }

  Future<void> apiCallGetSubsGuides() async {
    SubsMarkdownsCachingRequest request = SubsMarkdownsCachingRequest(
        pageNumber: subsDepartmentCodeParams.currentPage,
        pageSize: subsDepartmentCodeParams.perPageRecords);
    request.updateRequestWhenNotUlineDepartment();
    SubsMarkdownsGuidesResponse? response =
        await repository.subsMarkdownsGuidesAPI(request: request);
    if (response.status == StatusCodeEnum.success.statusValue) {
      if (response.data?.data != null) {
        logger.d(
            'number of subs guide records = ${response.data?.data?.length ?? 0}');
        arrSubsGuide = arrSubsGuide + (response.data?.data ?? []);
        subsGuidesParams.totalPage = response.data?.totalPages ?? 1;
        subsGuidesParams.totalRecord = response.data?.totalRecords ?? 0;
        databaseService.addItems<GuideData>(
            response.data!.data!, TableNames.subsGuidesTable, subsCachingParam: subsGuidesParams);
        if (subsGuidesParams.currentPage < (response.data?.totalPages ?? 1)) {
          subsGuidesParams.currentPage += 1;
          // API Call recursive
          apiCallGetSubsGuides();
        }
      }
    }
  }

  Future<void> apiCallGetSubsRanges() async {
    SubsMarkdownsCachingRequest request = SubsMarkdownsCachingRequest(
        pageNumber: subsDepartmentCodeParams.currentPage,
        pageSize: subsDepartmentCodeParams.perPageRecords);
    request.updateRequestWhenNotUlineDepartment();
    SubsMarkdownsRangesResponse? response =
        await repository.subsMarkdownsRangesAPI(request: request);
    if (response.status == StatusCodeEnum.success.statusValue) {
      if (response.data?.data != null) {
        logger.d(
            'number of subs range records = ${response.data?.data?.length ?? 0}');
        arrSubsRange = arrSubsRange + (response.data?.data ?? []);
        subsRangesParams.totalPage = response.data?.totalPages ?? 1;
        subsRangesParams.totalRecord = response.data?.totalRecords ?? 0;
        databaseService.addItems<RangeData>(
            response.data!.data!, TableNames.subsRangesTable, subsCachingParam: subsRangesParams);
        if (subsRangesParams.currentPage < (response.data?.totalPages ?? 1)) {
          subsRangesParams.currentPage += 1;
          // API Call recursive
          apiCallGetSubsRanges();
        }
      }
    }
  }

  Future<void> apiCallGetSubsPricePoints() async {
    SubsMarkdownsCachingRequest request = SubsMarkdownsCachingRequest(
        pageNumber: subsDepartmentCodeParams.currentPage,
        pageSize: subsDepartmentCodeParams.perPageRecords);
    request.updateRequestWhenNotUlineDepartment();
    SubsMarkdownsPricePointResponse? response =
        await repository.subsMarkdownsPricePointsAPI(request: request);
    if (response.status == StatusCodeEnum.success.statusValue) {
      if (response.data?.data != null) {
        logger.d(
            'number of subs price point records = ${response.data?.data?.length ?? 0}');
        arrSubsPricePoint = arrSubsPricePoint + (response.data?.data ?? []);
        subsPricePointsParams.totalPage = response.data?.totalPages ?? 1;
        subsPricePointsParams.totalRecord = response.data?.totalRecords ?? 0;
        databaseService.addItems<PricePointData>(
            response.data!.data!, TableNames.subsPricePointsTable, subsCachingParam: subsPricePointsParams);
        if (subsPricePointsParams.currentPage <
            (response.data?.totalPages ?? 1)) {
          subsPricePointsParams.currentPage += 1;
          // API Call recursive
          apiCallGetSubsPricePoints();
        }
      }
    }
  }

  Future<void> apiCallGetSubsUlineClass() async {
    SubsMarkdownsCachingRequest request = SubsMarkdownsCachingRequest(
        pageNumber: subsDepartmentCodeParams.currentPage,
        pageSize: subsDepartmentCodeParams.perPageRecords);
    SubsMarkdownsClassUlineResponse? response =
        await repository.subsMarkdownsUlineClassAPI(request: request);
    if (response.status == StatusCodeEnum.success.statusValue) {
      if (response.data?.data != null) {
        logger.d(
            'number of subs class uline records = ${response.data?.data?.length ?? 0}');
        arrSubsUlineClass = arrSubsUlineClass + (response.data?.data ?? []);
        subsUlineClassParams.totalPage = response.data?.totalPages ?? 1;
        subsUlineClassParams.totalRecord = response.data?.totalRecords ?? 0;
        databaseService.addItems<UlineClassData>(
            response.data!.data!, TableNames.subsUlineClassTable, subsCachingParam: subsUlineClassParams);
        if (subsUlineClassParams.currentPage <
            (response.data?.totalPages ?? 1)) {
          subsUlineClassParams.currentPage += 1;
          // API Call recursive
          apiCallGetSubsUlineClass();
        }
      }
    }
  }

  Future<void> apiCallGetSubsExceptions() async {
    SubsMarkdownsCachingRequest request = SubsMarkdownsCachingRequest(
        pageNumber: subsDepartmentCodeParams.currentPage,
        pageSize: subsDepartmentCodeParams.perPageRecords);
    request.updateRequestWhenNotUlineDepartment();
    SubsMarkdownsExceptionResponse? response =
        await repository.subsMarkdownsExceptionsAPI(request: request);
    if (response.status == StatusCodeEnum.success.statusValue) {
      if (response.data?.data != null) {
        logger.d(
            'number of subs exception records = ${response.data?.data?.length ?? 0}');
        arrSubsException = arrSubsException + (response.data?.data ?? []);
        subsExceptionsParams.totalPage = response.data?.totalPages ?? 1;
        subsExceptionsParams.totalRecord = response.data?.totalRecords ?? 0;
        databaseService.addItems<ExceptionData>(
            response.data!.data!, TableNames.subsExceptionsTable, subsCachingParam: subsExceptionsParams);
        if (subsExceptionsParams.currentPage <
            (response.data?.totalPages ?? 1)) {
          subsExceptionsParams.currentPage += 1;
          // API Call recursive
          apiCallGetSubsExceptions();
        }
      }
    }
  }

  void updateCachingProgress() {
    var averageProgress = 0.0;
    var totalProgress = 0.0;
    for (var element in [
      subsDepartmentCodeParams,
      subsExceptionsParams,
      subsGuidesParams,
      subsRangesParams,
      subsPricePointsParams,
      subsUlineClassParams
    ]) {
      if(element.currentRecords != element.totalRecord){
        element.percentageProgress = (element.currentRecords * 100)/element.totalRecord;
      } else {
        element.percentageProgress = 100.0;
      }
      totalProgress += element.percentageProgress;
    }
    averageProgress = totalProgress / 6;
    subsCachingProgress.value = averageProgress >= 100.0 ? 100.0 : averageProgress;
    logger.d("Average progress : $averageProgress");
    if(averageProgress >= 100.0){
      isSubsMarkdownCachingInProgress.value = false;
    }
  }
}
