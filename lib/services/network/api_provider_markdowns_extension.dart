part of 'api_provider.dart';

extension APIProviderMarkdownsExtension on APIProvider {
  Future<PerformInitialMarkdownResponse?> apiCallPerformInitialMarkdown(
      PerformInitialMarkdownRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.postInitialMarkdowns.value]!,
        requestType: RequestType.post,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Perform initial markdown response: ${response?.resultJson}");
    if (response?.statusCode == StatusCodeEnum.success.statusValue) {
      MarkdownResponse res =
          performMarkdownResponseFromJson(response!.resultJson);
      return PerformInitialMarkdownResponse(
          statusCode: response.statusCode, response: res);
    }
    return PerformInitialMarkdownResponse(
        statusCode: response?.statusCode ?? 400,
        error: response?.errorResponse?.title ?? response?.error);
  }

  Future<MarkdownWeekResponse> apiCallIsMarkdownWeekOpen(
      MarkdownWeekOpenRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.openMarkdownWeek.value]!,
        requestType: RequestType.get,
        params: request.toJson(),
    );
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Open markdown week response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      return MarkdownWeekResponse(
        status: response.statusCode,
        markdownWeek: markdownWeekFromJson(response.resultJson),
      );
    } else {
      return MarkdownWeekResponse(
          status: response?.statusCode ?? 400,
          error: response?.errorResponse?.title ?? '');
    }
  }

  Future<PerformInitialMarkdownResponse?> apiCallVoidPreviousMarkdown(
      VoidOrReprintMarkdownRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.voidMarkdown.value]!,
        requestType: RequestType.post,
        params: request.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Void previous markdown response: ${response?.resultJson}");
    if (response?.statusCode == StatusCodeEnum.success.statusValue) {
      MarkdownResponse res =
          performMarkdownResponseFromJson(response!.resultJson);
      return PerformInitialMarkdownResponse(
          statusCode: response.statusCode, response: res);
    }
    return PerformInitialMarkdownResponse(
        statusCode: response?.statusCode ?? 400,
        error: response?.errorResponse?.title ?? response?.error);
  }

  Future<PerformInitialMarkdownResponse?> apiCallReprintMarkdown(
      VoidOrReprintMarkdownRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.reprintMarkdown.value]!,
        requestType: RequestType.post,
        params: request.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Reprint previous markdown response: ${response?.resultJson}");
    if (response?.statusCode == StatusCodeEnum.success.statusValue) {
      MarkdownResponse res =
      performMarkdownResponseFromJson(response!.resultJson);
      return PerformInitialMarkdownResponse(
          statusCode: response.statusCode, response: res);
    }
    return PerformInitialMarkdownResponse(
        statusCode: response?.statusCode ?? 400,
        error: response?.errorResponse?.title ?? response?.error);
  }

  Future<MarkdownCandidateResponse> apiCallGetMLUCandidate({required MLUCandidateRequest request}) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.getMluMarkdownCandidate.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Get MLU candidate: ${response?.resultJson}");
    if (response?.statusCode == StatusCodeEnum.success.statusValue) {
      List<MarkdownData> markdownData =
      markdownDataFromJson(response!.resultJson);
      return MarkdownCandidateResponse(
          statusCode: response.statusCode, markdownData: markdownData);
    }
    return MarkdownCandidateResponse(
        statusCode: response?.statusCode ?? 400,
        error: response?.errorResponse?.title ?? response?.error);
  }

  Future<MarkdownCandidateResponse> apiCallGetMarkdownCandidate({required MarkdownCandidateRequest request}) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.getInitialMarkdownCandidate.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(apiRequest: apiRequest);
    logger.d("Get Initial markdown candidate: ${response?.resultJson}");
    if (response?.statusCode == StatusCodeEnum.success.statusValue) {
      List<MarkdownData> markdownData =
      markdownDataFromJson(response!.resultJson);
      return MarkdownCandidateResponse(
          statusCode: response.statusCode, markdownData: markdownData);
    }
    return MarkdownCandidateResponse(
        statusCode: response?.statusCode ?? 400,
        error: response?.errorResponse?.title ?? response?.error);
  }

  Future<SubsMarkdownsPricePointResponse> subsMarkdownsPricePointsAPI(
      SubsMarkdownsCachingRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.subsequentMarkdownsPricePoints.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Get Subs Markdowns Price points data response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = subsMarkdownPricePointResponseFromJson(response.resultJson);
      return SubsMarkdownsPricePointResponse(
          status: response.statusCode,
        data: result
      );
    } else {
      return SubsMarkdownsPricePointResponse(
          status: response?.statusCode ?? 400, error: response?.error);
    }
  }

  Future<SubsMarkdownsRangesResponse> subsMarkdownsRangesAPI(
      SubsMarkdownsCachingRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.subsequentMarkdownsRanges.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Get Subs Markdowns Ranges data response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = subsMarkdownRangeResponseFromJson(response.resultJson);
      return SubsMarkdownsRangesResponse(
          status: response.statusCode,
        data: result
      );
    } else {
      return SubsMarkdownsRangesResponse(
          status: response?.statusCode ?? 400, error: response?.error);
    }
  }

  Future<SubsMarkdownsExceptionResponse> subsMarkdownsExceptionsAPI(
      SubsMarkdownsCachingRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.subsequentMarkdownsExceptions.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Get Subs Markdowns Exception data response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = subsMarkdownExceptionResponseFromJson(response.resultJson);
      return SubsMarkdownsExceptionResponse(
          status: response.statusCode,
        data: result
      );
    } else {
      return SubsMarkdownsExceptionResponse(
          status: response?.statusCode ?? 400, error: response?.error);
    }
  }

  Future<SubsMarkdownsGuidesResponse> subsMarkdownsGuidesAPI(
      SubsMarkdownsCachingRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.subsequentMarkdownsGuides.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Get Subs Markdowns Guides data response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = subsMarkdownGuidesResponseFromJson(response.resultJson);
      return SubsMarkdownsGuidesResponse(
          status: response.statusCode,
        data: result
      );
    } else {
      return SubsMarkdownsGuidesResponse(
          status: response?.statusCode ?? 400, error: response?.error);
    }
  }

  Future<SubsMarkdownsClassUlineResponse> subsMarkdownsUlineClassAPI(
      SubsMarkdownsCachingRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.subsequentMarkdownsUlineClass.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Get Subs Markdowns Uline and class data response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = subsMarkdownUlineClassResponseFromJson(response.resultJson);
      return SubsMarkdownsClassUlineResponse(
          status: response.statusCode,
        data: result
      );
    } else {
      return SubsMarkdownsClassUlineResponse(
          status: response?.statusCode ?? 400, error: response?.error);
    }
  }

  Future<SubsMarkdownsDepartmentCodesResponse> subsMarkdownsDepartmentCodesAPI(
      SubsMarkdownsCachingRequest request) async {
    APIRequest apiRequest = APIRequest(
        url: apiConstant.getBaseurl()! +
            apiConstant.appSettings!.api[ApiEnum.subsequentMarkdownsDepartmentCodes.value]!,
        requestType: RequestType.get,
        params: request.toJson());
    final response = await _networkService.sendRequest(
        apiRequest: apiRequest, showLoading: false);
    logger.d("Get Subs Markdowns Department Codes data response: ${response?.resultJson}");
    if (response != null &&
        response.statusCode == StatusCodeEnum.success.statusValue) {
      var result = subsMarkdownDepartmentCodesResponseFromJson(response.resultJson);
      return SubsMarkdownsDepartmentCodesResponse(
          status: response.statusCode,
        data: result
      );
    } else {
      return SubsMarkdownsDepartmentCodesResponse(
          status: response?.statusCode ?? 400, error: response?.error);
    }
  }
}
